# Terraform Modules Collection

Hey there! This is my personal stash of reusable Terraform modules that I've built up over time. I use them across different projects to keep things consistent and save myself from rewriting the same infrastructure code every time. Think of it as my go-to toolkit for spinning up AWS resources quickly and securely.

## What's in the Box

### AWS Modules

These are the workhorses – modules for common AWS services with smart defaults and built-in security practices.

- **s3**: Set up S3 buckets with versioning, encryption, lifecycle rules, and public access blocking.
- **ec2**: Launch EC2 instances with proper networking, security groups, and instance profiles.
- **vpc**: Build VPCs complete with subnets, internet gateways, NAT gateways, and route tables.
- **iam-role**: Create IAM roles with flexible trust relationships, session limits, and tagging.
- **iam-policy**: Generate managed policies or attach inline policies to roles.
- **iam-policy-attachment**: Attach existing managed policies to roles or users for fine-tuned permissions.

### Global Modules

Still cooking these up – expect modules for cross-cloud setups or general infra bits.

### Kubernetes Modules

On the horizon – modules to deploy and manage stuff in Kubernetes clusters.

## Getting Started

Each module lives in its own folder and comes with its own README full of examples. To pull one into your project:

1. Grab this repo (clone it or download the zip).
2. In your Terraform files, point to the module like this:

```hcl
module "my_bucket" {
  source = "./path/to/terraform-modules/aws/s3"

  bucket_name = "my-awesome-bucket"
  versioning_enabled = true
  # Check the module's README for all options
}
```

3. Run your usual Terraform commands: `init`, `plan`, `apply`.

Dive into each module's README for the nitty-gritty on variables, outputs, and real-world examples.

## A Few Notes

- These modules are designed to be flexible but opinionated – they follow AWS best practices out of the box.
- I test them in my own environments, but always double-check for your use case.
- If something's missing or you spot an improvement, let me know!

## License

Feel free to use and adapt these as you see fit. If you build something cool with them, I'd love to hear about it.

Happy terraforming!
