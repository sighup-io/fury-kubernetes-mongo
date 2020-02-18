#!/usr/bin/env bats

load ./../helper


@test "Deploy Read/Write Tests" {
    info
    deploy() {
        apply katalog/tests/mongo/resources
    }
    run deploy
    [ "$status" -eq 0 ]
}

@test "Tests Read/Write" {
    info
    test() {
        kubectl -n mongo wait --for=condition=complete job --all --timeout=300s
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Delete Read/Write Tests" {
    info
    deploy() {
        delete katalog/tests/mongo/resources
    }
    run deploy
    [ "$status" -eq 0 ]
}
