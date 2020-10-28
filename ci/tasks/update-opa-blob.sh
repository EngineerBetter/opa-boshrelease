#!/usr/bin/env bash

set -e

cd opa-boshrelease

cat >> config/private.yml <<EOF
---
blobstore:
  provider: s3
  options:
    credentials_source: env_or_profile
EOF

bosh add-blob ../opa-binary/opa_linux_amd64 opa/opa_linux_amd64

bosh upload-blobs

status="$(git status --porcelain)"
if [ -n "$status" ]; then
  git config --global user.email "ci@localhost"
  git config --global user.name "CI Bot"
  git add -A
  git commit -m "Updating opa blob"
fi
