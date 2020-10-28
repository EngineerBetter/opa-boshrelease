#!/usr/bin/env bash

set -euo pipefail

VERSION=$(cat version/number)

root_path=$PWD
promoted_repo=${root_path}/final-opa-boshrelease

final_release_path="${root_path}/final-release/opa-final-release-$(cat version/version).tgz"

git config --global user.email "ci@localhost"
git config --global user.name "CI Bot"

git clone ./opa-boshrelease "${promoted_repo}"

pushd "${promoted_repo}"
  git status --porcelain
  git checkout master
  git status --porcelain

  cat >> config/private.yml <<EOF
---
blobstore:
  provider: s3
  options:
    credentials_source: env_or_profile
EOF

  bosh finalize-release --version "${VERSION}" "${final_release_path}"

  status="$(git status --porcelain)"
  if [ -n "$status" ]; then
    git add -A
    git commit -m "Adding final release $VERSION via concourse"
  fi
popd
