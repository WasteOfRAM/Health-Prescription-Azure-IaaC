variable "resource_location" {
  type    = string
  default = "North Europe"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name in Azure"
}

variable "free_web_app_plan" {
  type        = string
  description = "Service plan name"
}

variable "web_app_name" {
  type        = string
  description = "Web app name"
}

variable "db_server_name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_admin_login" {
  type      = string
  sensitive = true
}

variable "db_admin_pass" {
  type      = string
  sensitive = true
}

variable "jwt_key" {
  type      = string
  sensitive = true
}

variable "jwt_issuer" {
  type      = string
  sensitive = true
}

variable "jwt_audience" {
  type      = string
  sensitive = true
}