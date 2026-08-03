# Production-Grade AWS EKS Application Platform

A production-style DevOps platform for deploying and operating a containerized multi-tier application on Amazon EKS.

## Project Status

🚧 In active development.

## Project Goal

The goal of this project is to design and implement a secure, scalable, highly available, and automated application deployment platform on AWS using modern DevOps practices.

The platform will demonstrate:

- Infrastructure provisioning using Terraform
- Application containerization using Docker
- Container image management using Amazon ECR
- Kubernetes orchestration using Amazon EKS
- Application packaging and deployment using Helm
- Automated CI/CD
- High availability and autoscaling
- Secure networking and access controls
- Observability and troubleshooting
- Failure testing and recovery

## Application

This project uses the open-source Medusa commerce application as the workload.

The application itself is not the focus of this project. The primary focus is the design, automation, deployment, security, scaling, and operation of the AWS/EKS platform hosting it.

## Architecture

Architecture documentation will be added as the platform is implemented.

## Project Structure

```text
production-eks-platform/
├── application/
├── architecture/
├── ci-cd/
├── docs/
├── helm/
├── kubernetes/
├── monitoring/
├── terraform/
├── .gitignore
└── README.md
