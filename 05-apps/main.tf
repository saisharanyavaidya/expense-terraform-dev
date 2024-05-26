##-----Below code creates an EC2 instances for backend, frontend, Bastion and Ansible servers
##-----Here ec2 instance creation is done from using an open source module which is safe

module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-backend"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  subnet_id              = local.private_subnet_id
  ami = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-backend"
    }
  )
}

module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-frontend"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-frontend"
    }
  )
}

module "ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}-ansible"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.ansible_sg_id.value]
  subnet_id              = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  user_data = file("expense.sh") // while creating ansible server it will call sh file and execute all the commands 
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-ansible"
    }
  )
  depends_on = [ module.backend, module.frontend ]
}

##----Below code refers to creating R53 records for ec2 instances created

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "backend" #backend.avyan.site
      type    = "A"
      ttl = 1,
      records = [
        module.backend.private_ip
      ]
    },
    {
      name    = "frontend" #frontend.avyan.site
      type    = "A"
      ttl = 1,
      records = [
        module.frontend.private_ip
      ]
    },
    {
      name    = "" #avyan.site
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.public_ip,
      ]
    },
  ]
}