{{/*
Expand the name of the chart.
*/}}
{{- define "apprise.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "apprise.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "apprise.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "apprise.labels" -}}
helm.sh/chart: {{ include "apprise.chart" . }}
{{ include "apprise.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "apprise.selectorLabels" -}}
app.kubernetes.io/name: {{ include "apprise.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "apprise.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "apprise.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the PersistentVolumeClaim backing a persistence key.
Usage: include "apprise.claimName" (dict "root" $ "key" "config")
*/}}
{{- define "apprise.claimName" -}}
{{- default (printf "%s-%s" (include "apprise.fullname" .root) .key) (index .root.Values.persistence .key).existingClaim -}}
{{- end }}

{{/*
Volume source of a persistence key. Falls back to an ephemeral emptyDir when
the key is disabled.
Usage: include "apprise.persistenceVolume" (dict "root" $ "key" "config")
*/}}
{{- define "apprise.persistenceVolume" -}}
{{- $pvc := index .root.Values.persistence .key -}}
{{- if $pvc.enabled -}}
persistentVolumeClaim:
  claimName: {{ include "apprise.claimName" . }}
{{- else -}}
emptyDir: {}
{{- end -}}
{{- end }}
