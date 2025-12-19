terraform {}

locals {
  value = "Hello, World!"
}

variable "string_list" {
  type    = list(string)
  default = ["Server-1", "Server-2", "Server-3"]
}

output "output" {
  # String functions
  # value = lower(local.value)
  # value = upper(local.value)
  # value = startswith(local.value, "Hello")
  # value = startswith(local.value, "hello")
  # value = split(" ", local.value)

  # Numeric functions
  # value = max(1, 2, 3, 4, 5)
  # value = min(1, 2, 3, 4, 5)
  # value = abs(-15)

  # Collection functions
  # value = length(var.string_list)
  # value = join(":", var.string_list)
  # value = contains(var.string_list, "Server-2")

  # Convert list → set
  value = toset(var.string_list)
}
