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

{{/* Render the dashboard hostname. Override with .Values.dashboard.hostname (bare host). */}}
{{- define "dashboard.hostname" -}}
{{- if .Values.dashboard.hostname }}
{{- .Values.dashboard.hostname }}
{{- else }}
{{- printf "%s.%s" "dashboard" (required "global.dnsDomain missing" .Values.global.dnsDomain) }}
{{- end }}
{{- end }}

{{/* Render the auth hostname. Override with .Values.dashboard.authHostname (bare host). */}}
{{- define "dashboard.auth.hostname" -}}
{{- if .Values.dashboard.authHostname }}
{{- printf "https://%s" .Values.dashboard.authHostname }}
{{- else }}
{{- printf "https://%s.%s" "auth" (required "global.dnsDomain missing" .Values.global.dnsDomain) }}
{{- end }}
{{- end }}

{{/* Render the k8s api hostname. Override with .Values.dashboard.apiHostname (bare host). */}}
{{- define "dashboard.api.hostname" -}}
{{- if .Values.dashboard.apiHostname }}
{{- printf "https://%s" .Values.dashboard.apiHostname }}
{{- else }}
{{- printf "https://%s.%s" (default "api" .Values.global.kubeAPISubDomain) (required "global.dnsDomain missing" .Values.global.dnsDomain) }}
{{- end }}
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