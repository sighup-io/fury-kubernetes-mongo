#!/usr/bin/env

set -u
set -o pipefail

MONGO_URI="mongodb://mongo-0.mongo:27017,mongo-1.mongo:27017,mongo-2.mongo:27017/?replicaSet=rs0"

count=0
echo $count
echo $DOCUMENTS
while [[ "${count}" != "${DOCUMENTS}" ]]; do
  now="$(date +%Y%m%d-%H%M%S)"
  echo "${now} Count ${count}"
  count=$(mongo --host="$MONGO_URI" --quiet --eval="db.test.count({\"key\": \"value\"})" | tail -1)
  sleep 5
  echo
done

exit 0
