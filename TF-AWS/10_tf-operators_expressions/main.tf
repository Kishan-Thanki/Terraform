terraform {}

########################
# Number List
########################
variable "number_list" {
  type    = list(number)
  default = [1, 2, 3, 4, 5]
}

########################
# Person List (Objects)
########################
variable "person_list" {
  type = list(object({
    fname = string
    lname = string
  }))

  default = [
    {
      fname = "John"
      lname = "Cena"
    },
    {
      fname = "Paul"
      lname = "John"
    }
  ]
}

########################
# Map Variable
########################
variable "person_map" {
  type = map(number)
  default = {
    one   = 1
    two   = 2
    three = 3
  }
}

########################
# Local Calculations
########################
locals {
  # Simple expressions
  mul = 2 * 2
  add = 5 + 5
  neq = 2 != 3

  # List transformations
  double_numbers = [for num in var.number_list : num * 2]
  odd_numbers    = [for num in var.number_list : num if num % 2 != 0]

  # Extract values from object list
  first_names = [for person in var.person_list : person.fname]

  # Map transformations
  map_keys        = [for key, value in var.person_map : key]
  map_key_values  = [for key, value in var.person_map : [key, value]]
  doubled_map     = { for key, value in var.person_map : key => value * 2 }
}

########################
# Outputs (Choose One)
########################
output "map_keys" {
  value = local.map_keys
}

# Uncomment to test others
# output "odd_numbers" {
#   value = local.odd_numbers
# }
#
# output "first_names" {
#   value = local.first_names
# }
#
# output "doubled_map" {
#   value = local.doubled_map
# }
