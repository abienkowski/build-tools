#!/bin/bash
# -- set exit on first error flag
set -e
# -- pass in project name as the first parameter
PROJECT=$1
WORKSPACE="jobs/${PROJECT}/workspace"
if [ -d $WORKSPACE ]; then
    echo "Executing build on $PROJECT project..."
    # -- change to the project workspace directory
    echo "...found workspace $WORKSPACE directory"
    cd $WORKSPACE
    # -- create node_modules in a local tmp folder specific for the project and link to workspace
# -- TODO: investigate a better workaround or perhaps a newer version of npm or node fixes this already.
# The problem is that when node_modules in the project directory is a link to a directory, as shown bellow
# in the commented code, when calling require on some packages yields an modules not found error.
# Leaving this as a real directory will cause data to be stored on the EFS volume and cause additional
# traffic when files are sync between machines. This is not needed and the idea was to to keep this directroy
# transient using local storage.
# -- --
#    LOCAL_PROJECT_NODE_MODULES="/tmp/${PROJECT}-node_modules"
#    echo "...creating temp directory for node_modules; $LOCAL_PROJECT_NODE_MODULES"
#    mkdir -p $LOCAL_PROJECT_NODE_MODULES
#    echo "...creating a link in workspace to temp directory"
#    ln -snf $LOCAL_PROJECT_NODE_MODULES node_modules
# -- --
    # -- setting private npm registry
    echo "...setting private registry to $NPM_REGISTRY"
    npm config set registry $NPM_REGISTRY
    # -- install node modules locally to run tests
    echo "...running npm install"
    npm install
    # -- clean any previous report artifacts
    echo "...running grunt clean"
    grunt clean
    # -- install client side dependencies
    echo "...checking for bower.json"
    if [ -z bower.json ]; then
        echo "...found bower.json and running bower cache clean"
        bower cache clean
        echo "...running bower install"
        bower install
    fi
    # -- build client side library
    # NOTE: currently default task is test
    echo "...running grunt"
    grunt
    # -- run QM reports, xunit and coverage reports
    echo "...running grunt qmreports"
    grunt qmreports --build-number=${BUILD_NUMBER}
else
    echo "Sorry, I could not find the give workspace '$WORKSPACE' directory for '$PROJECT' project."
    exit 1
fi
