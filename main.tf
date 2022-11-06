
//what i am working with (my provider -> aws)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

// confuguration of where i work 
// "us-east-1 = us east (n.virginia)"

provider "aws" {
  region = "us-east-1"
}

#### here you create sourses that you want/need ####

// creating VPC 
// notes for myself:
//* in amazom you can create vpc without a name cos there you can relay on id 
//***everything that will be connected to amazon will be written in the scope {} 
resource "aws_vpc" "ArgamanAvraham-dev-vpc" {
  cidr_block = "10.0.0.0/26"
  tags = {
    "Name" = "ArgamanAvraham-dev-vpc"
  }
}

//creating subnet
resource "aws_subnet" "ArgamanAvraham-k8s-subnet" {
  cidr_block = "10.0.0.0/27"
  vpc_id     = aws_vpc.ArgamanAvraham-dev-vpc.id
  tags = {
    "Name" = "ArgamanAvraham-k8s-subnet"
  }
  availability_zone = "us-east-1a"
}
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.ArgamanAvraham-dev-vpc.id
  tags = {
    Name = "instance-gateway"
  }
}

resource "aws_route" "routeIGW" {
  route_table_id         = aws_vpc.ArgamanAvraham-dev-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

