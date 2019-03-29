#!/usr/bin/env bash

# Copyright 2018 The Kubernetes Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -u
set -o pipefail

PORT=27017
REPLICA_SET="${REPLICA_SET}"
SCRIPT_NAME="${0##*/}"
TIMEOUT="${TIMEOUT:-900}"

log() {
  local msg="$1"
  local timestamp
  timestamp="$(date --iso-8601=ns)"
  echo "[$timestamp] [$SCRIPT_NAME] $msg" 1>&2
}

retry_until() {
  local host="${1}"
  local cmd="${2}"
  local expected="${3}"
  local seconds=0

  until [[ $(mongo --host "${host}" --quiet --eval "${cmd}") == "${expected}" ]]; do
    sleep 1
    seconds=$((seconds + 1))

    if [[ "${seconds}" -ge "${TIMEOUT}" ]]; then
      log "Timeout for ${cmd} on ${host}. Exiting"
      exit 1
    fi

    log "Retrying ${cmd} on ${host}"
  done
}

declare -a PEERS

MY_HOSTNAME="$(hostname)"
PRIMARY=""
SERVICE_NAME=""

log "Bootstrapping MongoDB replica set $REPLICA_SET member: $MY_HOSTNAME"

log "Reading standard input..."
while read -ra line; do
  if [[ "${line}" == *"${MY_HOSTNAME}"* ]]; then
    SERVICE_NAME="$line"
  fi
  PEERS+=("${line}")
done

log "Peers: ${PEERS[*]}"

log "Waiting for MongoDB to be ready..."
retry_until "localhost" "db.adminCommand('ping').ok" "1"

# try to find a master
for peer in "${PEERS[@]}"; do
  log "Checking if ${peer} is primary"
  # Check rs.status() first since it could be in primary catch up mode which db.isMaster() doesn't show
  if [[ $(mongo --host "${peer}" --quiet --eval "rs.status().myState") == "1" ]]; then
    retry_until "${peer}" "db.isMaster().ismaster" "true"
    log "Found primary: ${peer}"
    PRIMARY="${peer}"
    break
  fi
done

if [[ "${PRIMARY}" == "${SERVICE_NAME}" ]]; then
  log "${SERVICE_NAME} is already PRIMARY"
elif [[ -n "${PRIMARY}" ]]; then
  if [[ $(mongo --host "${PRIMARY}" --quiet --eval "rs.conf().members.findIndex(m => m.host == '${SERVICE_NAME}:${PORT}')") == "-1" ]]; then
    log "Adding myself (${SERVICE_NAME}) to replica set..."
    if (mongo --host "${PRIMARY}" --eval "rs.add('${SERVICE_NAME}')" | grep 'Quorum check failed'); then
      log "Quorum check failed, unable to join replica set. Exiting prematurely."
      exit 1
    fi

    sleep 3

    log "Waiting for replica (${SERVICE_NAME}) to reach SECONDARY state..."
    retry_until "${SERVICE_NAME}" "rs.status().myState" "2"
    log '✓ Replica reached SECONDARY state.'
  fi
elif (mongo --quiet --eval "rs.status()" | grep -q "no replset config has been received"); then
  log "Initiating a new replica set with myself ($SERVICE_NAME)..."
  mongo --eval "rs.initiate({'_id': '${REPLICA_SET}', 'members': [{'_id': 0, 'host': '${SERVICE_NAME}'}]})"

  sleep 3

  log "Waiting for replica (${SERVICE_NAME}) to reach PRIMARY state..."
  retry_until "localhost" "db.isMaster().ismaster" "true"
  PRIMARY="${SERVICE_NAME}"
  log "✓ Replica (${SERVICE_NAME}) reached PRIMARY state."
fi

log "MongoDB bootstrap complete"

exit 0
