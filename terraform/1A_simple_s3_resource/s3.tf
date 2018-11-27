resource "aws_s3_bucket" "state_bucket" {
    
    bucket_prefix = "terraform-bucket-"
    
    versioning {
        enabled = true
    }

    #region = "eu-west-1"
    
    tags {
        Name        = "Terraformed test bucket"
        Deployment = "Testing"
        Created_by  = "Terraform"
    } 
}