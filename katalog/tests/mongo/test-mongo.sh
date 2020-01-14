#!/usr/bin/env bats

load ./../helper


@test "Deploy Tests" {
    info
    deploy() {
        apply katalog/tests/mongo/resources
    }
    run deploy
    [ "$status" -eq 0 ]
}

@test "Tests" {
    info
    test() {
        kubectl -n mongo wait --for=condition=complete job --all --timeout=300s
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Delete Tests" {
    info
    deploy() {
        delete katalog/tests/mongo/resources
    }
    run deploy
    [ "$status" -eq 0 ]
}
