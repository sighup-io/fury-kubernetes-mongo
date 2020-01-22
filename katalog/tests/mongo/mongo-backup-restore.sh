#!/usr/bin/env bats

load ./../helper

@test "Trigger Backup" {
    info
    test() {
        kubectl create job --from=cronjob/mongo-backup mongo-backup-manual-test -n mongo
        kubectl -n mongo wait --for=condition=complete job --all --timeout=30s
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Accidentally delete all documents" {
    info
    test() {
        kubectl apply -f katalog/tests/mongo/resources/accident.yml -n mongo
        kubectl -n mongo wait --for=condition=complete job --all --timeout=30s
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Restore Backup" {
    info
    test() {
        kubectl apply -f katalog/tests/mongo/resources/restore.yml -n mongo
        kubectl -n mongo wait --for=condition=complete job --all --timeout=30s
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Test Read" {
    info
    test() {
        kubectl create cm test-read --from-file=test-read.sh=katalog/tests/mongo/resources/test-read.sh -n mongo
        kubectl apply -f katalog/tests/mongo/resources/test-read.yml -n mongo
        kubectl -n mongo wait --for=condition=complete job --all --timeout=60s
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Clean" {
    info
    kubectl delete job mongo-backup-manual-test -n mongo
    kubectl delete -f katalog/tests/mongo/resources/accident.yml -n mongo
    kubectl delete -f katalog/tests/mongo/resources/restore.yml -n mongo
    kubectl delete cm test-read -n mongo
    kubectl delete -f katalog/tests/mongo/resources/test-read.yml -n mongo
}
