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
            EC2["EC2 t3.micro<br/>Apache Web Server"]
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
```

**Current deployment:** One EC2 instance serves the sample website over HTTP. The other subnets are configured but do not currently host workloads. An Application Load Balancer, Auto Scaling Group, database, NAT Gateway, and HTTPS endpoint are not currently deployed.

## Technologies Used

- Terraform
- Amazon Web Services (AWS)
- Amazon VPC and EC2
- AWS IAM and Security Groups
- AWS CLI
- Git and GitHub
- Windows PowerShell
- GitHub Actions

## Project Structure

```text
terraform-aws-infrastructure-automation/
|-- .github/
|   `-- workflows/
|       `-- terraform-ci.yml
|-- modules/
|   |-- network/
|   |   |-- main.tf
|   |   `-- outputs.tf
|   |-- security/
|   |   |-- main.tf
|   |   `-- outputs.tf
|   `-- compute/
|       |-- main.tf
|       `-- outputs.tf
|-- .gitignore
|-- .terraform.lock.hcl
|-- main.tf
|-- outputs.tf
|-- providers.tf
|-- terraform.tfvars.example
|-- variables.tf
`-- versions.tf
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

```bash
terraform fmt -recursive
```

Initialize and validate the configuration:

```bash
terraform init
terraform validate
```

Preview proposed infrastructure changes:

```bash
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

## Security Scanning and Findings

This project uses Checkov in GitHub Actions to scan Terraform configuration for common AWS security misconfigurations.

The CI security scan currently runs with `--soft-fail` so findings can be reviewed before security policies are made blocking.

### Verified Security Controls

- EC2 root EBS volume encryption is enabled.
- EC2 Instance Metadata Service Version 2 (IMDSv2) is required.
- The EC2 instance uses the `EC2-SSM-Role` instance profile.
- The VPC default security group is restricted.
- The web security group allows inbound HTTP on port 80 and outbound HTTPS on port 443.

### Findings Under Review

- **CKV2_AWS_5 - Security group attachment:** Checkov reports that the web security group is not attached to another resource. The live EC2 configuration confirms that the security group is attached, and Terraform state tracks the same security group ID. The cause of the Checkov finding is still under investigation.
- **CKV_AWS_88 - Public EC2 IP:** The instance has a public IP for direct access to the demonstration website.
- **CKV_AWS_260 - Public HTTP ingress:** Port 80 is intentionally open to serve the sample website. HTTP does not encrypt traffic.
- **CKV_AWS_130 - Public subnet IP assignment:** Public subnets currently allow automatic public IP assignment; this setting is under review.
- **CKV_AWS_135 - EBS optimization:** Checkov reports that EBS optimization is not explicitly enabled in the Terraform configuration. AWS reports the current `t3.micro` instance as `EbsOptimized = False` and lists its optimization support as `default`. The finding remains under investigation; no configuration change has been made because preserving the existing EC2 instance and website is a priority.
- **CKV_AWS_126 - Detailed monitoring:** Deferred pending cost assessment.
- **CKV2_AWS_11 - VPC Flow Logs:** Deferred pending cost assessment.

Findings are reviewed individually rather than blindly suppressed. Changes to existing AWS resources are made only after reviewing the Terraform plan and considering availability, security, and cost.


## Cost Considerations

AWS usage is not guaranteed to be free. Check current pricing and your account's Free Tier eligibility before provisioning resources. EC2, public IPv4 addresses, storage, and data transfer may incur charges.

The private subnets do not use a NAT Gateway, avoiding NAT Gateway charges but also providing no NAT-based outbound internet access for private workloads.

Review running resources and AWS billing after testing.

## Future Improvements

- Configure secure remote Terraform state storage and state locking.
- Improve module documentation and variable configuration.
- Explore an Application Load Balancer and Auto Scaling Group.
- Explore a private database tier, HTTPS, monitoring, and alerting.
- Add deployment screenshots to document the project.

## Learning Outcomes

- Infrastructure as Code using Terraform
- Reusable Terraform modules
- AWS VPC and subnet design
- Public and private routing
- EC2 provisioning and web server deployment
- Security group configuration
- Terraform outputs and state-aware refactoring
- Git version control and GitHub
- GitHub Actions for automated Terraform formatting and validation
