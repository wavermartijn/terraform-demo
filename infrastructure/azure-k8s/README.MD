# Provision Kubernetes cluster 

This document describes how to provision a Kubernetes cluster on Azure using Terraform

### Requirements
 Please make sure that: 
 
 - You have acess to a working Azure account
 - You have installed the azure cli `az`
 - You have installed Terraform v0.13.x 
 (https://www.terraform.io/downloads.html)
 
 ### Setup
 Edit the (git ignored) `sec/auth.tfvars` file and provide the necessary credentials for the Azure account. 
 @TODO Describe ssh public/private key setup.... pub key needed in sec folder
 Navigate to this folder '(configuration_management)' and initialize Terraform using:  
 `terraform init`
 This should return output telling the backend is initializing and plugins are being installed. 
 When everything is ok it should inform the initialization was successful.

Execute the following command, after substituting the {ENVIROMENT} with one of the environment names dev,...,prod 
 ` terraform plan -var-file=sec/auth.tfvars -var-file=env/{ENVIROMENT}.tfvars`
 This will use the main.tf file implicitly and Terraform will fill in the variables with the ones found in the 2 specified variable files.
 
 
 
 ### Terraform
 Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.
 
 Configuration files describe to Terraform the components needed to run a single application or your entire datacenter. Terraform generates an execution plan describing what it will do to reach the desired state, and then executes it to build the described infrastructure. As the configuration changes, Terraform is able to determine what changed and create incremental execution plans which can be applied.
 
 The infrastructure Terraform can manage includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc.
 
 ### Future developments
 
 A DevOps docker image in being setup. This docker image will contain pre-installed DevOps tools and settings including Terraform and the `az` azure cli