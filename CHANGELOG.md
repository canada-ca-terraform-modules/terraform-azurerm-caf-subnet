# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Fixed

- `service_endpoint` blocks emitted in input order caused plan churn ("0 to add, N to
  change") whenever a caller reordered entries in tfvars, or when the azurerm provider
  read the blocks back in a different order than supplied. `service_endpoints_normalized`
  now sorts entries by `service` name before rendering, producing a deterministic block
  order regardless of tfvars input order.
- Added `tests/subnet.tftest.hcl` regression runs `service_endpoint_order_independent_input_a`
  / `_b` asserting that two tfvars inputs with the same service endpoints in reversed order
  produce an identical emitted block order.
- Bumped `ESLZ/subnet.tf` module ref from `v3.3.0` to `v3.3.1`.

## [3.3.0]

### Changed

- Upgraded provider constraint from `azurerm ~> 4.0` to `azurerm ~> 5.0`.
- **Breaking change absorbed**: azurerm 5.0 removed the `service_endpoints` (`list(string)`)
  argument on `azurerm_subnet` in favour of one-or-more `service_endpoint` blocks. The
  module's public `subnet.service_endpoints` tfvars key still works unchanged — it is
  normalized internally into `service_endpoint` blocks — so no caller changes are required.
- Bumped `ESLZ/subnet.tf` module ref from `v3.2.0` to `v3.3.0`.
- Bumped GitHub Actions: `actions/checkout` to `v7.0.1`, `hashicorp/setup-terraform` to
  `v4.0.1`. Replaced the unpinned `curl | bash` TFLint install in
  `.github/workflows/terraform-ci.yml` with the pinned `terraform-linters/setup-tflint@v6.3.0`
  action (`tflint_version: v0.64.0`).
- Fixed `.gitignore`: added a bare `*.tfvars` ignore rule above `!ESLZ/*.tfvars` — the
  negation was previously a no-op with no prior ignore rule, so tfvars files outside
  `ESLZ/` were not actually protected from being committed.
- Added trailing newline to `.gitattributes`.

### Added

- New optional `subnet.service_endpoint` tfvars key (list of objects with `service` and
  `network_identifier`) for callers who need to pin a `network_identifier` per service
  endpoint (azurerm >= 5.x).
- New `network_security_group_id` and `route_table_id` outputs, exposing the new
  attributes azurerm 5.0 exports on `azurerm_subnet`.
- `tests/subnet.tftest.hcl`: added `service_endpoint_new_format` and
  `service_endpoint_null_values` runs; fixed the `service_endpoints` run's assertion to
  read the new `service_endpoint` block instead of the removed `service_endpoints`
  attribute.
- `tests/upgrade_compat.tftest.hcl`: added `legacy_service_endpoints_list_format` run to
  verify pre-5.x callers using `service_endpoints` still produce an equivalent plan.

### Known blockers

- None. No module input variables were removed and no resource address changed; existing
  tfvars require no changes.
