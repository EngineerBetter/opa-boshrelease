#!/usr/bin/env bash

set -euo pipefail

version=$(cat version/version)
name="opa-boshrelease v${version}"
release_name=$(bosh int opa-boshrelease/config/final.yml --path /final_name)
release_url="https://github.com/EngineerBetter/opa-boshrelease/releases/download/${version}/opa-final-release-${version}.tgz"
release_tgz="final-release/opa-final-release-${version}.tgz"
release_sha1=$(sha1sum "${release_tgz}" | head -n1 | awk '{print $1}')

echo "${name}" > release-vars/name

pushd opa-boshrelease
  commit=$(git rev-parse HEAD)
popd

echo "$commit" > release-vars/commit

cat << EOF > release-vars/body
Auto-generated release

### Deployment
\`\`\`yaml
releases:
- name:    $release_name
  version: $version
  url:     $release_url
  sha1:    $release_sha1
\`\`\`
EOF
