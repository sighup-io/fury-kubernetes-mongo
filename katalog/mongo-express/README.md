# Fury Kubernetes Mongo Express

Web-based admin interface for MongoDB.

## Image repository and tag

- Mongo Express image: `mongo-express:0.49`
- Mongo Express repository: https://github.com/mongo-express/mongo-express

## Requirements

- Kubernetes >= `1.10.0`
- Kustomize = `v1.0.10`

## Configuration

Mongo Express is deployed with following configuration:

- Replica number: `1`
- Creates a service `mongo-express` that listens on port `8081`
- Does not create an ingress.

## Deployment

You can deploy MongoDB by running following command in the root of the project:

```shell
$ kustomize build | kubectl apply -f -
```

You must create an additional secret named `mongo-express-credentials` with the credentials needed to connect to `mongo`. Example command:

```shell
$ kubectl create secret generic mongo-express-credentials \
--from-literal ME_CONFIG_MONGODB_ENABLE_ADMIN=true \
--from-literal ME_CONFIG_MONGODB_ADMINUSERNAME=<mongodb admin username> \
--from-literal ME_CONFIG_MONGODB_ADMINPASSWORD=<mongodb admin password> \
--from-literal ME_CONFIG_MONGODB_AUTH_DATABASE=<mongodb user database, default is admin> \
--from-literal ME_CONFIG_BASICAUTH_USERNAME=<if you want to enable http-auth for the web admin set this variable> \
--from-literal ME_CONFIG_BASICAUTH_PASSWORD=<if you want to enable http-auth for the web admin set this variable>
```

## License

For license details please see [LICENSE](https://sighup.io/fury/license)
