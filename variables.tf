variable "resource_group_name" {
  type        = string
  description = "Resource group name in Azure"
}

variable "free_web_app_plan" {
  type        = string
  description = "Service plan name"
}

variable "web_app_name" {
  type = string
  description = "Web app name"
}