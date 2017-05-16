variable "kinesis_name_var" {
  description = "name for kinesis"
}

variable "retention_period_var" {
  description = "name for kinesis"
}

variable "images" {
  type = "map"

  default = {
    us-east-1 = "image-1234"
    us-west-2 = "image-4567"
  }
}
