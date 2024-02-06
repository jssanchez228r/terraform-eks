variable "aws_credentials" {
  description = "region y profile"
  type = map(any)
}


variable "vpc" {
  description = "VPC"
  type = map(any)
}



variable "private_subnets" {
  description = "subnets AWS Privadas y Publicas"
  type = map(any)
  
}
variable "public_subnets" {
  description = "value"
  type = map(any)  
}

variable "eip" {
  description = "value"
  type = map(any)
  
}

variable "internet_gateway" {
  description = "internet_gateway"
  type = map(any)
}

variable "nat" {
  description = "nat"
  type = map(any)
  
}

variable "route_table" {
  description = "Route table subnet privada"
  type = map(any)
}

variable "private_routes" {
  description = "Routes"
  type = map(any)
  
}
variable "public_routes" {
  description = "Routes"
  type = map(any)
  
}

variable "route_table_association_pvt" {
  description = "asociacion de Rutas a subnet"
  type = map(any)
}

variable "route_table_association_pub" {
  description = "asociacion de Rutas a subnet"
  type = map(any)
}

variable "security_groups" {
  description = "SG EKS"
  type = map(any)
  
}

variable "eks" {
  description = "EKS CLUSTER"
  type = map(any)
  
}

variable "eks-addon" {
  description = "value"
  type = map(any)
  
}

variable "eks-nodes" {
  description = "value"
  type = map(any)
  
}

