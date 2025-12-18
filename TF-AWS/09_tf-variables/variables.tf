variable "aws_instance_type" {
  description = "EC2 instance type to create"
  type        = string

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.aws_instance_type)
    error_message = "Only t2.micro and t3.micro instance types are allowed."
  }
}

variable "root_block_config" {
  description = "Root block device configuration for the EC2 instance"

  type = object({
    size = number
    type = string
  })

  default = {
    size = 20
    type = "gp2"
  }

  validation {
    condition     = var.root_block_config.size >= 8 && var.root_block_config.size <= 50
    error_message = "Root volume size must be between 8 GB and 50 GB."
  }

  validation {
    condition     = contains(["gp2", "gp3"], var.root_block_config.type)
    error_message = "Root volume type must be either gp2 or gp3."
  }
}

variable "ec2_instance_tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
}
