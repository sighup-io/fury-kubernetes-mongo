# Fury Kubernetes MongoDB

This repo contains Mongo database and web-based MongoDB admin interface.

## Requirements

All packages in this repository have following dependencies, for package
specific dependencies please visit the single package's documentation:

- [Kubernetes](https://kubernetes.io) >= `v1.10.0`
- [Furyctl](https://github.com/sighup-io/furyctl) package manager to install Fury packages
- [Kustomize](https://github.com/kubernetes-sigs/kustomize) >= `v1`

## Packages

Following packages are included in Fury Kubernetes MongoDB katalog. All
resources in these packages are going to be deployed in `mongo` namespace in
your Kubernetes cluster.

- [mongo](katalog/mongo): MongoDB NoSQL database 
- [mongo-express](katalog/mongo-express): Web-based admin interface for Mongo


## License

For license details please see [LICENSE](https://sighup.io/fury/license)
