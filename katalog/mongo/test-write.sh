#!/usr/bin/env bash

# set -e
set -u
set -o pipefail

MONGO_URI="mongodb://mongo-0.mongo:27017,mongo-1.mongo:27017,mongo-2.mongo:27017/?replicaSet=rs0"

while true; do
  now="$(date +%Y%m%d-%H%M%S)"
  echo "$now"
  mongo --host="$MONGO_URI" --quiet -u "${MONGO_INITDB_ROOT_USERNAME}" -p "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase admin --eval="db.test.insert({\"key\": \"value\", \"now\": \""$now"\"}).nInserted"
  echo
  sleep 2
done

exit 0

