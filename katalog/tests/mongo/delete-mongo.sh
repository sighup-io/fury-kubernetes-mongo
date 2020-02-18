#!/usr/bin/env bats

load ./../helper

@test "Delete MongoDB" {
    info
    deploy() {
        delete katalog/mongo
    }
    run deploy
    [ "$status" -eq 0 ]
}

@test "Delete Monitoring" {
    info
    kubectl delete -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v1.3.0/katalog/prometheus-operator/crd-servicemonitor.yml
    kubectl delete -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v1.3.0/katalog/prometheus-operator/crd-rule.yml
}
