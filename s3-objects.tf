resource "aws_s3_object" "web" {
  for_each = fileset(var.source_dir, "**/*.*")

  bucket       = var.bucket_id
  key          = each.key
  source       = "${var.source_dir}/${each.key}"
  content_type = lookup(tomap(local.mime_types), element(split(".", each.key), length(split(".", each.key)) - 1))
  # source_hash, not etag: large files are uploaded multipart, so the S3 etag
  # never equals the file md5 and etag would show a diff on every plan.
  source_hash = filemd5("${var.source_dir}/${each.key}")
}
