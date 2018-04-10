#!/usr/bin/env bash

set -ev

SCRIPT_DIR=`dirname "$0"`
SCRIPT_NAME=`basename "$0"`
SSH_OPTS=-oStrictHostKeyChecking=no

if [[ "$(uname)" == "Darwin" ]]; then
    DOCKER_CMD=docker
else
    DOCKER_CMD=" docker"
fi

if [[ -z $($DOCKER_CMD images | grep test-container) ]] ; then
    echo "Building test container"
    docker build -t test-container $SCRIPT_DIR > /dev/null
fi

echo "Testing $1"
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo "$@"
$DOCKER_CMD run \
    --rm \
    --name test.$$ \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOST_CODE_DIR:$CODE_DIR -w $CODE_DIR \
    -e COVERALLS_TOKEN=$COVERALLS_TOKEN \
    -e TRAVIS_JOB_ID=$JOB_NAME \
    -e TRAVIS_BRANCH=$BRANCH_NAME \
    -e TRAVIS_PULL_REQUEST=$CHANGE_ID \
    -e TRAVIS=$BUILD_TAG \
    -e COMMIT=$COMMIT \
    -e HOST_HOME=$HOST_HOME \
    -e HOST_CODE_DIR=$HOST_CODE_DIR \
    -e SONAR_TOKEN=$SONAR_TOKEN \
    -e SONAR_HOST=$SONAR_HOST \
    test-container \
    sh -c "export PYTHONPATH=\$PYTHONPATH:\$PWD/test ; python test/$@"
