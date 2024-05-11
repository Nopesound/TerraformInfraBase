variable "tenant_id" {
  type = string
}
variable "subscription_id" {
  type = string
}
variable "client_id" {
  type = string
}
variable "azure_region" {
  type = string
  default = "westeurope"
}
variable "sql_admin_psw" {
  type = string
  sensitive = true
}
variable "sql_dbuser_argo_password" {
  type = string
  sensitive = true
}