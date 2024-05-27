variable "enable_dns_hostnames"{
    type = bool
    default = true
}

#### VPC ####
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "project_name"{
    type = string
    default = "expense"
}

variable "common_tags"{
    type = map
    default = {
        Project = "expense"
        Environment = "dev"
        terraform = "true"
    }
}

variable "vpc_tags"{
    type = map 
    default = {
        Name = "vpc"
    }
}

variable "igw_tags"{
    type = map 
    default = {
        Name = "igw"
    }
}

variable "public_subnet"{
    type = list 
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_tags"{
    type = map 
    default = {
        Name = "public"
    }
}

variable "private_subnet"{
    type = list 
    default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnet_tags"{
    type = map 
    default = {
        Name = "private"
    }
}

variable "nat_gw_tags"{
    type = map 
    default = {
        Name = "nat_gw"
    }
}

variable "public_route_table_tags"{
    type = map 
    default = {
        Name = "public"
    }
}

variable "private_route_table_tags"{
    type = map 
    default = {
        Name = "private"
    }
}

variable "eip_tags"{
type = map 
    default = {
        Name = "eip"
    }
}
