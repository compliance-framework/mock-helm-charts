# mock-agent

Mock of the `ccf-agent` chart, deploying `mock-agent`, used to develop and test CCF release
automation; it is not a product. release-please owns this chart's `version` (tags
`mock-agent-vX.Y.Z`), and `release-helm.yml` pushes each release to
`oci://ghcr.io/compliance-framework/helm-charts/mock-agent`.
