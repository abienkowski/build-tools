#!/bin/bash

# -- Pre-Release Step
grunt bump:prerelease

# -- retrieve current version and set job parameters through file
if [[ -f package.json ]]; then
    export RELEASE_VERSION=$(cat package.json | jq --raw-output .version)
    echo "RELEASE_VERSION=$RELEASE_VERSION" > ${WORKSPACE}/release-parameters.env
else
    exit "Package.json not found!"
fi

# -- log build version; this will be picked up by the Set build description in Post-build Actions step
echo "This is a release build, setting build description"
echo "Build description is ${RELEASE_VERSION}"
