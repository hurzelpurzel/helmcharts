# db2rest

A Helm chart for [db2rest](https://db2rest.com), a universal and ready-to-use REST read/write API for any SQL database.

## Introduction

This chart bootstraps a [db2rest](https://db2rest.com/docs/run-db2rest-on-docker) deployment on a Kubernetes cluster using the Helm package manager. db2rest exposes a SQL database (PostgreSQL, MySQL/MariaDB, SQL Server, Oracle, ...) through a generated REST and GraphQL API with OpenAPI support.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.7+ (Helm 4.x recommended)
- A reachable SQL database that db2rest can connect to

## Installing the chart

Install from the GHCR OCI registry:

```sh
helm install db2rest oci://ghcr.io/hurzelpurzel/db2rest --version 0.2.0
```

If you have the repository checked out locally, you can also install directly from the chart directory:

```sh
helm install db2rest ./db2rest
```

## Database connection

db2rest connects to your database via the `env` values. The connection URL is a JDBC-style URL matching your database:

```yaml
env:
  - name: DB_URL
    value: "jdbc:postgresql://postgres:5432/mydb"
  - name: DB_USER
    value: "mydbuser"
  - name: DB_PASSWORD
    value: "mydbpassword"
```

For other databases, see the upstream [db2rest docs](https://db2rest.com/docs). Use a separate values file for credentials and avoid committing real passwords:

```sh
helm install db2rest ./db2rest -f my-values.yaml
```

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Container image repository | `kdhrubo/db2rest` |
| `image.tag` | Container image tag (defaults to `appVersion`) | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `env` | Environment variables, e.g. `DB_URL`, `DB_USER`, `DB_PASSWORD` | db2rest defaults |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | db2rest port | `8080` |
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
helm upgrade db2rest oci://ghcr.io/hurzelpurzel/db2rest --version <new-version>
```

## Uninstalling

```sh
helm uninstall db2rest
```

## License

Apache-2.0
