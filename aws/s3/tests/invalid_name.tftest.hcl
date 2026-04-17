run "valid_bucket_name" {
    command = plan

    variables {
    bucket_name = "INVALID_NAME" # invalid: uppercase + underscore
    force_destroy = false


    tags = {
      Environment = "dev"
    }
  }

    expect_failures = [
        var.bucket_name
    ]
}