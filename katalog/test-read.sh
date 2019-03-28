#!/usr/bin/env

set -u
set -o pipefail

MONGO_URI="mongodb://mongo-0.mongo:27017,mongo-1.mongo:27017,mongo-2.mongo:27017/?replicaSet=rs0"

while true; do
  now="$(date +%Y%m%d-%H%M%S)"
  echo "$now"
  mongo --host="$MONGO_URI" --quiet --eval="db.test.find({\"key\": \"value\"})"
  echo
  sleep 5
done

exit 0
