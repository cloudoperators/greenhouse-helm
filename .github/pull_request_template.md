<!--
Please ensure the PR title follows the conventional commit format:
<type>(<scope>): description

where <scope> is typically the affected chart (e.g. gateway, manager, authz, idproxy, dashboard, cors-proxy).
For a list of accepted types and scopes see the workflow documentation: https://github.com/cloudoperators/greenhouse-helm/blob/main/.github/workflows/ci-pr-title.yaml

-->

## Description
<!--
Please do not leave this blank.
This PR [adds/removes/fixes/replaces] the [feature/bug/etc].

Please include a summary of the changes and the related issue. Please also include relevant motivation and context. List any dependencies (e.g. CRDs, sub-charts) that are required for this change.
-->

## What type of PR is this? (check all applicable)

- [ ] 🍕 Feature
- [ ] 🐛 Bug Fix
- [ ] 📝 Documentation Update
- [ ] 🎨 Style
- [ ] 🧑‍💻 Chart Refactor
- [ ] 🔥 Performance Improvements
- [ ] ✅ Test
- [ ] 🤖 Build
- [ ] 🔁 CI
- [ ] 📦 Chore (Release)
- [ ] ⏩ Revert

## Charts affected
<!--
List the charts touched by this PR and whether the change is backwards compatible.
-->

- Chart(s): <!-- e.g. gateway, manager -->
- [ ] I bumped the `version` in each affected `Chart.yaml`
- [ ] This change is backwards compatible for existing releases (no breaking `values.yaml` or template changes)

## Related Tickets & Documents

<!--
Please use this format to link issue numbers: Fixes #123
https://docs.github.com/en/free-pro-team@latest/github/managing-your-work-on-github/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword

- Related Issue # (issue)
- Closes # (issue)
- Fixes # (issue)

-->

## How was this tested?

- [ ] `ct lint` passes for the affected chart(s)
- [ ] `helm template` renders as expected (including relevant `--set` / `-f ci/*-values.yaml` combinations)
- [ ] `ct install` against a cluster
- [ ] 🙅 not needed, because <!-- reason -->

<!--
Please describe the tests/renders you ran to verify your changes and provide the commands so we can reproduce them. List any relevant values overrides or CRD prerequisites.
-->

## Added to documentation?

- [ ] 📜 chart `README.md` updated
- [ ] 💬 `values.yaml` keys documented with comments
- [ ] 🧪 `ci/*-values.yaml` fixture added/updated for new values
- [ ] 🙅 no documentation needed

## Checklist

- [ ] My changes follow the conventions of this repository
- [ ] I have performed a self-review of my changes
- [ ] I have commented new/changed `values.yaml` keys, particularly non-obvious ones
- [ ] My changes generate no new `helm lint` / `ct lint` warnings
- [ ] I bumped the chart `version` for every chart I changed
