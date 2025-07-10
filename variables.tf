variable "tfstate" {
  type = string
}

variable "domain" {
  type = string
}

variable "spfs" {
  type = list(string)
}

variable "mailservers" {
  type = list(string)
}

variable "github" {
  type = object({
    username   = string
    repository = string
  })
}
