# mock-app

Mock of the `ccf-app` chart, deploying `mock-api` and `mock-ui`, used to develop and test CCF
release automation; it is not a product. release-please owns this chart's `version` (tags
`mock-app-vX.Y.Z`), and `release-helm.yml` pushes each release to
`oci://ghcr.io/compliance-framework/helm-charts/mock-app`.
