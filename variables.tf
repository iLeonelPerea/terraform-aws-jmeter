variable "aws_region" {
  default = "us-east-1"
}

variable "aws_amis" {
  default = {
    "us-east-1" = "ami-0009c3f63fca71e34"
    "us-west-2" = "ami-7172b611"
  }
}

variable "availability_zones" {
  default = "us-east-1a"
}

variable "master_instance_type" {
  description = "Instance type for master node"
  default = "t2.medium"
}

variable "slave_instance_type" {
  description = "Instance type for slave nodes"
  default = "t2.medium"
}

variable "slave_ssh_public_key_file" {
  description = "SSH public key filename for slave nodes"
  default = "ssh/slave.pub"
}

variable "master_ssh_public_key_file" {
  description = "SSH public key filename for master node"
  default = "ssh/master.pub"
}

variable "master_ssh_private_key_file" {
  description = "SSH private key filename for master node"
  default = "ssh/master"
}

variable "master_ingress_rules" {
  default = {
    "0" = "22"
    "1" = "80"
  }
}

variable "slave_desired_asg_size" {
  description = "Amount of working nodes in ASG"
  default = "2"
}

variable "slave_max_asg_size" {
  description = "Amount of working nodes in ASG"
  default = "20"
}

variable "slave_min_asg_size" {
  description = "Amount of working nodes in ASG"
  default = "1"
}

variable "jmx_script_file" {
  default = "cloudssky.jmx"
  description = "JMX Script to run on master"
}

variable "jmeter3_url" {
  description = "URL with jmeter archive"
  default = "http://apache-mirror.rbc.ru/pub/apache/jmeter/binaries/apache-jmeter-5.2.1.tgz" 
}
