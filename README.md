# Hybrid Cloud CI/CD Pipeline

![Architecture](./docs/Architecture.png)

This repository contains configuration for our hybrid cloud CI/CD pipeline that spans both on-premises infrastructure and AWS Cloud deployment.

## Architecture Overview

The pipeline implements a modern DevOps workflow with infrastructure as code, continuous integration, and continuous deployment capabilities across hybrid environments:

- **Development Environment**: On-premises infrastructure where developers work with local Terraform configurations
- **Integration Environment**: GitLab for source control and limited CI pipeline
- **Deployment Environments**:
  - Staging server (on-premises)
  - Production server (on-premises)
  - AWS Cloud resources

## Component Breakdown

### On-Premises Components

- **Developer Workspace**: Local Terraform configurations for infrastructure definition
- **GitLab**: Source code repository and limited CI pipeline for builds
- **GitLab Runner**: CI job executor that handles build and push operations when triggered
- **Jenkins**: Primary automation server that orchestrates the majority of the CI/CD workflow
  - Jenkins Server: Central automation controller
  - Jenkins Agents: Distributed workers for pipeline tasks
  - **Staging Server Actions**: start, stop, rollback, upcode
  - **Production Server Actions**: start, stop, restart
- **Staging Server**: Pre-production environment for testing
- **Production Server**: Live environment serving end users
- **Zabbix**: Monitoring solution for infrastructure and application health
- **Harbor Registry**: Container registry for storing and distributing Docker images

### Cloud Components (AWS)

- **AWS Cloud**: Public cloud environment
  - **Region**: AWS geographic deployment area
  - **VPC**: Virtual Private Cloud network isolation
  - **Availability Zone**: Redundant data center for high availability
  - **Public Subnet**: Network segment for publicly accessible resources
  - **Services**:
    - Compute resources (EC2 instances)
    - Harbor registry for Docker images

## Workflow

1. **Development**:
   - Developer writes code and Terraform configurations
   - Changes are merged to staging branch in GitLab
   ![image](./docs/imgs/741d137c-fad3-4788-99f1-224c677524c1.png)
   - Approve request to provision resources in AWS
   ![image](./docs//imgs/a97f6b83-ce0a-4cfe-94e6-232eff14a0e4.png)
   - Create resources in AWS
   ![image](./docs/imgs/9d32c10a-863e-4208-97b4-20ed2d10f702.png)
   - Deploy Harbor registry in AWS
   ![image](./docs/imgs/be7eaeae-9cfc-4db0-afa2-3b34fcc0643a.jpeg)


2. **Staging Process**:
   - Staging server pulls code from staging branch
   - Builds application and pushes Docker images to Harbor registry
   - Staging server pulls images from Harbor for testing
   - Tests are executed against staging environment
   - Available Jenkins actions:
     - **upcode**: Updates code by pulling from repository, building new images, and deploying
   ![image](./docs/imgs/62b33f34-5614-43f2-8638-20cf1b39a9a6.jpeg)
   ![image](./docs/imgs/937b9c4c-4142-406e-b2c8-787936a8b588.jpeg)
     - **start**: Starts containers with the latest images
   ![image](./docs/imgs/d9fbb22c-6a8c-4c3d-b264-4836728f71cc.jpeg)
     - **stop**: Stops running containers
   ![image](./docs/imgs/f5e0df98-4088-43e8-8c76-4b3d5d868376.jpeg)
   ![image](./docs/imgs/e2ec94c9-1d47-4405-88ff-ebdd7f3b8954.jpeg)
   ![image](./docs/imgs/96402b11-e112-4d76-8aa5-10bb21b47836.jpeg)
     - **rollback**: Reverts to a previous version in case of issues

3. **Release Process**:
   - Upon successful testing, a new tag is released (not merging to main)
   - GitLab Runner is triggered by the new tag
   - Runner builds and pushes images to Harbor registry
   ![image](./docs/imgs/44b879a5-c7a4-42e3-bbda-6abd25ec0c8b.jpeg)
   ![image](./docs/imgs/25f8282a-974e-4456-9c57-8cf46afa77ce.jpeg)

4. **Production Deployment**:
   - Production server pulls the tagged images from Harbor registry
   - Jenkins orchestrates deployment to production environment
   - Application is deployed for user access
   - Available Jenkins actions:
     - **start**: Starts containers with the latest images
   ![image](./docs/imgs/6b2716d6-844d-400a-93e8-888d2b921259.jpeg)
   ![image](./docs/imgs/fd25457a-76e9-4ef9-809c-fb1265eae25a.jpeg)
     - **stop**: Stops running containers
     - **restart**: Restarts containers without changing image versions

5. **Operations**:
   - Zabbix continuously monitors all environments
   - Alerts are sent for any issues detected
   ![image](./docs/imgs/64535bbd-6714-4cb4-8ef1-5a0fc89d8af1.jpeg)
   - Testing with stop action
   ![image](./docs/imgs/12e5323d-88c6-41d7-8643-da938be9e998.jpeg)
   - Zabbix alerts with items and triggers
   ![image](./docs/imgs/98f88b38-e2d4-49f7-b28d-731963630cbd.jpeg)
   - Jenkins agents provide automation support for operational tasks

## Key Features

- **Infrastructure as Code**: Terraform manages cloud resources
- **Hybrid Deployment**: Seamless workflow across on-premises and cloud environments
- **Containerization**: Docker containers ensure consistency across environments
- **Automation**: GitLab CI handling builds when tags are created, with Jenkins orchestrating deployments
- **Monitoring**: Comprehensive monitoring with Zabbix
- **Security**: Network segmentation and access controls

## Configuration

Detailed configuration instructions for each component can be found in their respective directories:

- `/AWS` - Infrastructure as code configurations
- `/Pipeline/gitlab-ci` - Pipeline definitions
- `/Pipeline/*.groovy` - Jenkins job configurations
- `/Docker` - Container definitions
- `/Script` - Utility scripts for automation installation

## Maintenance

Regular maintenance tasks include:

- Reviewing and rotating access credentials
- Updating base images and dependencies
- Monitoring resource usage and scaling as needed
- Performing security patches and updates
