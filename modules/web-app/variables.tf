variable "azure_region" {
  type = string
  default = "westeurope"
}
variable "resource_group_name" {
  type = string
  default = "rg_dev_infra"
}
variable "environment" {
  type = string
}