provider "random" {}

module "tags_network" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git"
  namespace = var.name
  name      = "level-2-project"
  delimiter = "-"

  tags = {
    owner = "alpha"
    type  = "network"
  }
}

module "tags_alpha" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git"
  namespace = var.name
  name      = "level-2-project"
  delimiter = "-"

  tags = {
    owner = "alpha"
    type  = "alpha-project"
  }
}

resource "aws_vpc" "alpha_project" {
  cidr_block           = "10.0.0.0/16"
  tags                 = module.tags_network.tags
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "alpha_gateway" {
  vpc_id = aws_vpc.alpha_project.id
  tags   = module.tags_network.tags
}

resource "aws_route" "alpha_internet_access" {
  route_table_id         = aws_vpc.alpha_project.main_route_table_id
  gateway_id             = aws_internet_gateway.alpha_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "alpha" {
  vpc_id                  = aws_vpc.alpha_project.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags                    = module.tags_alpha.tags
}

resource "aws_security_group" "alpha_keeper" {
  vpc_id = aws_vpc.alpha_project.id
  tags   = module.tags_alpha.tags

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_id" "keypair" {
  keepers = {
    public_key = file(var.public_key_path)
  }

  byte_length = 8
}

resource "aws_key_pair" "alpha_keypair" {
  key_name   = format("%s_keypair_%s", var.name, random_id.keypair.hex)
  public_key = random_id.keypair.keepers.public_key
}

data "aws_ami" "latest_alpha" {
  most_recent = true
  owners      = ["772816346052"]

  filter {
    name   = "name"
    values = ["alpha*"]
  }
}

resource "aws_instance" "alpha" {
  ami                    = data.aws_ami.latest_alpha.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.alpha.id
  vpc_security_group_ids = [aws_security_group.alpha_keeper.id]
  key_name               = aws_key_pair.alpha_keypair.id

  root_block_device {
    volume_size = 100
    volume_type = "gp2"
  }

  tags = module.tags_alpha.tags
}
  #l
