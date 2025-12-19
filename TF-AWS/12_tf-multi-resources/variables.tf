# Example 1
variable "ec2_config_list" {
  type = list(object({
    ami           = string
    instance_type = string
  }))
}

# Example 2
variable "ec2_config_map" {
  type = map(object({
    ami           = string
    instance_type = string
  }))
}
