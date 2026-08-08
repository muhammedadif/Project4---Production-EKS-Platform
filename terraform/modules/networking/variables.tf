
variable "vpc_cidr" {

  description = "CIDR block for Production VPC"

  type = string

  default = "10.0.0.0/16"
}

variable "public_subnet_1" {

  description = "CIDR for Public Subnet 1"

  type = string

}

variable "az1" {

  description = "Availability Zone 1"

  type = string

}

variable "public_subnet_2" {

  description = "CIDR for Public Subnet 2"

  type = string

}

variable "az2" {

  description = "Availability Zone 2"

  type = string

}

variable "private_subnet_1" {

  description = "CIDR for Private Subnet 1"

  type = string

}

variable "private_subnet_2" {

  description = "CIDR for Private Subnet 2"

  type = string

}