# Modules
All modules needed for deployment of Insights platform and underlying infrastructure are structured in this directory.

Where possible, the modules should follow similar naming convention to simplify orientation in a lot of resources.

## aws-api-gateway
This module contains TF resources to create private API Gateway in AWS that only accepts traffic from VPC endpoint. 
Creation of the VPCE is also part of this module.

- [module inputs](aws-api-gateway/variables.tf)
- [module outputs](aws-api-gateway/outputs.tf)

## aws-api-gateway-integration
This module maps lambda functions to REST endpoints in AWS API Gateway. 

Steps that are done by this module:
1) Creation of REST endpoint (resource)
2) Creation of REST method for the endpoint
3) Integration of the endpoint with given lambda function - configures trigger to lambda function
4) Creation of API GW stage and deployment of the endpoint

- [module inputs](aws-api-gateway-integration/variables.tf)
- [module outputs](aws-api-gateway-integration/outputs.tf)

## aws-infrastructure
AWS-infrastructure is the largest module that is responsible for provisioning of mainly networking AWS services that are 
required by Insights platform.

Services that are provisioned by this module:
- VPC and networking concepts like NAT Gateways, private/public subnets, routing tables, etc.
- Application Load Balancer (only the LB, no routing rules are configured)
- ECS Cluster
- DNS records that enables domain based routing into the environment
- S3 buckets
- Secure SQS

The reason of putting all of it in `aws-infrastructure` module is not to provide possibility of reuse but to put all this 
logic in the same place. This module is, therefore, not meant to be instantiated more than once per environment.

<b>Input variables</b> for this module are always associated with the source file that they provide inputs to following 
`<aws-service>-variables.tf` naming convention. For example `ecs-cluster.tf` has its variables declared in 
`ecs-cluster-variables.tf`.

[Module outputs](aws-infrastructure/outputs.tf) are all put together as usual.

## aws-lambda
This module creates a lambda function in AWS. The module provides option to create the lambda function in vpc to allow 
interaction with other AWS services inside a vpc.

The source package is expected to be uploaded to s3 bucket defined by `lambda_source_s3_bucket` and 
`lambda_source_s3_bucket_key` variables.

Significant part of the module is then dedicated to creation of IAM policy to allow the lambda function to produce 
log messages and optionally attach other IAM policies to the role via `lambda_role_additional_policy_arns` variable.

<i>Note: Creation of lambda triggers is not part of this module. Use [aws-api-gateway-integration](aws-api-gateway-integration)
for lambda integrations into API Gateway.</i>

- [module inputs](aws-lambda/variables.tf)
- [module outputs](aws-lambda/outputs.tf)

## aws-rds
This module provisions RDS instance (Postgres) in AWS with randomly generated password to master user. Credentials to 
the master user are stored in AWS Secrets Manger. Target secret is defined by `secret_name` variable.

Ingress traffic is allowed only on port `5432` for security groups defined in `rds_source_security_group_ids` variable.

<b>The storage is encrypted by customer managed key and the database is not accessible from the internet.</b>  

- [module inputs](aws-rds/variables.tf)
- [module outputs](aws-rds/outputs.tf)

## aws-remote-state
This module is needed by [first-provisioning](../first-provisioning) procedure. It is used only to create a s3 bucket 
for Terraform state files.

This module should be reworked into a new module for generic creation of s3 buckets, so it could be used also by
other modules and for other purposes. 

- [module inputs](aws-remote-state/variables.tf)

## insights-init
This is a helper module that provisions a dummy tenant into running environment. 

<b>Before running this module make sure to check that following secrets are present:</b>
- secret from `sm_ec2_private_key` variable has to contain private key that will be used to SSH into EC2 instance
- secret from `sm_ec2_public_key` variable has to contain public key that will be put into EC2 instance to allow 
  connections from its paired private key
- secret from `sm_init` (typically named like `insights/<environment>/init`)variable has to contain following key-values:
  - `rds_dummy_username` - name of the dummy user in RDS that is dedicated to dummy tenant
  - `rds_dummy_password` - password to dummy user
  - `rds_dummy_db` - name of the database dedicated to dummy tenant
  - `s3_analytics_api_token`
  - `auth0_realm` - name of the database connection in Auth0
  - `auth0_audience` - URL to insights-api (e.g. <i>https://api.dev.insights-periculum.com </i>)
  - `auth0_clientId` - ClientId of the Auth0 frontend application
  - `auth0_domain` - Auth0 domain of the Auth0 frontend application
  - `origin` - the domain dedicated to dummy tenant (e.g. <i>perilenda.dev.insights-periculum</i>)

After an environment is created, this module will construct and upload a dummy tenant configuration from 
[s3.tf](insights-init/s3.tf) into S3 bucket.

Next, it will provision a Linux based EC2 instance with a DB script from `{path.module}/../../../../backend/DatabaseScripts/insights/${local.db_init_script_name}`.
The EC2 instance will perform in RDS Postgres instance following operations:
- Create a new database for dummy tenant
- Create a new database user that can only access the dummy database
- Run the DB script for creation of schemes in the dummy database
- Add a record with a new tenant user in `Platform.Users`


<i>Note: This module is not important for deployment of the app and can be safely left out from environments if you don't 
a dummy tenant to be created after deployment.</i>

## insights-service
This modul can be used to deploy a service into ECS container. The module creates IAM roles, attaches them to 
created ECS task definition and deploys the definition as a new Fargate service.

### IAM roles
Two roles are created. First for the task that only allows to produce logs into Cloudwatch log group. Second for the task 
execution, that permits to download Docker image and read a secret values from secret given in `secrets_manager_arn` variable.

### Traffic filtering
The module creates a new security group with ingress traffic allowed only from AWS ALB and associates this group with ECS 
service. All egress traffic is allowed because the task needs to download Docker image from ECR.

- [module inputs](insights-service/variables.tf)
- [module outputs](insights-service/outputs.tf)