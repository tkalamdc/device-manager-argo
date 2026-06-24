{{/*
Expand the name of the chart.
*/}}
{{- define "device-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "device-manager.fullname" -}}
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
{{- define "device-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "device-manager.labels" -}}
helm.sh/chart: {{ include "device-manager.chart" . }}
{{ include "device-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "device-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "device-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "device-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "device-manager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for getambassador.io.
*/}}
{{- define "ambassador.apiVersion" -}}
{{- print "getambassador.io/v2" -}}
{{- end -}}

{{/*
Returns the proper "host" attribute based on available ambassador api version (for standard host)
*/}}
{{- define "mapping.hostAttribute.host" -}}
{{- if .Capabilities.APIVersions.Has "getambassador.io/v3alpha1" -}}
{{- print "hostname: " .Values.global.host -}}
{{- else -}}
{{- print "host: " .Values.global.host -}}
{{- end -}}
{{- end -}}

{{/*
Returns the proper "host" attribute based on available ambassador api version (for internal ambassador host)
*/}}
{{- define "mapping.hostAttribute.ambassadorHost" -}}
{{- $ambNamespace := "" -}}
{{- if .Values.global.ambassadorNamespace -}}
{{- $ambNamespace = printf "-%s.%s" .Release.Namespace .Values.global.ambassadorNamespace -}}
{{- end }}
{{- if .Capabilities.APIVersions.Has "getambassador.io/v3alpha1" -}}
{{- print "hostname: ambassador" $ambNamespace -}}
{{- else -}}
{{- print "host: ambassador" $ambNamespace -}}
{{- end -}}
{{- end -}}

{{/*
Return the boolean to indicate if ingress change is required to support ingress controller version 2.x
*/}}
{{- define "kubernetes.version.greaterThan.1.19" -}}
{{- if semverCompare ">=1.19" .Capabilities.KubeVersion.GitVersion -}}
{{- print "true" -}}
{{- else -}}
{{- print "false" -}}
{{- end -}}
{{- end -}}
