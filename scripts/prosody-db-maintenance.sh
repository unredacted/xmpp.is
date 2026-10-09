#!/bin/bash
# Cleans up rows in Prosody's SQL archive table that nothing will ever read or expire.
#
#   - "archive" store: the legacy MAM store from before archive_store = "archive2". MAM only
#     expires the store it uses, so these rows were never cleaned up.
#   - "offline" store: undelivered offline messages. mod_offline has no age or size limit,
#     so messages to abandoned accounts pile up forever.
#
# Only rows older than RETENTION_DAYS (matching archive_expires_after) are touched.
# Deletes run in small committed batches with pauses, so Prosody's own (synchronous)
# queries never wait long on our locks. Run it at a quiet time, it scans the whole table once.
#
# Usage: prosody-db-maintenance.sh [--delete] [archive|offline ...]
#   Without --delete it only reports how many rows would be removed (dry run).
#   Take a backup before using --delete.

RETENTION_DAYS=90
BATCH_SIZE=1000
PAUSE_SECONDS=0.5
DB="prosody"

DELETE=0
STORES=()
for ARG in "$@"; do
  case "${ARG}" in
    --delete) DELETE=1 ;;
    archive|offline) STORES+=("${ARG}") ;;
    *) echo "Unknown parameter detected: ${ARG}" >&2; exit 1 ;;
  esac
done
[ ${#STORES[@]} -eq 0 ] && STORES=(archive offline)

function psql_prosody {
  runuser -u postgres -- psql -X -q -v ON_ERROR_STOP=1 -d "${DB}" "$@"
}

# Stop at the first failed step, so a partial run is never reported as success.
# Deletes are committed per batch, re-running after a failure just continues.
function fail {
  echo "Failed: $1, stopping" >&2
  exit 1
}

for STORE in "${STORES[@]}"; do
  echo "== Store '${STORE}', rows older than ${RETENTION_DAYS} days"
  if [ "${DELETE}" -eq 0 ]; then
    psql_prosody -v store="${STORE}" -v days="${RETENTION_DAYS}" <<'EOF' || fail "dry run of store '${STORE}'"
SELECT count(*) AS rows_to_delete,
       to_timestamp(min("when"))::date AS oldest,
       to_timestamp(max("when"))::date AS newest
  FROM prosodyarchive
 WHERE store = :'store' AND "when" < extract(epoch FROM now() - make_interval(days => :days))::bigint;
EOF
    continue
  fi

  psql_prosody -v store="${STORE}" -v days="${RETENTION_DAYS}" -v batch="${BATCH_SIZE}" -v pause="${PAUSE_SECONDS}" <<'EOF' || fail "deleting from store '${STORE}'"
-- Find the rows once (single sequential scan), then delete them by primary key in batches
CREATE TEMP TABLE doomed AS
  SELECT sort_id FROM prosodyarchive
   WHERE store = :'store' AND "when" < extract(epoch FROM now() - make_interval(days => :days))::bigint;
CREATE INDEX ON doomed (sort_id);
SELECT count(*) AS rows_to_delete FROM doomed \gset
\echo Deleting :rows_to_delete rows
SET my.batch = :batch;
SET my.pause = :pause;
DO $$
DECLARE
  deleted bigint;
  total bigint := 0;
BEGIN
  LOOP
    WITH batch AS (
      DELETE FROM doomed WHERE sort_id IN (SELECT sort_id FROM doomed LIMIT current_setting('my.batch')::int)
      RETURNING sort_id
    )
    DELETE FROM prosodyarchive a USING batch b WHERE a.sort_id = b.sort_id;
    GET DIAGNOSTICS deleted = ROW_COUNT;
    EXIT WHEN NOT EXISTS (SELECT 1 FROM doomed);
    total := total + deleted;
    COMMIT;
    PERFORM pg_sleep(current_setting('my.pause')::float);
  END LOOP;
  COMMIT;
  RAISE NOTICE 'Done, deleted % rows', total + deleted;
END
$$;
EOF
done

if [ "${DELETE}" -eq 1 ]; then
  echo "== Vacuuming prosodyarchive (makes the freed space reusable, does not lock the table)"
  psql_prosody -c "VACUUM (ANALYZE) prosodyarchive;" || fail "vacuum"
fi
