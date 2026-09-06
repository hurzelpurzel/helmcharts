# helmcharts

Independent Helm v2 application charts, one per top-level directory. No chart dependencies; each chart deploys standalone.

## Charts

| Chart | App | Description |
|-------|-----|-------------|
| [backrest](backrest/) | [garethgeorge/backrest](https://github.com/garethgeorge/backrest) | Web UI and automation for restic backups (Backblaze B2, S3, local, ...) |
| [db2rest](db2rest/) | [db2rest](https://db2rest.com) | Universal REST read/write API for any SQL database with OpenAPI support |
| [simple-http-logger](simple-http-logger/) | simple-http-logger | Minimal HTTP request logger |

## Usage

Deploy a chart with a release name:

```sh
helm install <release> ./<chart-dir>
```

Override the defaults with your own values file:

```sh
helm install <release> ./<chart-dir> -f my-values.yaml
```

See each chart's `values.yaml` for the available options. Charts are published to GHCR as OCI artifacts by the `ci-helm-ghcr` workflow.

## Development

Validate a chart locally (requires Helm 4.x):

```sh
helm lint <chart-dir>
helm template <release> <chart-dir>
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[Apache-2.0](LICENSE)
