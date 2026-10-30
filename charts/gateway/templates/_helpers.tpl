{{/*
SPDX-FileCopyrightText: 2026 SAP SE or an SAP affiliate company and Greenhouse contributors
SPDX-License-Identifier: Apache-2.0
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gateway.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common helm labels.
*/}}
{{- define "gateway.labels" -}}
helm.sh/chart: {{ include "gateway.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "gateway.selectorLabels" . }}
{{- end }}

{{- define "gateway.selectorLabels" -}}
app: {{ include "gateway.name" . }}
app.kubernetes.io/name: {{ include "gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: gateway
{{- end }}

{{/*
Discovery server hostname.
*/}}
{{- define "gateway.hostname" -}}
{{- if .Values.discovery.hostname -}}
{{ .Values.discovery.hostname }}
{{- else -}}
{{ .Values.discovery.subDomain }}.{{ required "global.dnsDomain is required" .Values.global.dnsDomain }}
{{- end -}}
{{- end }}

{{/*
Whether the kgateway HorizontalPodAutoscaler support is active. HPA is a
kgateway-specific feature configured via GatewayParameters, so it is only
enabled when gateway.hpa.enabled is true AND the GatewayClass is kgateway.
Renders "true" when active, empty otherwise (use with `if`).
*/}}
{{- define "gateway.hpaEnabled" -}}
{{- if and .Values.gateway.hpa.enabled (eq .Values.gateway.className "kgateway") -}}
true
{{- end -}}
{{- end }}

{{/*
Render a Gateway API "namespaces" selector block (the body of an
allowedListeners.namespaces or allowedRoutes.namespaces field): the `from`
value plus, when from == "Selector", the required label `selector`.
The caller controls indentation via nindent on the include.
Fails fast if Selector is chosen without providing a selector, since
`from: Selector` with no selector is rejected by the API.
*/}}
{{- define "gateway.allowedNamespaces" -}}
from: {{ .Values.gateway.allowedListenersFrom }}
{{- if eq .Values.gateway.allowedListenersFrom "Selector" }}
{{- if not .Values.gateway.allowedListenersNamespaceSelector }}
{{- fail "gateway.allowedListenersNamespaceSelector is required when gateway.allowedListenersFrom=Selector" }}
{{- end }}
selector:
  {{- toYaml .Values.gateway.allowedListenersNamespaceSelector | nindent 2 }}
{{- end }}
{{- end }}
