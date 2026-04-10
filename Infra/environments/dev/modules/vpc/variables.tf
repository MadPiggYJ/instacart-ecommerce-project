variable "vpc_cidr" {
  type = string
}


variable "vpc_name" {
  type = string
}


variable "az_count" {
  type = number
  default = 2
}

variable "enable_nat" {
  type = bool
  default = false
}