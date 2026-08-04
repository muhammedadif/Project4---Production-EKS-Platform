i#!/bin/bash

set -e

VERSION="1.0"

APP_DIR="application/spring-petclinic-microservices"
DOCKERFILE="$(pwd)/docker/Dockerfile"

echo "======================================"
echo " Building PetClinic Microservices"
echo " Version: ${VERSION}"
echo "======================================"

cd "$APP_DIR"

echo "Building application JAR files..."
./mvnw clean package -DskipTests

build_image() {

    SERVICE_DIR=$1
    IMAGE_NAME=$2
    PORT=$3

    JAR_FILE=$(find "${SERVICE_DIR}/target" \
        -maxdepth 1 \
        -name "*.jar" \
        ! -name "*.original" \
        | head -1)

    if [ -z "$JAR_FILE" ]; then
        echo "ERROR: JAR not found for ${SERVICE_DIR}"
        exit 1
    fi

    JAR_NAME=$(basename "$JAR_FILE" .jar)

    echo
    echo "--------------------------------------"
    echo "Building ${IMAGE_NAME}:${VERSION}"
    echo "--------------------------------------"

    docker build \
        -f "$DOCKERFILE" \
        --build-arg ARTIFACT_NAME="$JAR_NAME" \
        --build-arg EXPOSED_PORT="$PORT" \
        -t "${IMAGE_NAME}:${VERSION}" \
        "${SERVICE_DIR}/target"
}

build_image "spring-petclinic-config-server" \
            "petclinic-config" \
            "8888"

build_image "spring-petclinic-discovery-server" \
            "petclinic-discovery" \
            "8761"

build_image "spring-petclinic-customers-service" \
            "petclinic-customers" \
            "8081"

build_image "spring-petclinic-visits-service" \
            "petclinic-visits" \
            "8082"

build_image "spring-petclinic-vets-service" \
            "petclinic-vets" \
            "8083"

build_image "spring-petclinic-api-gateway" \
            "petclinic-gateway" \
            "8080"

build_image "spring-petclinic-admin-server" \
            "petclinic-admin" \
            "9090"

echo
echo "======================================"
echo " All images built successfully"
echo "======================================"

docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" \
    | grep petclinic
