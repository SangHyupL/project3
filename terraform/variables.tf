variable "DB_DATABASE" {
  type = string
  default = "team8"
}

variable "DB_HOSTNAME" {
  type = string
  default = "project3db2.cpajpop7ewnt.ap-northeast-2.rds.amazonaws.com"
}

variable "DB_PASSWORD" {
  type = string
  default = "team8"
}

variable "DB_USERNAME" {
  type = string
  default = "team8"
}

# Stock Lambda
variable "callback_ENDPOINT" {
  type = string
  default = "https://29spk28foe.execute-api.ap-northeast-2.amazonaws.com/product/donut"
}