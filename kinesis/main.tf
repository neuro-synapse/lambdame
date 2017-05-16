resource "aws_kinesis_stream" "test_stream" {
  name             = "${var.kinesis_name_var}"
  shard_count      = 1
  retention_period = "${var.retention_period_var}"
}
