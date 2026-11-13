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
A map is emitted whole (not descended into) when it carries a `_raw` key.
Usage: {{ include "flattenOptionValues" (dict "prefix" "externaldns" "values" .Values.externalDns.options) }}
*/}}
{{- define "flattenOptionValues" -}}
{{- $prefix := .prefix -}}
{{- range $k, $v := .values -}}
{{- $ek := $k | replace "." "\\." -}}
{{- $key := ternary $ek (printf "%s.%s" $prefix $ek) (eq $prefix "") -}}
{{- if and (kindIs "map" $v) (hasKey $v "_valueFrom") }}
- name: {{ $key }}
  valueFrom:
{{ toYaml (get $v "_valueFrom") | indent 4 -}}
{{- else if and (kindIs "map" $v) (hasKey $v "_raw") }}
- name: {{ $key }}
  value:
{{ toYaml (get $v "_raw") | indent 4 -}}
{{- else if kindIs "map" $v }}
{{- include "flattenOptionValues" (dict "prefix" $key "values" $v) -}}
{{- else if kindIs "slice" $v }}
- name: {{ $key }}
  value:
{{ toYaml $v | indent 4 -}}
{{- else if and (kindIs "string" $v) (contains "\n" $v) }}
- name: {{ $key }}
  value: {{ $v | toYaml | indent 4 | trim }}
{{- else }}
- name: {{ $key }}
  value: {{ $v | toYaml | trim }}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Merge pluginGlobals into a single plugin's optionValues map.
Each .Values.pluginGlobals entry is {plugins: [names], values: {map}}; an entry
applies when its `plugins` list is empty/absent or contains the plugin name.
Applicable entries' `values` form the base (later entries override earlier), and
the plugin's own optionValues are layered on top so the plugin always wins.
deepCopy guards the shared global dicts from being mutated across plugins.
Returns the merged map as a YAML string (caller pipes through fromYaml).
Usage: {{ include "pluginOptionValues" (dict "name" $name "own" $own "root" $) | fromYaml }}
*/}}
{{- define "pluginOptionValues" -}}
{{- $merged := dict -}}
{{- range $entry := (($.root.Values.pluginGlobals) | default list) -}}
{{- $targets := ($entry.plugins | default list) -}}
{{- if or (eq (len $targets) 0) (has $.name $targets) -}}
{{- $merged = mergeOverwrite $merged (deepCopy ($entry.values | default dict)) -}}
{{- end -}}
{{- end -}}
{{- $merged = mergeOverwrite $merged (deepCopy ($.own | default dict)) -}}
{{- toYaml $merged -}}
{{- end }}
