variable "host" {
    type = string
    description = "host"
    default = "k3s-david-iot.sda-dev-projects.nl"
}


variable "ingress_nginx_namespace" {
    type = string
    description = "ingress-nginx namespace"
    default = "default"
}

variable "mqtt_port" {
    type = string
    description = "Port for accessing MQTT externally"
    # default = "1883"
    default = "30000"
}

variable "postgresql_port" {
    type = string
    description = "Port for accessing PostgreSQL externally"
    # default = "5432"
    default = "30001"
}


variable "admin_password" {
    type = string
    description = "Admin password"
    default = "C73TrWgryyClLu"
}

variable "pipeline_password" {
    type = string
    description = "Pipeline password"
    default = "dh4u7HXqILDDSE"
}

variable "public_password" {
    type = string
    description = "Public password"
    default = "hDmBsiC7HLXJFz"
}

variable "test_password" {
    type = string
    description = "Test password"
    default = "arI5kqOrkW3K2F"
}



variable "minio_size" {
    type = string
    description = "Minio volume size"
    default = "1Gi"
}

variable "minio_requests_cpu" {
    type = string
    description = "Minio CPU request"
    default = "250m"
}

variable "minio_requests_memory" {
    type = string
    description = "Minio memory request"
    default = "512Mi"
}

variable "minio_limits_cpu" {
    type = string
    description = "Minio CPU limit"
    default = "250m"
}

variable "minio_limits_memory" {
    type = string
    description = "Minio memory limit"
    default = "512Mi"
}


variable "influxdb_size" {
    type = string
    description = "InfluxDB volume size"
    default = "1Gi"
}

variable "influxdb_requests_cpu" {
    type = string
    description = "InfluxDB CPU request"
    default = "250m"
}

variable "influxdb_requests_memory" {
    type = string
    description = "InfluxDB memory request"
    default = "512Mi"
}

variable "influxdb_limits_cpu" {
    type = string
    description = "InfluxDB CPU limit"
    default = "250m"
}

variable "influxdb_limits_memory" {
    type = string
    description = "InfluxDB memory limit"
    default = "512Mi"
}


variable "postgresql_size" {
    type = string
    description = "PostgreSQL volume size"
    default = "1Gi"
}

variable "postgresql_requests_cpu" {
    type = string
    description = "PostgreSQL CPU request"
    default = "250m"
}

variable "postgresql_requests_memory" {
    type = string
    description = "PostgreSQL memory request"
    default = "512Mi"
}

variable "postgresql_limits_cpu" {
    type = string
    description = "PostgreSQL CPU limit"
    default = "250m"
}

variable "postgresql_limits_memory" {
    type = string
    description = "PostgreSQL memory limit"
    default = "512Mi"
}


# variable "grafana_size" {
#     type = string
#     description = "Grafana volume size"
#     default = "1Gi"
# }

variable "grafana_requests_cpu" {
    type = string
    description = "Grafana CPU request"
    default = "250m"
}

variable "grafana_requests_memory" {
    type = string
    description = "Grafana memory request"
    default = "512Mi"
}

variable "grafana_limits_cpu" {
    type = string
    description = "Grafana CPU limit"
    default = "250m"
}

variable "grafana_limits_memory" {
    type = string
    description = "Grafana memory limit"
    default = "512Mi"
}


# variable "ubuntu_size" {
#     type = string
#     description = "Ubuntu volume size"
#     default = "1Gi"
# }
