{{- define "cloudcart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cloudcart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "cloudcart.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "cloudcart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cloudcart.labels" -}}
helm.sh/chart: {{ include "cloudcart.chart" . }}
app.kubernetes.io/name: {{ include "cloudcart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: cloudcart
{{- end -}}

{{- define "cloudcart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloudcart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "cloudcart.componentSelector" -}}
{{ include "cloudcart.selectorLabels" .root }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{- define "cloudcart.configData" -}}
DATABASE_HOST: {{ printf "%s-postgres" (include "cloudcart.fullname" .) | quote }}
DATABASE_PORT: "5432"
DATABASE_NAME: {{ .Values.config.databaseName | quote }}
DATABASE_USER: {{ .Values.config.databaseUser | quote }}
AMQP_HOST: {{ printf "%s-rabbitmq" (include "cloudcart.fullname" .) | quote }}
AMQP_PORT: "5672"
AMQP_USER: {{ .Values.config.amqpUser | quote }}
RELAY_INTERVAL_SECONDS: {{ .Values.config.relayIntervalSeconds | quote }}
{{- end -}}

{{- define "cloudcart.appSecurityContext" -}}
allowPrivilegeEscalation: false
capabilities:
  drop: ["ALL"]
readOnlyRootFilesystem: true
runAsNonRoot: true
runAsUser: 10001
seccompProfile:
  type: RuntimeDefault
{{- end -}}

{{- define "cloudcart.placement" -}}
{{- with .Values.placement.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.placement.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.placement.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
