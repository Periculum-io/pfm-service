# Environment
Environments represent deployed instances of Insights platform. This is the place where new environments should be created 
and modification of existing ones should happen.

Environments instantiate building blocks from [modules](../modules) and configure them in a way that they can work together
according to the architecture. For the time being we have three environments for different purposes:
1) [development](development)
2) [staging](staging)
3) [production](production)

## Symlinks
Since the environments are identical (use same modules, create same AWS resources) and only differ in configuration, 
it would be complicated to apply all changes three times (<i>e.g. if a new Fargate service is added into ECS, a developer 
would have to replicate this change in each environment in order to make them consistent</i>). 

Because of that the deployment structure is described only once in [common](common) directory and <b>symlinks</b> are 
placed in target environment directories instead. These symlinks point to the original sources in `common` so all changes to
`common/*` sources are safely propagated to all environments.

## Main
Each environment directory contains `main.tf` file where Terraform and its providers are configured.

`Main.tf` files in all environments are identical with one exception. In <b>backend</b> section, they define a location for 
the Terraform state files. All environment use same [S3 bucket](https://s3.console.aws.amazon.com/s3/buckets/insights-terraform-backend-bucket?region=us-east-1&tab=objects) 
but the path to respective state files is different to make sure that environments are properly isolated and their state can not be rewritten by 
accident. It is also critical measurement to allow more people to safely work on the same environment.

## terraform.tfvars
As mentioned, because of symlinks, modules used and resources created in all environments are identical. What makes 
the environments different is their configuration and that's when `terraform.tfvars` files come into action.

`*.tfvars` files in terraform are where the values for variables are defined. Every time a configuration change on the 
environment has to be done (e.g. rename something, change number of replicas, add availability zones, etc.), the value
has to be set here.

## Important notes
Below is a set of notes to TF files that not only use modules but usually create some additional AWS resources directly.

### routing.tf
This file configures routing in AWS ALB. The reason for having it here instead of [aws-infrastructure](../modules/aws-infrastructure)
is that routing is an application specific knowledge and should not be bound with simple creation of the ALB instance. 
 
With current configuration if the host matches `alb_listener_routing_host_pfm_api` variable, the request is routed
to Insights-API service. Everything else is routed to frontend.

### lambda-pdf-processor.tf
In contrast to other files that create lambda functions with help of `aws-lambda` module, lambda function for PDF processor
is different because apart of creation of the lambda function itself, it also creates integration with AWS SQS directly in 
the `lambda-pdf-processor.tf`. 

The reason for this is simple, integration with SQS is only one and the rule of generalization says not to generalize anything
that has less than two usages. For the time being, having the integration directly in environment makes life easier.

### secrets-manager.tf
Creates IAM users for Insights-API service that can produce messages to SQS queue and read S3 bucket with configuration and pdfs. 
Created users' access keys and secrets are stored in AWS Secrets Manager (name of the secret is taken from `insights_api_secret_manager_arn` variable). 