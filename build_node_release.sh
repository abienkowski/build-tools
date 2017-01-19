#!/bin/bash

# -- version bump based on selected choice
grunt bump:${RELEASE_TYPE}

# -- retrieve current version and set job parameters through file
if [[ -f package.json ]]; then
    export RELEASE_VERSION=$(cat package.json | jq --raw-output .version)
    echo "RELEASE_VERSION=$RELEASE_VERSION" > ${WORKSPACE}/release-parameters.env
else
    exit "Package.json not found!"
fi

# -- identify release build; this will be picked up by the Set build description in Post-build Actions step
echo "This is a release build, setting build description"
echo "Build description is ${RELEASE_VERSION}"

# -- git status
git tag

# -- shrinkwrap and commit file
npm shrinkwrap
git add -f npm-shrinkwrap.json
git commit -m "Updating shrinkwrap file for release ${RELEASE_VERSION}"

# -- publish the version; requires npm@1.4.5
npm publish

