resource "aws_s3_bucket" "s3_data_bucket" {
  bucket = var.s3_data_bucket
}

resource "aws_s3_bucket" "s3_config_bucket" {
  bucket = var.s3_config_bucket
}

resource "aws_s3_object" "ignite_config" {
  bucket = aws_s3_bucket.s3_config_bucket.id 
  key    = "ignite_config/config.xml"
  source = "./ignite_config/config.xml"
  etag = filemd5("./ignite_config/config.xml")
}


resource "aws_s3_bucket_public_access_block" "allow_puplic_access" {
  bucket = aws_s3_bucket.s3_config_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "allow_public_read_access" {
  bucket = aws_s3_bucket.s3_config_bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
       "Sid": "Public-read",
       "Principal": "*",
       "Action": "s3:GetObject",
       "Effect": "Allow",
       "Resource": "arn:aws:s3:::${aws_s3_bucket.s3_config_bucket.bucket}/*"
     }
   ]
}
EOF

depends_on = [aws_s3_object.ignite_config, aws_s3_bucket_public_access_block.allow_puplic_access]
}

resource "aws_s3_bucket_website_configuration" "s3_config_file_read" {
  bucket = aws_s3_bucket.s3_config_bucket.id
   index_document {
    suffix = "config.xml"
  }
}

/*
resource "aws_s3_bucket_policy" "allow_access_from_gateway_endpoint" {
  bucket = aws_s3_bucket.s3_data_bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
       "Sid": "Access-to-specific-VPCE-only",
       "Principal": "*",
       "Action": "s3:*",
       "Effect": "Deny",
       "Resource": [
            "arn:aws:s3:::${aws_s3_bucket.s3_data_bucket.bucket}/*",
            "arn:aws:s3:::${aws_s3_bucket.s3_data_bucket.bucket}"],
       "Condition": {
         "StringNotEquals": {
           "aws:SourceVpce": "${aws_vpc_endpoint.s3.id}"
         }
       }
     }
   ]
}
EOF
}
*/