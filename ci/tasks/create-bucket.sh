#!/usr/bin/env bash

set -euo pipefail

aws s3api head-bucket \
  --bucket "${BUCKET}" \
  || aws s3api create-bucket \
  --bucket "${BUCKET}" \
  --region "${AWS_DEFAULT_REGION}" \
  --create-bucket-configuration LocationConstraint="${AWS_DEFAULT_REGION}"

aws s3api put-bucket-versioning \
  --bucket "${BUCKET}" \
  --versioning-configuration Status=Enabled
