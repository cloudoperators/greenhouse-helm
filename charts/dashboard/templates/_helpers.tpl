{{/*
Resource name: avoids double "dashboard-dashboard" when the release name already
contains "dashboard". Falls back to "<release>-dashboard" otherwise.
*/}}
{{- define "dashboard.fullname" -}}
{{- if contains "dashboard" .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-dashboard" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/* Render the dashboard hostname */}}
{{- define "dashboard.hostname" -}}
{{- printf "%s.%s" "dashboard" (required "global.dnsDomain missing" .Values.global.dnsDomain) }}
{{- end }}

{{/* Render the auth hostname */}}
{{- define "dashboard.auth.hostname" -}}
{{- printf "https://%s.%s" "auth" (required "global.dnsDomain missing" .Values.global.dnsDomain) }}
{{- end }}

{{/* Render the k8s api hostname */}}
{{- define "dashboard.api.hostname" -}}
{{- printf "https://%s.%s" (default "api" .Values.global.kubeAPISubDomain) (required "global.dnsDomain missing" .Values.global.dnsDomain) }}
{{- end }}

{{/*
Print the image reference. Digest takes precedence over tag.
*/}}
{{- define "dashboard.image" -}}
{{- $repository := ( required ".Values.image.repository missing" .Values.image.repository ) -}}
{{- $digest := .Values.image.digest -}}
{{- if $digest -}}
  {{- printf "%s@%s" $repository $digest -}}
{{- else -}}
  {{- printf "%s:%s" $repository ( required ".Values.image.tag missing" .Values.image.tag ) -}}
{{- end -}}
{{- end -}}

{{/*
Bundled cors-proxy: fully qualified name, derived from the dashboard name.
*/}}
{{- define "cors-proxy.fullname" -}}
{{- printf "%s-cors-proxy" (include "dashboard.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
cors-proxy selector labels
*/}}
{{- define "cors-proxy.selectorLabels" -}}
app.kubernetes.io/name: cors-proxy
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
cors-proxy common labels
*/}}
{{- define "cors-proxy.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "cors-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
cors-proxy image reference. Digest takes precedence over tag.
*/}}
{{- define "cors-proxy.image" -}}
{{- $repository := .Values.cors.image.repository -}}
{{- $digest := .Values.cors.image.digest -}}
{{- if $digest -}}
  {{- printf "%s@%s" $repository $digest -}}
{{- else -}}
  {{- printf "%s:%s" $repository ( required ".Values.cors.image.tag missing" .Values.cors.image.tag ) -}}
{{- end -}}
{{- end -}}

{{/*
cors-proxy service account name
*/}}
{{- define "cors-proxy.serviceAccountName" -}}
{{- if .Values.cors.serviceAccount.create }}
{{- default (include "cors-proxy.fullname" .) .Values.cors.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.cors.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Render the k8s api hostname (bare host, no scheme) */}}
{{- define "cors-proxy.api.hostname" -}}
{{- printf "%s.%s" (default "api" .Values.global.kubeAPISubDomain) (required "global.dnsDomain missing" .Values.global.dnsDomain) }}
{{- end }}
