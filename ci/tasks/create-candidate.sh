#!/usr/bin/env bash

set -e

export ROOT_PATH=$PWD

cd opa-boshrelease

bosh create-release --tarball="${ROOT_PATH}/release/opa-dev-release.tgz" --timestamp-version --force
