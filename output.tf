output "az_names"{
    value = slice(data.aws_availability_zones.available.names, 0,2)
}