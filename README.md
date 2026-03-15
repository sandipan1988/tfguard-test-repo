# TFGuard Action Test Repository

This repository is set up to test the [TFGuard GitHub Action](https://github.com/sandipan/tfguard-action).

## Setup Instructions

1.  **Create a Secret**: In your GitHub repository settings, add a secret named `TFGUARD_API_KEY` with your TFGuard API key.
2.  **Push to GitHub**: Push this repository to GitHub to trigger the workflow.
3.  **Review Results**: Check the "Actions" tab in your repository to see the security scan results.

## Included Test Files

- `main.tf`: Contains intentional security vulnerabilities (public S3 bucket, open security group) to verify that the scanner correctly identifies them.

## Workflow Configuration

The workflow is located at `.github/workflows/test-tfguard.yml`. It is configured to fail on `CRITICAL` issues by default.
