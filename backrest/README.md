# backrest

A Helm chart for [backrest](https://github.com/garethgeorge/backrest), a web UI and built-in automation tool for [restic](https://restic.net/) backups.

## Introduction

This chart bootstraps a single-instance [backrest](https://github.com/garethgeorge/backrest) deployment on a Kubernetes cluster using the Helm package manager. backrest keeps a restic repository (local or remote, e.g. Backblaze B2, S3) and exposes a web UI on the service port.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.7+ (Helm 4.x recommended)

## Installing the chart

Install from the GHCR OCI registry:

```sh
helm install backrest oci://ghcr.io/hurzelpurzel/backrest --version 0.2.0
```

If you have the repository checked out locally, you can also install directly from the chart directory:

```sh
helm install backrest ./backrest
```

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Container image repository | `garethgeorge/backrest` |
| `image.tag` | Container image tag (defaults to `appVersion`) | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | backrest web UI port | `9898` |
| `ingress.enabled` | Whether to create an Ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.hosts` | Ingress host rules | `chart-example.local` |
| `pvcs.storageClassName` | Storage class for the data/config PVCs | `microk8s-hostpath` |
| `pvcs.size` | Size of the data/config PVCs | `10Mi` |
| `resources` | Container resource requests/limits | `{}` |
| `nodeSelector` | Node selector labels | `{}` |
| `tolerations` | Pod tolerations | `[]` |
| `affinity` | Pod affinity rules | `{}` |

## Storage

This chart declares three PersistentVolumeClaims (`br-data-pvc`, `br-config-pvc`, `br-userdata-pvc`) in `templates/pvcs.yaml`. The volumes and volume mounts are configured in `values.yaml` under `volumes` and `volumeMounts`, referencing the hardcoded claim names:

| Volume mount | Purpose |
|--------------|---------|
| `/data` | restic backup data |
| `/config` | backrest configuration (`config.json`) |
| `/userdata` | user data |
| `/cache` | cache (emptyDir) |

`pvcs.storageClassName` defaults to `microk8s-hostpath`; set it to a storage class matching your cluster when using a different environment.

> **Note**: backrest requires a restic repository to be configured from the web UI after the first install. See the upstream [backrest documentation](https://github.com/garethgeorge/backrest) for details.

## Upgrading

```sh
helm upgrade backrest oci://ghcr.io/hurzelpurzel/backrest --version <new-version>
```

## Uninstalling

```sh
helm uninstall backrest
```

> This does not delete the PVs or their data. To remove them as well, delete the `br-*-pvc` PersistentVolumeClaims manually.

## License

Apache-2.0
