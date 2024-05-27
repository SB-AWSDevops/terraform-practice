locals{
    resource_name = "${var.project_name}-${var.common_tags.Environment}"
    az_names = slice(data.aws_availability_zones.available.names, 0,2)
    }
