#!/usr/bin/env bash

IMAGE=orders

set -ev

SCRIPT_DIR=$(dirname "$0")

if [[ -z "$GROUP" ]] ; then
    echo "Cannot find GROUP env var"
    exit 1
fi

if [[ -z "$COMMIT" ]] ; then
    echo "Cannot find COMMIT env var"
    exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
    DOCKER_CMD=docker
else
    DOCKER_CMD=" docker"
fi
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR
$DOCKER_CMD run --rm -v $HOST_HOME/.m2:/root/.m2 -v $HOST_CODE_DIR:/usr/src/mymaven -w /usr/src/mymaven 10.56.2.48/devops/maven:3.2-jdk-8 mvn -DskipTests package

ls -al $CODE_DIR/docker
cp -rf $CODE_DIR/docker $CODE_DIR/target/
cp -rf $CODE_DIR/target/*.jar $CODE_DIR/target/docker/${IMAGE}

REPO=${GROUP}/${IMAGE}
    $DOCKER_CMD build -t ${REPO}:${COMMIT} $CODE_DIR/target/docker/${IMAGE};
