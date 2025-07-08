variable "mca" {
  sensitive = true

  type = object({
    account = string
    profile = string
    invoice = string
  })
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
