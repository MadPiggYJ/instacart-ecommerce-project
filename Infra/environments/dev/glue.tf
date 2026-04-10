resource "aws_glue_catalog_database" "instacart" {
  name = "${local.project_name}-glue-database"
}

resource "aws_glue_catalog_table" "aisles" {
  name          = "aisles"
  database_name = aws_glue_catalog_database.instacart.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    classification           = "csv"
    EXTERNAL                 = "TRUE"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${module.s3_data.bucket}/raw/aisles/"
    input_format  = local.text_input_format
    output_format = local.text_output_format

    ser_de_info {
      name                  = "aisles-serde"
      serialization_library = local.csv_serde
      parameters = {
        separatorChar = ","
        quoteChar     = "\""
        escapeChar    = "\\"
      }
    }

    columns {
      name = "aisle_id"
      type = "int"
    }

    columns {
      name = "aisle"
      type = "string"
    }
  }


  depends_on = [aws_s3_object.aisles]
}

resource "aws_glue_catalog_table" "departments" {
  name          = "departments"
  database_name = aws_glue_catalog_database.instacart.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    classification           = "csv"
    EXTERNAL                 = "TRUE"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${module.s3_data.bucket}/raw/departments"
    input_format  = local.text_input_format
    output_format = local.text_output_format

    ser_de_info {
      name                  = "departments-serde"
      serialization_library = local.csv_serde
      parameters = {
        separatorChar = ","
        quoteChar     = "\""
        escapeChar    = "\\"
      }
    }

    columns {
      name = "department_id"
      type = "int"
    }

    columns {
      name = "department"
      type = "string"
    }
  }

  depends_on = [aws_s3_object.departments]
}

resource "aws_glue_catalog_table" "orders" {
  name          = "orders"
  database_name = aws_glue_catalog_database.instacart.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    classification           = "csv"
    EXTERNAL                 = "TRUE"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${module.s3_data.bucket}/raw/orders"
    input_format  = local.text_input_format
    output_format = local.text_output_format

    ser_de_info {
      name                  = "orders-serde"
      serialization_library = local.csv_serde
      parameters = {
        separatorChar = ","
        quoteChar     = "\""
        escapeChar    = "\\"
      }
    }

    columns {
      name = "order_id"
      type = "bigint"
    }

    columns {
      name = "user_id"
      type = "bigint"
    }

    columns {
      name = "eval_set"
      type = "string"
    }

    columns {
      name = "order_number"
      type = "int"
    }

    columns {
      name = "order_dow"
      type = "int"
    }

    columns {
      name = "order_hour_of_day"
      type = "int"
    }

    columns {
      name = "days_since_prior_order"
      type = "double"
    }
  }

  depends_on = [aws_s3_object.orders]
}

resource "aws_glue_catalog_table" "products" {
  name          = "products"
  database_name = aws_glue_catalog_database.instacart.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    classification           = "csv"
    EXTERNAL                 = "TRUE"
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${module.s3_data.bucket}/raw/products/"
    input_format  = local.text_input_format
    output_format = local.text_output_format

    ser_de_info {
      name                  = "products-serde"
      serialization_library = local.csv_serde
      parameters = {
        separatorChar = ","
        quoteChar     = "\""
        escapeChar    = "\\"
      }
    }

    columns {
      name = "product_id"
      type = "bigint"
    }

    columns {
      name = "product_name"
      type = "string"
    }

    columns {
      name = "aisle_id"
      type = "int"
    }

    columns {
      name = "department_id"
      type = "int"
    }
  }

  depends_on = [aws_s3_object.products]
}

resource "aws_glue_catalog_table" "order_products_prior" {
  name          = "order_products_prior"
  database_name = aws_glue_catalog_database.instacart.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    classification           = "csv"
    EXTERNAL                 = "TRUE"
    "skip.header.line.count" = "1"
    compressionType          = "gzip"
  }

  storage_descriptor {
    location      = "s3://${module.s3_data.bucket}/raw/order_products"
    input_format  = local.text_input_format
    output_format = local.text_output_format

    ser_de_info {
      name                  = "order-products-prior-serde"
      serialization_library = local.csv_serde
      parameters = {
        separatorChar = ","
        quoteChar     = "\""
        escapeChar    = "\\"
      }
    }

    columns {
      name = "order_id"
      type = "bigint"
    }

    columns {
      name = "product_id"
      type = "bigint"
    }

    columns {
      name = "add_to_cart_order"
      type = "int"
    }

    columns {
      name = "reordered"
      type = "int"
    }
  }

  depends_on = [aws_s3_object.order_products_prior]
}