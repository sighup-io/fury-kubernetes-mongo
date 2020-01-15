#!/usr/bin/env bats

load ./../helper

@test "Deploy mongo express configuration" {
    info
    deploy() {
        apply katalog/mongo-express/config
    }
    run deploy
    [ "$status" -eq 0 ]
}


@test "Deploy mongo express" {
    info
    deploy() {
        apply katalog/mongo-express
    }
    run deploy
    [ "$status" -eq 0 ]
}

@test "Mongo-express is Running" {
    info
    test() {
        kubectl get pods -l app=mongo-express -o json -n mongo |jq '.items[].status.containerStatuses[].ready' | uniq |grep -q true
    }
    loop_it test 30 2
    status=${loop_it_result}
    [ "$status" -eq 0 ]
}
