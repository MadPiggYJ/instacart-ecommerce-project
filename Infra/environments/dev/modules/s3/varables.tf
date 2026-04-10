variable "bucket_name" {
  type = string
}

variable "bucket_versioning" {
  type    = string
  default = null

  validation {
    condition     = var.bucket_versioning == null || contains(["Enabled", "Suspended"], var.bucket_versioning)
    error_message = "bucket_versioning must be 'Enabled', 'Suspended', or null (to skip versioning config)."
  }
}
variable "tags" {
  type = map(string)
  default = {}
}