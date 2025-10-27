provider "aws" {
    region = "us-east-1"
}

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
        bucket = "unique-name"
        key    = "vpc/terraform.tfstate"
        region = "us-east-1"
    }
}
output "private_subnet_id" {
    value = data.terraform_remote_state.vpc.outputs.private_subnet_id   
}   

resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    subnet_id     = data.terraform_remote_state.vpc.outputs.private_subnet_id

    tags = {
        Name = "ExampleInstance"
    }
}
