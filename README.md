# 🧠 Daily Coding Challenge Generator — Serverless DevOps Project

## Overview

This project is a fully serverless application built on AWS using **Lambda**, **API Gateway**, **DynamoDB**, and **S3**, provisioned entirely with **Terraform**. It delivers daily coding challenges via a public API and tracks completed challenges, with a frontend hosted on S3.

But more than just infrastructure, this project is a story of persistence, troubleshooting, and growth—each error faced and resolved became a lesson in cloud engineering.

---

## 🌍 Live Demo

- **Challenge API Endpoint:** [`/challenge`](https://rayofvvjz4.execute-api.eu-west-2.amazonaws.com/prod/challenge)
- **Frontend Website:** [`daily-challenge-frontend`](http://daily-challenge-frontend-f69a1f06.s3-website.eu-west-2.amazonaws.com)

---

## 🧱 Architecture

| Component              | Purpose                                                                 |
|------------------------|-------------------------------------------------------------------------|
| `AWS Lambda`           | Generates coding challenges dynamically                                 |
| `API Gateway`          | Serves challenges via RESTful endpoint                                  |
| `DynamoDB`             | Stores completed challenges for tracking                                |
| `S3 Static Website`    | Frontend interface for users                                            |
| `Terraform`            | Infrastructure as Code for reproducibility and automation              |

---

## 🛠️ Technologies Used

- **Terraform** for IaC
- **AWS Lambda** (Python)
- **API Gateway**
- **DynamoDB**
- **S3**
- **IAM Roles & Policies**
- **GitHub Actions** (planned for CI/CD)

---

## 📖 The Journey: Challenges Faced & Lessons Learned

### 1. **Terraform IAM Role Creation — Access Denied (403)**

**Problem:**  
Terraform failed to create the IAM role for Lambda due to insufficient permissions:

**Resolution:**  
I updated the IAM user (`github-actions-s3-user`) to include:
- `IAMFullAccess`
- `AWSLambda_FullAccess`
- `AmazonAPIGatewayAdministrator`

**Lesson:**  
Understanding AWS IAM policies is critical. Permissions must be explicitly granted for Terraform to manage resources.

---

### 2. **API Gateway Deployment — Access Denied**

**Problem:**  
Terraform couldn’t create the API Gateway due to missing `apigateway:POST` permissions.

**Resolution:**  
Added `AmazonAPIGatewayAdministrator` to the IAM user. Re-ran `terraform apply` successfully.

**Lesson:**  
Even seemingly minor permissions like `POST` can block entire workflows. Always verify IAM policies before deploying.

---

### 3. **Lambda Packaging & Deployment**

**Problem:**  
Packaging the Lambda function correctly and wiring it to API Gateway required careful attention to:
- Handler format
- IAM execution role
- Lambda permissions for API Gateway invocation

**Resolution:**  
Defined `aws_lambda_permission` and `aws_api_gateway_integration` resources in Terraform. Verified the handler and runtime configuration.

**Lesson:**  
Lambda + API Gateway integration is powerful but unforgiving—every detail matters.

---

### 4. **Testing the Endpoint**

**Problem:**  
After deployment, I needed to verify the API was returning valid challenge data.

**Resolution:**  
Used `curl` to test the endpoint:
```bash
curl https://rayofvvjz4.execute-api.eu-west-2.amazonaws.com/prod/challenge

