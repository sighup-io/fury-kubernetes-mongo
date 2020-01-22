#!/usr/bin/env bash

# set -e
set -u
set -o pipefail

MONGO_URI="mongodb://mongo-0.mongo:27017,mongo-1.mongo:27017,mongo-2.mongo:27017/?replicaSet=rs0"


failed=1
while [[ "${failed}" != "0"  ]]; do
  mongo --host="$MONGO_URI" -u "${MONGO_INITDB_ROOT_USERNAME}" -p "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase admin --quiet --eval="db.test.insert({\"key\": \"connection\"}).nInserted"
  failed=$?
  echo ${failed}
  sleep 5
  echo
done

for i in `seq 1 ${DOCUMENTS}`; do
  now="$(date +%Y%m%d-%H%M%S)"
  echo "$now"
  mongo --host="$MONGO_URI" -u "${MONGO_INITDB_ROOT_USERNAME}" -p "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase admin --quiet --eval="db.test.insert({\"key\": \"value\", \"now\": \""$now"\", \"i\": \""${i}"\"}).nInserted"
  echo
done

exit 0
