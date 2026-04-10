output "glue_database_name" {
  value = aws_glue_catalog_database.instacart.name
}

output "athena_workgroup_name" {
  value = module.athena_work_group.name
}

output "s3_data_bucket" {
  value = module.s3_data.bucket
}

output "s3_athena_results_bucket" {
  value = module.s3_athena_results.bucket
}