#!/bin/bash
#
# Run MapFish Print2 Docker image with options

CONTAINER_NAME="mfprint2-d"
IMAGE="justb4/mapfish-print:2.1-SNAPSHOT"

# Define the mappings for local dirs, ports for container
VOL_MAP_1="-v ${PWD}/webapp/config:/usr/local/tomcat/webapps/ROOT/config:ro"
VOL_MAP_2="-v ${PWD}/webapp/index.html:/usr/local/tomcat/webapps/ROOT/index.html:ro"
VOL_MAP_3="-v ${PWD}/webapp/WEB-INF/web.xml:/usr/local/tomcat/webapps/ROOT/WEB-INF/web.xml:ro"
VOL_MAP="${VOL_MAP_1} ${VOL_MAP_2} ${VOL_MAP_3}"

PORT_MAP="-p 8080:8080"

# Stop and remove possibly old containers
docker stop ${CONTAINER_NAME} > /dev/null 2>&1
docker rm ${CONTAINER_NAME} > /dev/null 2>&1

# Finally run
docker run --name ${CONTAINER_NAME} ${PORT_MAP} ${VOL_MAP} -d -t ${IMAGE}

# When running: get into container with bash
# docker exec -it mfprint2-d bash

