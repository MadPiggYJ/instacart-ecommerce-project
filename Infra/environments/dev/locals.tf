locals {
  project_name = "${var.project_name}-${var.env}"

  common_tags = {
    Project     = var.project_name
    Environment = var.env
    ManagedBy   = "terraform"
  }

  csv_serde          = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
  text_input_format  = "org.apache.hadoop.mapred.TextInputFormat"
  text_output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
}