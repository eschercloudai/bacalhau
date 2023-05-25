{{/*
Expand the name of the chart.
*/}}
{{- define "bacalhau.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bacalhau.fullname" -}}
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
{{- define "bacalhau.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bacalhau.labels" -}}
helm.sh/chart: {{ include "bacalhau.chart" . }}
{{ include "bacalhau.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bacalhau.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bacalhau.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "bacalhau.selectorLabels.requester" -}}
{{ include "bacalhau.selectorLabels" . }}
kind: requester
{{- end }}

{{- define "bacalhau.selectorLabels.compute" -}}
{{ include "bacalhau.selectorLabels" . }}
kind: compute
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bacalhau.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bacalhau.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
