#!/bin/bash
#
# Build MapFish Print2 Docker image with options
MFPRINT_VERSION="2.1-SNAPSHOT"
docker build --build-arg IMAGE_TIMEZONE="Europe/Amsterdam" --build-arg MFPRINT_VERSION=${MFPRINT_VERSION} -t justb4/mapfish-print2:${MFPRINT_VERSION} .
