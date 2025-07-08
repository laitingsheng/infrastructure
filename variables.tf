variable "tfstate" {
  type = string
}

variable "apex" {
  type = object({
    name        = string
    suffices    = map(map(string))
    spfs        = list(string)
    mailservers = list(string)
  })
}

variable "github" {
  type = string
}
