# Backend remoto S3. Los valores (bucket, key, region) se entregan con: terraform init -backend-config=backend.hcl
terraform {
  backend "s3" {}
}
