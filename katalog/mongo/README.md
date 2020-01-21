# Fury Kubernetes MongoDB Cluster 

Single node [MongoDB](https://mongodb.com) cluster, ready to be expanded to multi-node cluster. 

## Image repository and tag

- MongoDB image: `mongo:4.2.2`
- MongoDB repository: https://github.com/mongodb/mongo
- MongoDB documentation: https://docs.mongodb.com

## Requirements

- Kubernetes >= `1.10.0`
- Kustomize = `v1.0.10`

## Configuration

Fury distribution Mongo is deployed with following configuration:

- Replica number: `1`
- Resource limits are `1000m` for CPU and `2Gi` for memory
- Listens on port `27017` for db and on port `9126` for metrics
- In case of multi-node cluster automatic peer discovery and primary election

## Deployment

You can deploy MongoDB by running following command in the root of the project:

```shell
$ kustomize build | kubectl apply -f -
```

The following two secrets must also be created:

1. `mongodb-credentials`: root user credentials, must have the following keys:
    - `username`: root user username
    - `password`: root user password
1. `mongod-keyfile`: for replica count > 1 `mongod` uses a [keyFile](https://docs.mongodb.com/manual/core/security-internal-authentication/#internal-auth-keyfile) for authentication between replicas. The secret must have the following key:
    - `mongod.key`: is the keyFile contents with a shared passphrase between the replicas. You can create a keyFile using the following command `openssl rand -base64 756 > mongod.key`.

Please refer to mongo's [official documentation](https://docs.mongodb.com/manual/tutorial/deploy-replica-set-with-keyfile-access-control/#deploy-repl-set-with-auth) for more details on the keyFile.

## License

For license details please see [LICENSE](https://sighup.io/fury/license)
