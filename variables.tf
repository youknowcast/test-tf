variable "profile" {
  type    = string
  default = ""
}

# pubkey name. like: youknow-pubkey
variable "youknow_key_name" {
  type = string
}

# pubkey. set content of ~/.ssh/{your key}.pub
variable "youknow_pub_key" {
  type = string
}