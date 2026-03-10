# Jenkins + Terraform Multi-Account EC2 Deployment (Using AWS Profiles)

## Project Overview

This project demonstrates how to automate infrastructure deployment using **Jenkins, Terraform, and AWS**.

A Jenkins pipeline pulls Terraform code from GitHub and runs it on a Jenkins agent to provision EC2 instances.

The same Terraform code deploys infrastructure using **two different AWS CLI profiles**, simulating deployments across multiple environments.

---

## Architecture

GitHub → Jenkins Master → Jenkins Agent → Terraform → AWS

* **GitHub** stores the Terraform code.
* **Jenkins Master** manages pipelines and job scheduling.
* **Jenkins Agent** executes Terraform commands.
* **Terraform** provisions infrastructure on AWS.

Two AWS profiles are configured on the agent:

* `default` → IAM user `kartik2`
* `kartik-second` → IAM user `kartik-second`

Both profiles deploy EC2 instances using the same Terraform code.

---

## Infrastructure Setup

### Jenkins Master

* Runs Jenkins UI and pipelines
* Instance type: `t3.medium`
* Installed tools:

  * Jenkins
  * Git
  * Java

### Jenkins Agent

* Executes Terraform jobs
* Instance type: `t3.micro`
* Installed tools:

  * Java
  * Git
  * Terraform
  * AWS CLI

---

## Terraform Configuration

Terraform uses **two AWS providers** with different profiles.

```
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

provider "aws" {
  alias   = "second"
  region  = "us-east-1"
  profile = "kartik-second"
}

resource "aws_instance" "ec2_first_user" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"

  tags = {
    Name = "ec2-from-first-user"
  }
}

resource "aws_instance" "ec2_second_user" {
  provider      = aws.second
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"

  tags = {
    Name = "ec2-from-second-user"
  }
}
```

---

## Jenkins Pipeline

The pipeline pulls Terraform code from GitHub and executes Terraform commands on the Jenkins agent.

```
pipeline {
    agent { label 'terraform-agent' }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/<your-username>/terraform-multi-account.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
```

---

## AWS CLI Profiles

Configured on the Jenkins agent:

```
aws configure
aws configure --profile kartik-second
```

Verify accounts:

```
aws sts get-caller-identity
aws sts get-caller-identity --profile kartik-second
```

---

## Result

When the Jenkins pipeline runs:

* Terraform initializes the project
* Terraform plans the infrastructure
* Terraform provisions EC2 instances

Two EC2 instances are created:

* `ec2-from-first-user`
* `ec2-from-second-user`

---

## Repository Structure

```
terraform-multi-account/
│
├── main.tf
└── README.md
```

---

## Skills Demonstrated

* Jenkins Pipeline
* Jenkins Master–Agent architecture
* Infrastructure as Code (Terraform)
* AWS CLI profile management
* Automated infrastructure provisioning
* CI/CD for cloud infrastructure

---

## Future Improvements

* Use **AWS AssumeRole for real multi-account deployment**
* Add **Terraform remote state (S3 + DynamoDB)**
* Add **Jenkins credentials management**
* Implement **separate environments (dev / stage / prod)**

---

## Author

Kartik
DevOps / Cloud Engineering Practice Project
