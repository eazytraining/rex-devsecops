variable "key_path" {
  type        = string
  description = "Filename of the key pair to be used for SSH access."
  default     = "rex-key.pem"
}
variable "key_name" {
  type        = string
  description = "Public key content for the key pair."
  default     = ""
}