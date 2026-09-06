# simple-http-logger

A Helm chart for [simple-http-logger](https://github.com/cycodelabs/simple-http-logger), a minimal HTTP request logger.

## Introduction

This chart bootstraps a single [simple-http-logger](https://github.com/cycodelabs/simple-http-logger) deployment on a Kubernetes cluster using the Helm package manager. The app responds on the service port and is useful for development and debugging, e.g. as an ingress or network-policy test target.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.7+ (Helm 4.x recommended)

## Installing the chart

Install from the GHCR OCI registry:

```sh
helm install simple-http-logger oci://ghcr.io/hurzelpurzel/simple-http-logger --version 0.2.0
```

If you have the repository checked out locally, you can also install directly from the chart directory:

```sh
helm install simple-http-logger ./simple-http-logger
```

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Container image repository | `cycodelabs/simple-http-logger` |
| `image.tag` | Container image tag (defaults to `appVersion`) | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `8080` |
| `ingress.enabled` | Whether to create an Ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.hosts` | Ingress host rules | `chart-example.local` |
| `autoscaling.enabled` | Whether to enable an HPA | `false` |
| `resources` | Container resource requests/limits | `{}` |
| `nodeSelector` | Node selector labels | `{}` |
| `tolerations` | Pod tolerations | `[]` |
| `affinity` | Pod affinity rules | `{}` |

## Upgrading

```sh
helm upgrade simple-http-logger oci://ghcr.io/hurzelpurzel/simple-http-logger --version <new-version>
```

## Uninstalling

```sh
helm uninstall simple-http-logger
```

## License

Apache-2.0
