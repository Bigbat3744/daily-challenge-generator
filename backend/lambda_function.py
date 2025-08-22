import json
import random

def lambda_handler(event, context):
    challenges = [
        "Build a REST API with Flask",
        "Write a Terraform module for EC2",
        "Automate S3 uploads with Boto3",
        "Create a CI/CD pipeline with GitHub Actions",
        "Secure an API Gateway with IAM roles"
    ]
    
    selected = random.choice(challenges)
    
    return {
        "statusCode": 200,
        "headers": { "Content-Type": "application/json" },
        "body": json.dumps({ "challenge": selected })
    }

