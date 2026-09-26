# apprise

A Helm chart for [Apprise API](https://github.com/caronc/apprise), a notification web service that pushes to 1000+ services (Telegram, Discord, ntfy, mail, ...) and ships with an optional web UI.

## Introduction

This chart bootstraps a single-instance [Apprise API](https://appriseit.com/api/) deployment on a Kubernetes cluster using the Helm package manager. The API listens on port `8000` and can be reached through a Service, an Ingress, or a Gateway API `HTTPRoute`.

By default the pod runs in the hardened setup documented upstream: non-root, no Linux capabilities, read-only root filesystem and a writable in-memory `/tmp`.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.7+ (Helm 4.x recommended)
- A storage class for the PersistentVolumeClaims, unless `persistence` is disabled or `existingClaim` is used
- Gateway API CRDs, if `httpRoute.enabled` is set

## Installing the chart

Install from the GHCR OCI registry:

```sh
helm install apprise oci://ghcr.io/hurzelpurzel/apprise --version 0.2.0
```

If you have the repository checked out locally, you can also install directly from the chart directory:

```sh
helm install apprise ./apprise
```

Once the pod is running, the API and web UI are available at `http://<service>:8000/`.

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Container image repository | `caronc/apprise` |
| `image.tag` | Container image tag (defaults to `appVersion`) | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `imagePullSecrets` | Secrets for pulling from a private registry | `[]` |
| `nameOverride` / `fullnameOverride` | Override the generated resource names | `""` |
| `serviceAccount.create` | Whether to create a ServiceAccount | `true` |
| `serviceAccount.automount` | Mount the ServiceAccount API token | `true` |
| `serviceAccount.annotations` | ServiceAccount annotations | `{}` |
| `serviceAccount.name` | Name of the ServiceAccount to use | `""` |
| `podAnnotations` / `podLabels` | Extra pod annotations and labels | `{}` |
| `podSecurityContext` | Pod security context (uid/gid, read-only root filesystem) | hardened |
| `securityContext` | Container security context (drops all capabilities) | hardened |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `8000` |
| `containerPort` | Port the container listens on | `8000` |
| `ingress.enabled` | Whether to create an Ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.annotations` | Ingress annotations | `{}` |
| `ingress.hosts` | Ingress host rules | `apprise.local` |
| `ingress.tls` | Ingress TLS blocks | `[]` |
| `httpRoute.enabled` | Whether to create a Gateway API HTTPRoute | `false` |
| `httpRoute.parentRefs` | Gateways the route attaches to | `[]` |
| `httpRoute.hostnames` | Hostnames served by the route | `[]` |
| `httpRoute.annotations` | HTTPRoute annotations | `{}` |
| `httpRoute.rules` | HTTPRoute matches and filters | prefix `/` |
| `env` | Environment variables for the container | `APPRISE_STATEFUL_MODE=simple`, `APPRISE_WORKER_COUNT=1`, `APPRISE_ADMIN=y` |
| `persistence.config` | Claim for `/config` (saved configurations and state) | `1Gi`, `ReadWriteOnce` |
| `persistence.plugin` | Claim for `/plugin` (custom plugins) | `100Mi`, `ReadWriteOnce` |
| `persistence.attach` | Claim for `/attach` (uploaded attachments) | `1Gi`, `ReadWriteOnce` |
| `tmp` | In-memory `emptyDir` for `/tmp` | `medium: Memory` |
| `resources` | Container resource requests/limits | `{}` |
| `livenessProbe` / `readinessProbe` | Health checks against `/status` | enabled |
| `volumes` / `volumeMounts` | Additional volumes and mounts | `[]` |
| `nodeSelector` | Node selector labels | `{}` |
| `tolerations` | Pod tolerations | `[]` |
| `affinity` | Pod affinity rules | `{}` |

All environment variables supported by Apprise API can be appended to `env`, see the upstream [environment variable reference](https://appriseit.com/api/reference/environment/). Useful examples:

```yaml
env:
  - name: APPRISE_STATEFUL_MODE
    value: simple
  - name: APPRISE_WORKER_COUNT
    value: "1"
  - name: APPRISE_ADMIN
    value: "y"
  - name: TZ
    value: Europe/Berlin
  - name: APPRISE_ALLOW_SERVICES
    value: tgram,ntfy
  - name: SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: apprise-django
        key: secret-key
```

## Storage

`templates/pvcs.yaml` creates one PersistentVolumeClaim per enabled entry in `persistence`, named `<fullname>-config`, `<fullname>-plugin` and `<fullname>-attach`:

| Volume mount | Purpose |
|--------------|---------|
| `/config` | saved configurations and internal state |
| `/plugin` | custom plugins |
| `/attach` | uploaded attachments |
| `/tmp` | runtime files (pids, sockets, temp data), in-memory `emptyDir` |

Each key supports:

```yaml
persistence:
  config:
    enabled: true             # set to false to fall back to an emptyDir
    existingClaim: ""         # use a pre-existing claim instead of creating one
    annotations: {}           # e.g. for storage class migration tooling
    storageClassName: ""      # empty means the cluster default storage class
    accessMode: ReadWriteOnce
    size: 1Gi
```

> **Note**: `APPRISE_STATEFUL_MODE=simple` keeps configurations in files under `/config`, so keep `replicaCount` at `1` unless you use `ReadWriteMany` storage and an `APPRISE_WORKER_COUNT` matching the replica count.

## Access control

Apprise API does not implement authentication itself. Terminate TLS and require credentials in the Ingress controller or gateway, for example by mounting an nginx `.htpasswd` file:

```yaml
volumes:
  - name: nginx-htpasswd
    secret:
      secretName: apprise-htpasswd
volumeMounts:
  - name: nginx-htpasswd
    mountPath: /etc/nginx/.htpasswd
    readOnly: true
    subPath: .htpasswd
```

See the upstream [deployment documentation](https://appriseit.com/api/deployment/) for the full hardened setup.

## Upgrading

```sh
helm upgrade apprise oci://ghcr.io/hurzelpurzel/apprise --version <new-version>
```

## Uninstalling

```sh
helm uninstall apprise
```

> This deletes the claims created by the chart together with their data. Claims referenced through `persistence.*.existingClaim` are left untouched.

## License

Apache-2.0
