{{/*
Authz webhook helpers, folded into the manager chart. Gated by
.Values.authz.enabled. Values read from .Values.authz. Resource names derive
from manager.fullname (= "greenhouse"), yielding "greenhouse-authz" etc.
*/}}

{{- define "authz.fullname" -}}
{{- printf "%s-authz" (include "manager.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "authz.selectorLabels" -}}
app.kubernetes.io/name: authz
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "authz.labels" -}}
helm.sh/chart: {{ include "manager.chart" . }}
{{ include "authz.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.authz.commonLabels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/* authz uses the shared manager/controller image + appVersion. */}}
{{- define "authz.image" -}}
{{- include "manager.image" . }}
{{- end }}

{{- define "authz.serviceAccountName" -}}
{{- if .Values.authz.serviceAccount.create }}
{{- default (include "authz.fullname" .) .Values.authz.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.authz.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "authz.servingCertsSecretName" -}}
{{- default (printf "%s-serving-certs" (include "authz.fullname" .)) .Values.authz.tls.secretName }}
{{- end }}

{{- define "authz.annotations" -}}
{{- if .Values.authz.commonAnnotations }}
{{- toYaml .Values.authz.commonAnnotations }}
{{- end }}
{{- end }}