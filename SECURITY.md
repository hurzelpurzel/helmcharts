# Security Policy

## Reporting a vulnerability

Please report security vulnerabilities through GitHub's private vulnerability reporting on this repository:

<https://github.com/hurzelpurzel/helmcharts/security/advisories/new>

Do not open a public issue for a vulnerability. You can also email the maintainer directly at the address shown in the repository commits.

## Supported versions

This project does not use versioned releases. Fixes are applied to the `main` branch and published as OCI artifacts to GHCR. Use the latest published artifacts and redeploy with `helm pull`/`helm install` when a fix lands.
