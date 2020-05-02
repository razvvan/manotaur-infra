variable "rmq-host" {
  default = "rmq.manotaur.somedomain.ro"
}

variable "grafana-host" {
  default = "manotaur.somedomain.ro"
}

variable "grafana-password" {
  default = "hunter42"
}

variable "mysql-password" {
  default = "hunter42"
}


variable "rabbitmq-erlang-cookie" {
  default = "Zzc0dURjRTJ123h3ZFBTRDRxd123SmxW"
}

variable "rabbitmq-password" {
  default = "hunter42"
}

variable "influxdb-admin-password" {
  default = "hunter42"
}

variable "influxdb-user-password" {
  default = "hunter42"
}

variable "letsencrypt-email" {
  default = "foo@foo.com"
}
