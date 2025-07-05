variable "rex_key_filename" {
  type        = string
  description = "Filename of the key pair to be used for SSH access."
  default     = "rex-key.pem"
}
variable "rex_key" {
  type        = string
  description = "Public key content for the key pair."
  default     = ""
}