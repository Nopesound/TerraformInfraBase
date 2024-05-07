variable "azure_region" {
  type = string
  default = "westeurope"
}
variable "resource_group_name" {
  type = string
  default = "rg_dev_infra"
}
variable "sql_admin_psw" {
  type = string
  sensitive = true
}
variable "kv_argo_id" {
  type = string
  
}