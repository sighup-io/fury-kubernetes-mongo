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

- [mongo](katalog/mongo): MongoDB NoSQL database. Version: **4.2.2**
- [mongo-express](katalog/mongo-express): Web-based admin interface for MongoDB. Version **0.49**


## Compatibility

| Module Version / Kubernetes Version | 1.14.X             | 1.15.X             | 1.16.X             |
|-------------------------------------|:------------------:|:------------------:|:------------------:|
| v1.0.0                              |                    |                    |                    |

- :white_check_mark: Compatible
- :warning: Has issues
- :x: Incompatible

## License

For license details please see [LICENSE](https://sighup.io/fury/license)
