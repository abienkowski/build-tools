#!/bin/bash
# -- set flag to exit on first error
set -e
# -- pass in project name as the first parameter
PROJECT=$1
# -- pass the workspace directory for the job
WORKSPACE=$2
if [ -d $WORKSPACE ]; then
    # -- TODO: create an automatic injection of dependencies; with automatic dependency injection
    # any future changes to the process will not need to modify this file.
    # -- --
    # -- version bump based on selected choice
    grunt bump:${RELEASE_TYPE}
    # -- the release-parameter.env file will be injected into the release process on Jenkins
    # -- and all variables will be made available there.
    # -- parse out current version and set job parameters through file
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
else
    echo "Sorry, I could not find the given workspace '$WORKSPACE' directory for '$PROJECT' project."
    exit 1
fi
