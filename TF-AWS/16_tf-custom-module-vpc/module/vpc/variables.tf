variable "vpc_config" {
  description = "VPC configuration including CIDR block and VPC name"

  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_config.cidr_block))
    error_message = "The cidr_block must be a valid IPv4 CIDR (e.g., 10.0.0.0/16)."
  }
}


variable "subnet_config" {
  description = "Subnet configuration map. Each entry defines a subnet with CIDR block, Availability Zone, and name."

  type = map(object({
    cidr_block = string
    az         = string
    name       = string
    public     = optional(bool, true)
  }))

  # Validate that all subnet CIDR blocks are valid IPv4 CIDRs
  validation {
    condition = alltrue([
      for subnet in values(var.subnet_config) :
      can(cidrnetmask(subnet.cidr_block))
    ])
    error_message = "Each subnet cidr_block must be a valid IPv4 CIDR (e.g., 10.0.1.0/24)."
  }

  # Validate Availability Zone format (example: ap-south-1a)
  validation {
    condition = alltrue([
      for subnet in values(var.subnet_config) :
      can(regex("^[a-z]{2}-[a-z]+-[0-9][a-z]$", subnet.az))
    ])
    error_message = "Each subnet az must be a valid Availability Zone (e.g., ap-south-1a)."
  }
}
