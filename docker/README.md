# Docker Containerization

This directory contains the custom containerization configuration used to package and run the Spring PetClinic microservices.

## Implementation

The project uses a reusable multi-stage Dockerfile for the Java microservices.

Key containerization features:

- Multi-stage Spring Boot image construction
- Eclipse Temurin JRE runtime
- Spring Boot layered JAR extraction
- Non-root container execution
- Versioned Docker images
- Docker health checks using Spring Boot Actuator
- Dedicated Docker network for service communication
- Health-aware service startup dependencies

## Application Images

The following images are built locally:

- petclinic-config:1.0
- petclinic-discovery:1.0
- petclinic-customers:1.0
- petclinic-visits:1.0
- petclinic-vets:1.0
- petclinic-gateway:1.0
- petclinic-admin:1.0

## Build

From the project root:

```bash
./scripts/build-images.sh
