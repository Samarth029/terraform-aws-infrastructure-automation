# Terraform AWS Infrastructure Automation

A modular Infrastructure as Code (IaC) project using Terraform to manage AWS networking, security, and compute resources.

## Overview

This project demonstrates reusable Terraform modules, AWS network design, EC2 provisioning, and version control with Git and GitHub.

## Architecture

- **VPC:** `10.0.0.0/16`
- **Public subnets:** Two subnets across Availability Zones.
- **Private subnets:** Two subnets reserved for future private workloads.
- **Internet Gateway:** Internet routing for public subnets.
- **Route tables:** Separate public and private routing configurations.
- **Security group:** Allows inbound HTTP traffic on port 80.
- **EC2:** Runs an Apache web server serving a sample HTML page.

### Architecture Diagram

```mermaid
flowchart TB
    Internet([Internet]) -->|HTTP : 80| IGW[Internet Gateway]

    subgraph VPC["AWS VPC - 10.0.0.0/16"]
        subgraph PublicA["Public Subnet A - 10.0.1.0/24"]
            SG[Web Security Group]
            EC2[EC2 t3.micro<br/>Apache Web Server]
            SG --> EC2
        end

        subgraph PublicB["Public Subnet B - 10.0.2.0/24"]
            PUBB[Available public subnet]
        end

        subgraph PrivateA["Private Subnet A - 10.0.11.0/24"]
            PRIVA[Reserved for future workloads]
        end

        subgraph PrivateB["Private Subnet B - 10.0.12.0/24"]
            PRIVB[Reserved for future workloads]
        end

        IGW --> PublicA
    end

    EC2 --> Website[Sample HTTP Website]

    classDef active fill:#d9ead3,stroke:#38761d,color:#000
    classDef planned fill:#eeeeee,stroke:#666666,color:#000

    class EC2,SG,IGW active
    class PUBB,PRIVA,PRIVB planned

The current deployment uses one EC2 instance. An Application Load Balancer, Auto Scaling Group, database, NAT Gateway, and HTTPS are not currently implemented.

## Technologies Used

- Terraform
- Amazon Web Services (AWS)
- Amazon VPC and EC2
- AWS IAM and Security Groups
- AWS CLI
- Git and GitHub
- Windows PowerShell

## Project Structure

```text
terraform-aws-infrastructure-automation/
|-- main.tf
|-- providers.tf
|-- variables.tf
|-- outputs.tf
|-- versions.tf
|-- .gitignore
|-- terraform.tfvars.example
`-- modules/
    |-- network/
    |   |-- main.tf
    |   `-- outputs.tf
    |-- security/
    |   |-- main.tf
    |   `-- outputs.tf
    `-- compute/
        |-- main.tf
        `-- outputs.tf
```

## Terraform Modules

### Network

Manages the VPC, public and private subnets, Internet Gateway, route tables, and subnet associations.

### Security

Manages the web server security group and its network access rules.

### Compute

Manages the EC2 instance, instance type, subnet, security group, encrypted root volume, and Apache web server setup.

## Prerequisites

Install Terraform, AWS CLI, and Git. You also need an AWS account with appropriate permissions.

Configure the AWS CLI using a dedicated IAM identity with least-privilege permissions. Avoid using root-user access keys.

## Validate the Configuration

Format Terraform files:

```powershell
terraform fmt -recursive
```

Initialize and validate the configuration:

```powershell
terraform init
terraform validate
```

Preview proposed infrastructure changes:

```powershell
terraform plan
```

Always review a plan before approving an apply. Applying Terraform can create, modify, or destroy billable AWS resources.

## Security Practices

- Never commit AWS credentials, access keys, passwords, or secrets.
- Keep Terraform state files, saved plans, and local backups out of Git.
- Use least-privilege IAM permissions.
- Encrypt the EC2 root EBS volume.
- Avoid exposing SSH to the entire internet.
- Restrict network traffic to what the workload requires.
- Do not transmit sensitive information through the sample HTTP website.

## Cost Considerations

AWS usage is not guaranteed to be free. Check current pricing and your account's Free Tier eligibility before provisioning resources. EC2, public IPv4 addresses, storage, and data transfer may incur charges.

The private subnets do not use a NAT Gateway, avoiding NAT Gateway charges but also providing no NAT-based outbound internet access for private workloads.

Review running resources and AWS billing after testing.

## Future Improvements

- Add GitHub Actions for automated Terraform formatting and validation.
- Add an architecture diagram and deployment screenshots.
- Configure secure remote Terraform state storage and state locking.
- Improve module documentation and variable configuration.
- Explore an Application Load Balancer and Auto Scaling Group.
- Explore a private database tier, HTTPS, monitoring, and alerting.

## Learning Outcomes

- Infrastructure as Code using Terraform
- Reusable Terraform modules
- AWS VPC and subnet design
- Public and private routing
- EC2 provisioning and web server deployment
- Security group configuration
- Terraform outputs and state-aware refactoring
- Git version control and GitHub

GitHub: https://github.com/Samarth029