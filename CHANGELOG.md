# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

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
- New optional `subnet.network_security_group_id_wo` / `_wo_version` and
  `subnet.route_table_id_wo` / `_wo_version` tfvars keys, passed through to the new
  write-only NSG/Route Table association arguments on `azurerm_subnet` (azurerm >= 5.x).
  Intended only for Azure Policy environments that require an NSG/Route Table at subnet
  creation time — prefer the dedicated
  `azurerm_subnet_network_security_group_association` /
  `azurerm_subnet_route_table_association` resources otherwise.
- New `network_security_group_id` and `route_table_id` outputs, exposing the new
  attributes azurerm 5.0 exports on `azurerm_subnet`.
- `tests/subnet.tftest.hcl`: added `service_endpoint_new_format` and
  `network_security_group_and_route_table_wo` runs; fixed the `service_endpoints` run's
  assertion to read the new `service_endpoint` block instead of the removed
  `service_endpoints` attribute.
- `tests/upgrade_compat.tftest.hcl`: added `legacy_service_endpoints_list_format` run to
  verify pre-5.x callers using `service_endpoints` still produce an equivalent plan.

### Known blockers

- None. No module input variables were removed and no resource address changed; existing
  tfvars require no changes.
