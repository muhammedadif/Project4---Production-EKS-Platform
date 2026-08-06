# Amazon ECR Image Management

## Overview

Amazon Elastic Container Registry (ECR) is used as the private container registry for the Spring PetClinic microservices.

Docker images are built using the project's custom Dockerfile and pushed to dedicated Amazon ECR repositories. These images will later be consumed by the CI/CD pipeline and Amazon EKS.

## ECR Repository Design

A separate private ECR repository is maintained for each core microservice:

* `petclinic-config`
* `petclinic-discovery`
* `petclinic-customers`
* `petclinic-visits`
* `petclinic-vets`
* `petclinic-gateway`
* `petclinic-admin`

Using separate repositories provides clear image ownership and allows each microservice to be independently versioned and managed.

## Image Tagging Strategy

Two types of image tags are used.

### 1. Release / Milestone Tags

The initial manually validated images use a version tag:

```text
1.0
```

These tags represent manually created project milestones or releases.

### 2. Git SHA Tags

Automated image publishing uses the Git commit SHA:

```text
sha-<git-commit>
```

Example:

```text
sha-b8f89a3
```

This provides traceability between:

```text
Git Commit
    ↓
Docker Image
    ↓
Amazon ECR
    ↓
Deployment
```

The `latest` tag is not used as the primary deployment identifier because it does not uniquely identify the source revision used to create an image.

## ECR Security Configuration

The ECR repositories are configured with:

* Private repository access
* IAM-based authentication
* Immutable image tags
* Image scanning on push
* No hardcoded AWS credentials

The development EC2 instance accesses ECR through its IAM role.

Docker authenticates to ECR using a temporary authorization token obtained through the AWS CLI.

## Image Tag Immutability

ECR repositories use immutable image tags.

Once an image such as:

```text
petclinic-customers:1.0
```

has been pushed, another image cannot overwrite the same `1.0` tag.

This improves deployment consistency and prevents an existing image version from unexpectedly changing.

## Image Scanning

Image scanning is enabled on push for all seven ECR repositories.

This allows container images pushed to ECR to be checked for known software vulnerabilities.

More extensive container and Kubernetes security hardening will be implemented later in the project.

## Lifecycle Management

Automated Git-based image tags use the prefix:

```text
sha-
```

Example:

```text
sha-b8f89a3
```

An ECR lifecycle policy is configured for each repository to retain the 10 most recent `sha-*` images.

Older matching images are automatically expired to prevent unnecessary registry storage growth.

Release or milestone tags such as `1.0` are not targeted by this lifecycle rule.

## ECR Push Automation

The script:

```text
scripts/push-images.sh
```

automates the ECR publishing process.

It performs the following operations:

1. Detects the configured AWS region.
2. Retrieves the AWS account ID.
3. Constructs the ECR registry URL.
4. Generates an image tag from the current Git commit SHA.
5. Authenticates Docker with Amazon ECR.
6. Tags each local PetClinic image with its ECR repository URI.
7. Pushes each image to its corresponding ECR repository.

The script expects the seven PetClinic Docker images to already exist locally.

Image building remains handled separately by:

```text
scripts/build-images.sh
```

This keeps Docker image building and ECR publishing as separate responsibilities.

## Container Image Flow

```text
Spring PetClinic Source
        ↓
Maven Build
        ↓
Custom Dockerfile
        ↓
Local Docker Images
        ↓
ECR Authentication
        ↓
Image Tagging
        ↓
Amazon ECR
        ↓
CI/CD Pipeline
        ↓
Amazon EKS
```

## Current ECR Repositories

```text
Amazon ECR
│
├── petclinic-config
├── petclinic-discovery
├── petclinic-customers
├── petclinic-visits
├── petclinic-vets
├── petclinic-gateway
└── petclinic-admin
```

Each repository initially contains the manually validated `1.0` image.

Future CI/CD builds will publish images using Git SHA-based tags such as:

```text
sha-<git-commit>
```

