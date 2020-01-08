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
- You must specify the username and password for the root user creating a secret `mongodb-credentials` with the following keys:
  - `username`
  - `password`

## Deployment

You can deploy MongoDB by running following command in the root of the project:

```shell
$ kustomize build | kubectl apply -f -
```

## License

For license details please see [LICENSE](https://sighup.io/fury/license)
