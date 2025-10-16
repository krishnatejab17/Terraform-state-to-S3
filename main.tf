provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}   


resource "aws_instance" "example" {
    ami           = var.ami_id
    instance_type = var.instance_type
    key_name      = "ec2"
    tags = {
        Name = "ExampleInstance"
    }
}


resource "aws_s3_bucket" "terraform_state" {
  bucket = "krishnateja-sample-terraform-state-bucket-for-testing"

  tags = {
    Name        = "TerraformState"
    Environment = "Dev"
  }
}



# New separate versioning resource
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }




