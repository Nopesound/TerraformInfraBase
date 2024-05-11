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
variable "sql_dbuser_argo_password" {
  type = string
  sensitive = true
}
variable "kv_argo_id" {
  type = string
}
variable "sql_dbuser_argo_roles" {
  type = list(string)
  default = ["db_owner"]
}
variable "environment" {
  type = string
}
