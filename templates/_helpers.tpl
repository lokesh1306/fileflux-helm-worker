{{/*
Expand the name of the chart.
*/}}
{{- define "s3worker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "s3worker.fullname" -}}
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
{{- define "s3worker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "s3worker.labels" -}}
helm.sh/chart: {{ include "s3worker.chart" . }}
app: s3
type: worker
version: green
{{ include "s3worker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
ZFS labels
*/}}
{{- define "zfs.labels" -}}
helm.sh/chart: {{ include "s3worker.chart" . }}
app: zfs-exporter
type: worker
{{ include "zfs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "s3worker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "s3worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: s3
version: green
type: worker
{{- end }}

{{/*
ZFS Selector labels 
*/}}
{{- define "zfs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "s3worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: zfs-exporter
type: worker
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "s3worker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "s3worker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
