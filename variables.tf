variable "mca" {
  sensitive = true

  type = object({
    account = string
    profile = string
    invoice = string
  })
}

variable "primary" {
  sensitive = true
  type      = string
}

variable "domain" {
  type = string
}

variable "github" {
  type = object({
    username   = string
    repository = string
  })
}
