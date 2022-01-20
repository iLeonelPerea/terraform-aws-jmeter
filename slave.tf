resource "aws_autoscaling_group" "jmeter-slave-ASG" {
  availability_zones = ["${split(",", var.availability_zones)}"]

  name = "jmeter-slave-ASG"
  desired_capacity = "${var.slave_desired_asg_size}"
  max_size = "${var.slave_max_asg_size}"
  min_size = "${var.slave_min_asg_size}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.jmeter-slave-lc.name}"

  tag {
    key = "Name"
    value = "jmeter-slave"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "jmeter-slave-lc" {
  name = "jmeter-slave-lc"
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.slave_instance_type}"
  user_data = <<EOF
#!/bin/sh
sudo mkdir /jmeter-slave
cd /jmeter-slave
curl ${var.jmeter3_url} > jMeter.tgz
tar zxvf jMeter.tgz
sudo chown -R ec2-user:ec2-user /jmeter-slave
export JVM_ARGS="-Xms2g -Xmx3g -XX:MaxMetaspaceSize=3g"
SERVER_PORT=1664 apache-jmeter-5.2.1/bin/jmeter-server -Jserver.rmi.ssl.disable=true
EOF

  security_groups = ["${aws_security_group.jmeter-sg.id}"]
  key_name = "${aws_key_pair.jmeter-slave-keypair.key_name}"
}

resource "aws_key_pair" "jmeter-slave-keypair" {
  key_name = "jmeter-slave-keypair"
  public_key = "${file("${var.slave_ssh_public_key_file}")}"
}