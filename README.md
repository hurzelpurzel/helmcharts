# helmcharts

Independent Helm v2 application charts, one per top-level directory. No chart dependencies; each chart deploys standalone.

## Charts

| Chart | App | Description |
|-------|-----|-------------|
| [backrest](backrest/) | [garethgeorge/backrest](https://github.com/garethgeorge/backrest) | Web UI and automation for restic backups (Backblaze B2, S3, local, ...) |
| [db2rest](db2rest/) | [kdhrubo/db2rest](https://db2rest.com) | Universal REST read/write API for any SQL database with OpenAPI support |
| [simple-http-logger](simple-http-logger/) | [cycodelabs/simple-http-logger](https://github.com/cycodelabs/simple-http-logger) | Minimal HTTP request logger |

## Usage

Deploy a chart with a release name:

```sh
helm install <release> ./<chart-dir>
```

Override the defaults with your own values file:

```sh
helm install <release> ./<chart-dir> -f my-values.yaml
```

See each chart's `values.yaml` for the available options.

Charts are also published to GHCR as OCI artifacts by the `ci-helm-ghcr` workflow, so they can be installed with:

```sh
helm install <release> oci://ghcr.io/hurzelpurzel/<chart-name>
```

## Development

Validate a chart locally (requires Helm 4.x):

```sh
helm lint <chart-dir>
helm template <release> <chart-dir>
```

## Publishing to Artifact Hub

Charts are discoverable on [Artifact Hub](https://artifacthub.io). Each chart ships with the metadata needed for a good package page: `README.md`, `LICENSE`, and the `artifacthub.io/` annotations in its `Chart.yaml` (category, links, maintainers, changelog).

`artifacthub-repo.yml` at the repo root carries the repository owner metadata and is used to claim ownership / verify the publisher.

### Option A: add each chart as an OCI repository (recommended)

The CI workflow pushes every chart to GHCR (`oci://ghcr.io/hurzelpurzel/<chart-name>`, tagged with the chart version). Register each chart in the Artifact Hub control panel (Repositories → Add) with kind *Helm OCI* and URL:

```
oci://ghcr.io/hurzelpurzel/backrest
oci://ghcr.io/hurzelpurzel/db2rest
oci://ghcr.io/hurzelpurzel/simple-http-logger
```

New chart versions are indexed automatically next time Artifact Hub processes the repositories.

To enable the **Verified Publisher** flag, fill the `repositoryID` field in `artifacthub-repo.yml` from the Artifact Hub control panel (one ID per repository) and push the file to each chart's OCI repository using [oras](https://oras.land) (the `artifacthub.io` tag):

```sh
oras push ghcr.io/hurzelpurzel/backrest:artifacthub.io \
  --config /dev/null:application/vnd.cncf.artifacthub.config.v1+yaml \
  artifacthub-repo.yml:application/vnd.cncf.artifacthub.repository-metadata.layer.v1.yaml
```

### Option B: host an HTTP chart repository

Package all charts and serve an `index.yaml` from a static host, then register the URL as a *Helm* repository. Artifact Hub will index every chart in the index.

### Releasing a new chart version

1. Bump `version` in the chart's `Chart.yaml`.
2. Push to `main` — the workflow packages and pushes the new version to GHCR.
3. Artifact Hub picks up the new version on its next repository sweep (no manual step).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[Apache-2.0](LICENSE)
