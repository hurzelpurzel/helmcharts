# AGENTS.md

Independent Helm v2 application charts, one per top-level directory. No tests or build tooling; each chart stands alone.

## Layout

- `backrest/` — chart for garethgeorge/backrest (restic backup web UI). Notable: PVCs are declared in `templates/pvcs.yaml` and mounted via `volumes`/`volumeMounts` in `values.yaml` referencing hardcoded claim names (`br-data-pvc`, `br-config-pvc`, `br-userdata-pvc`). `storageClassName` defaults to `microk8s-hostpath`.
- `db2rest/`, `simple-http-logger/` — standard generator-style charts (deployment/service/ingress/hpa/serviceaccount + `_helpers.tpl`).

## Conventions

- Standard files per chart: `Chart.yaml`, `values.yaml`, `templates/` with `_helpers.tpl`, plus `.helmignore`. No `charts/` dir, no dependencies.
- Bump `version` in `Chart.yaml` when changing a chart; keep `appVersion` in sync with the upstream app unless the upstream image tag is pinned in `values.yaml`.

## CI

`.github/workflows/helm.yaml` (`ci-helm-ghcr`) lints and packages **every** `*/Chart.yaml` directory and, on push to `main`, pushes the `.tgz`s to GHCR (`oci://ghcr.io/<owner>`, one package per chart name). There is **no root `Chart.yaml`** — `helm lint .`/`helm package .` at the repo root fail, which is why the workflow loops over chart dirs.

## Verify

Lint/validate an individual chart (helm 4.x installed):

```sh
helm lint <chart-dir>
helm template <release-name> <chart-dir> --debug
```
