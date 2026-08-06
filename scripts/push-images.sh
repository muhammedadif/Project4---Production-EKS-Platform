#!/bin/bash

set -e

if ! command -v aws >/dev/null 2>&1; then
  echo "Error: AWS CLI is not installed."
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Docker is not installed."
  exit 1
fi

AWS_REGION=$(aws configure get region)

if [ -z "$AWS_REGION" ]; then
  echo "Error: AWS region is not configured."
  exit 1
fi

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
IMAGE_TAG=$(git rev-parse --short HEAD)

SERVICES=(
  config
  discovery
  customers
  visits
  vets
  gateway
  admin
)

echo "AWS Region: $AWS_REGION"
echo "ECR Registry: $ECR_REGISTRY"
echo "Image Tag: $IMAGE_TAG"

echo "Authenticating Docker with Amazon ECR..."

aws ecr get-login-password --region "$AWS_REGION" \
  | docker login \
      --username AWS \
      --password-stdin "$ECR_REGISTRY"

for service in "${SERVICES[@]}"
do
  LOCAL_IMAGE="petclinic-${service}:1.0"
  ECR_IMAGE="${ECR_REGISTRY}/petclinic-${service}:${IMAGE_TAG}"

  echo "Tagging $LOCAL_IMAGE -> $ECR_IMAGE"

  docker tag "$LOCAL_IMAGE" "$ECR_IMAGE"

  echo "Pushing $ECR_IMAGE"

  docker push "$ECR_IMAGE"
done

echo "All images pushed successfully."
