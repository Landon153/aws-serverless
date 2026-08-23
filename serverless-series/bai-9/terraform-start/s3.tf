resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "codepipeline-bucket-${data.aws_caller_identity.current.id}"
  force_destroy = true

  grant {
    permissions = [
      "FULL_CONTROL",
    ]
    type = "Group"
    uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
  }

  grant {
    id = data.aws_canonical_user_id.current.id
    permissions = [
      "FULL_CONTROL",
    ]
    type = "CanonicalUser"
  }
}
