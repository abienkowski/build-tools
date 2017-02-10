#!/bin/bash
# -- set flag to exit on first error
set -e
# -- pass in project name as the first parameter
PROJECT=$1
# -- pass the workspace directory for the job
WORKSPACE=$2
if [ -d $WORKSPACE ]; then
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
else
    echo "Sorry, I could not find the given workspace '$WORKSPACE' directory for '$PROJECT' project."
    exit 1
fi
