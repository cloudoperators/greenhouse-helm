{{/*
SPDX-FileCopyrightText: 2026 SAP SE or an SAP affiliate company and Greenhouse contributors
SPDX-License-Identifier: Apache-2.0
*/}}

{{/* Render the auth hostname */}}
{{- define "idproxy.auth.hostname" -}}
{{- printf "%s.%s" "auth" (required "global.dnsDomain missing" .Values.global.dnsDomain) }}
{{- end }}

{{/*
Flatten a nested map into dotted-key optionValues entries.
Usage: {{ include "flattenOptionValues" (dict "prefix" "externaldns" "values" .Values.externalDns.options) }}
*/}}
{{- define "flattenOptionValues" -}}
{{- $prefix := .prefix -}}
{{- range $k, $v := .values -}}
{{- $key := printf "%s.%s" $prefix $k -}}
{{- if kindIs "map" $v }}
{{- include "flattenOptionValues" (dict "prefix" $key "values" $v) }}
{{- else if kindIs "slice" $v }}
- name: {{ $key }}
  value:
{{ toYaml $v | indent 4 }}
{{- else }}
- name: {{ $key }}
  value: {{ $v | toYaml | trim }}
{{ end -}}
{{- end -}}
{{- end }}
