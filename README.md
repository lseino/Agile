# Agile

The purpose of this project is to create the terraform code to bring up an AWS VPC and an ECR repository. The second part of this project is creating a Dockerfile and a script to build and upload the resulting image.

# Directory Structure
 
``` 
├── README.md
├── build.sh
├── docker
│   ├── Dockerfile
│   ├── README.md
│   ├── etc
│   │   ├── generate-patients.js
│   │   └── generate-users.js
│   ├── index.js
│   ├── lib
│   │   ├── api.js
│   │   ├── config.js
│   │   ├── controllers
│   │   │   └── patients
│   │   │       ├── delete.js
│   │   │       └── get.js
│   │   ├── middleware
│   │   │   ├── authenticate.js
│   │   │   └── authorize.js
│   │   └── services
│   │       └── datastore.js
│   ├── package-lock.json
│   └── package.json
├── modules
│   ├── ecr
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── vpc
│       ├── output.tf
│       ├── private_subnets.tf
│       ├── public_subnets.tf
│       ├── security_group.tf
│       ├── variables.tf
│       └── vpc.tf
└── terraform
    ├── main.tf
    ├── outputs.tf
    └── provider.tf
```

# Requirements

* AWS Cloud Account
* Terraform 1.0.3 or greater
* docker
* AWS cli configured with us-east-1

# Getting started

* git clone https://github.com/lseino/agile.git 
* ```cd agile```

## Setting up VPC instruments with Terraform
* ```cd terraform```
* ```terraform init```
* ```terraform plan```
* ```terraform apply```
* when complete you should have an output of the **ecr repo url**

## Building nodejs app and pushing to docker ecr
* Execute the build script build.sh in the parent dir
* ```chmod +x build.sh```
* ``` ./build.sh agilemd {AWS_ECR} ```           *replace AWS_ECR with the output from terraform*
          e.g ```./build.sh agilemd 593161164007.dkr.ecr.us-east-1.amazonaws.com/agilemd``` 
    
* This will build and push image to repository
* To verify  run``` aws ecr list-images --repository-name agilemd --region us-east-1 ```


# Finish
* ```terraform destroy```