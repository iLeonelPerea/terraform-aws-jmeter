resource "aws_security_group" "jmeter-sg" {
  name = "jmeter-sg"
}

resource "aws_security_group_rule" "ingress-private-sgr" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = -1
  self = true

  security_group_id = "${aws_security_group.jmeter-sg.id}"
}

resource "aws_security_group_rule" "egress-private-sgr" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  self = true

  security_group_id = "${aws_security_group.jmeter-sg.id}"
}

resource "aws_security_group_rule" "egress-public-sgr" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.jmeter-sg.id}"
}

resource "aws_security_group_rule" "ingress-public-sgr" {
  count = "${length(var.master_ingress_rules)}"
  
  type = "ingress"
  from_port = "${var.master_ingress_rules[count.index]}"
  to_port = "${var.master_ingress_rules[count.index]}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.jmeter-sg.id}"
}

# resource "aws_security_group_rule" "ingress-public-sgr" {
#   count = "${var.master_ingress_rules}"

#   type              = "ingress"
#   from_port         = "${var.master_ingress_rules[count.index].from_port}"
#   to_port           = "${var.master_ingress_rules[count.index].to_port}"
#   protocol          = "${var.master_ingress_rules[count.index].protocol}"
#   cidr_blocks       = ["${var.master_ingress_rules[count.index].cidr_block}"]
#   security_group_id = "${aws_security_group.jmeter-sg.id}"
# }