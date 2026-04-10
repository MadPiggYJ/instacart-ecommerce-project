module "s3_data" {
  source            = "./modules/s3"
  bucket_name       = "${local.project_name}-data-${data.aws_caller_identity.current.account_id}"
  bucket_versioning = null
}

module "s3_athena_results" {
  source            = "./modules/s3"
  bucket_name       = "${local.project_name}-athena-results-${data.aws_caller_identity.current.account_id}"
  bucket_versioning = null
}

resource "aws_s3_object" "aisles" {
  bucket = module.s3_data.id
  key    = "raw/aisles/aisles.csv"
  source = "${path.module}/../../../data/aisles.csv"
  etag   = filemd5("${path.module}/../../../data/aisles.csv")
}

resource "aws_s3_object" "departments" {
  bucket = module.s3_data.id
  key    = "raw/departments/departments.csv"
  source = "${path.module}/../../../data/departments.csv"
  etag   = filemd5("${path.module}/../../../data/departments.csv")
}

resource "aws_s3_object" "orders" {
  bucket = module.s3_data.id
  key    = "raw/orders/orders.csv"
  source = "${path.module}/../../../data/orders.csv"
  etag   = filemd5("${path.module}/../../../data/orders.csv")
}

resource "aws_s3_object" "products" {
  bucket = module.s3_data.id
  key    = "raw/products/products.csv"
  source = "${path.module}/../../../data/products.csv"
  etag   = filemd5("${path.module}/../../../data/products.csv")
}

resource "aws_s3_object" "order_products_prior" {
  bucket = module.s3_data.id
  key    = "raw/order_products/order_products__prior.csv.gz"
  source = "${path.module}/../../../data/order_products__prior.csv.gz"
  etag   = filemd5("${path.module}/../../../data/order_products__prior.csv.gz")
}