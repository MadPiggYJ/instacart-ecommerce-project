module "athena_work_group" {
  source                = "./modules/athena"
  athena_workgroup_name = "${local.project_name}-athena-work-group"
  s3_location           = "s3://${module.s3_athena_results.bucket}/results/"

}