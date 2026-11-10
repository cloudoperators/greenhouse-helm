<!--
SPDX-FileCopyrightText: 2026 SAP SE or an SAP affiliate company and Greenhouse contributors
SPDX-License-Identifier: Apache-2.0
-->

# greenhouse-organization

A Helm chart for the resources required to run a Greenhouse admin organization.

This chart provisions, in a single release:

- the **Organization** CR (with optional OIDC / SCIM authentication wiring),
- **Team** CRs mapped to IdP groups,
- the organization **RBAC** (cluster-admin binding + support role/binding),
- **Catalog** CRs for sourcing `PluginDefinition`s, and
- a set of opt-in extension **Plugin** CRs (cert-manager, ingress-nginx, thanos,
  kube-monitoring, external-dns, gatekeeper, perses, …).

## Prerequisites

This chart only creates Greenhouse custom resources; it does **not** ship the CRDs or the
controller. A running Greenhouse control plane must already be installed (the `greenhouse` chart),
which owns the `Organization`, `Team`, `Catalog` and `Plugin` CRDs.

## Installation

Two-step install — Greenhouse core first, then the organization:

```sh
# 1. Greenhouse control plane (provides CRDs + controller)
helm install greenhouse oci://ghcr.io/cloudoperators/greenhouse-helm/charts/greenhouse -n greenhouse --create-namespace

# 2. The admin organization
helm install greenhouse-organization oci://ghcr.io/cloudoperators/greenhouse-helm/charts/greenhouse-organization -n greenhouse
```

Cross-chart settings (e.g. `global.dnsDomain`) follow the repository's shared
`global:` values convention — pass the same globals to each release. Organization-specific
identity settings live under `organization.oidc.*`.

The release namespace is used as the organization name; install into the namespace that should
back the organization.
