# mock-helm-charts

Mock repo for developing CCF release automation. Not a product.

Mirrors [compliance-framework/helm-charts](https://github.com/compliance-framework/helm-charts)
in miniature:

| Chart | Mirrors | Images |
|---|---|---|
| `charts/mock-app` | `ccf-app` | `api.image` (`mock-api`, tag defaults to `appVersion`), `ui.image` (`mock-ui`, explicit `ui.image.tag`) |
| `charts/mock-agent` | `ccf-agent` | `image` (`mock-agent`, tag defaults to `appVersion`) |

`appVersion` and `ui.image.tag` start at `0.0.0`; `ccf-bump` sets real versions once the mocks
release.

## Checks

```sh
helm lint charts/*
make helm.test.app      # lint + snapshot diff + default image tags for mock-app
make helm.test.agent    # same for mock-agent
make helm.test          # both
ct lint --config ct.yaml
```

The snapshots in `tests/snapshots/` render with pinned image tags, so a version bump does not
change them. After changing a template or `values.yaml`, regenerate them with
`make helm.snapshot.app` / `make helm.snapshot.agent` and commit the result.
