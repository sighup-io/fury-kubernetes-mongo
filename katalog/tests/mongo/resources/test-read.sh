#!/usr/bin/env

set -u
set -o pipefail

MONGO_URI="mongodb+srv://mongo.mongo.svc.cluster.local/?replicaSet=rs0&ssl=false"

count=0
echo $count
echo $DOCUMENTS
while [[ "${count}" != "${DOCUMENTS}" ]]; do
  now="$(date +%Y%m%d-%H%M%S)"
  echo "${now} Count ${count}"
  count=$(mongo --host="$MONGO_URI" -u "${MONGO_INITDB_ROOT_USERNAME}" -p "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase admin --quiet --eval="db.test.count({\"key\": \"value\"})" | tail -1)
  sleep 5
  echo
done

exit 0
