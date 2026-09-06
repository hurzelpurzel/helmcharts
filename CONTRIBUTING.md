# Contributing to helmcharts

Thanks for contributing! This repository is a collection of independent Helm charts, one per top-level directory.

## Project layout

- One Helm v2 chart per top-level directory (e.g. `backrest/`, `db2rest/`, `simple-http-logger/`).
- Each chart is standalone: `Chart.yaml`, `values.yaml`, and `templates/` with a `_helpers.tpl`. No `charts/` directory, no chart dependencies.

## Chart conventions

- Every chart has `Chart.yaml`, `values.yaml`, `templates/`, and `templates/_helpers.tpl`.
- Bump `version` in `Chart.yaml` when you change a chart.
- Keep `appVersion` in sync with the upstream app version unless the image tag is pinned in `values.yaml`.
- When adding a chart, add a matching row to `README.md`.

## Verifying your changes

Validate the chart locally before opening a PR (Helm 4.x):

```sh
helm lint <chart-dir>
helm template <test-release> <chart-dir>
```

The `ci-helm-ghcr` GitHub Actions workflow lints and packages every chart and pushes published charts to GHCR as OCI artifacts.

## Pull requests

1. Make focused changes to a single chart.
2. Bump the chart `version` if you changed it.
3. Run `helm lint` and `helm template` on the affected chart.
4. Open a PR against `main`.

## License

By contributing you agree that your contributions are licensed under the [Apache-2.0](LICENSE) license of this repository.
