# AGENTS.md

Independent Helm v2 application charts, one per top-level directory. No tests or build tooling; each chart stands alone.

## Layout

- `backrest/` — chart for garethgeorge/backrest (restic backup web UI). Notable: PVCs are declared in `templates/pvcs.yaml` and mounted via `volumes`/`volumeMounts` in `values.yaml` referencing hardcoded claim names (`br-data-pvc`, `br-config-pvc`, `br-userdata-pvc`). `storageClassName` defaults to `microk8s-hostpath`.
- `db2rest/`, `simple-http-logger/` — standard generator-style charts (deployment/service/ingress/hpa/serviceaccount + `_helpers.tpl`).

## Conventions

- Standard files per chart: `Chart.yaml`, `values.yaml`, `templates/` with `_helpers.tpl`, plus `.helmignore`. No `charts/` dir, no dependencies.
- Every chart also ships `README.md` and `LICENSE` (Apache-2.0) — Artifact Hub renders the README on the package page and reads the license from the LICENSE file.
- `Chart.yaml` carries `artifacthub.io/*` annotations (category, links, maintainers, changes) and `licenses: Apache-2.0` (used as OCI license annotation by `helm push`).
- Bump `version` in `Chart.yaml` when changing a chart; keep `appVersion` in sync with the upstream app unless the upstream image tag is pinned in `values.yaml`. Artifact Hub only sees a new release when `version` changes (it must be valid semver — OCI tags are derived from it).

## CI

`.github/workflows/helm.yaml` (`ci-helm-ghcr`) lints and packages **every** `*/Chart.yaml` directory and, on push to `main`, pushes the `.tgz`s to GHCR (`oci://ghcr.io/<owner>/<chart-name>`, tagged by chart version). There is **no root `Chart.yaml`** — `helm lint .`/`helm package .` at the repo root fail, which is why the workflow loops over chart dirs.

## Publishing (Artifact Hub)

- Charts are published on Artifact Hub as *Helm OCI* repositories registered per chart: `oci://ghcr.io/hurzelpurzel/{backrest,db2rest,simple-http-logger}` (see README "Publishing to Artifact Hub").
- `artifacthub-repo.yml` at the repo root holds `owners` (email must match the Artifact Hub login). Leave `repositoryID` unset until the repo is registered in the control panel, then fill it in to enable the Verified Publisher flag. For OCI repos the file must be pushed via `oras` under the `artifacthub.io` tag.
- Registry push (with an existing .tgz) is done by `helm push chart.tgz oci://ghcr.io/<owner>` — Helm infers the package basename from the chart name and the tag from the semver `version`, so `version` bumps drive new OCI tags.

## Verify

Lint/validate an individual chart (helm 4.x installed):

```sh
helm lint <chart-dir>
helm template <release-name> <chart-dir> --debug
```

Preview the packaged artifact before pushing:

```sh
helm package <chart-dir>
tar -tzf <chart-dir>*.tgz   # README.md and LICENSE must be present
```
