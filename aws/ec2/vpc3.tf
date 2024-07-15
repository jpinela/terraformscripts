resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "emrvpc01"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "emr-gateway"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "emr-route-table"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.cluster_name}-subnet"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "emr_master_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # This should ideally be restricted to a trusted source IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-master-sg"
  }
}

resource "aws_security_group" "emr_slave_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Internal communication within the VPC
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # This should ideally be restricted to a trusted source IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-slave-sg"
  }
}


resource "aws_security_group" "engine_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 18888
    to_port     = 18888
    protocol    = "tcp"
    security_groups = ["${aws_security_group.workspace_sg.id}"]

  }

  tags = {
    Name = "${var.cluster_name}-emrs-engine-sg"
  }
}


# ============== PARA O STUDIDO ===================
resource "aws_security_group" "emr_editor" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 63535
    protocol    = "tcp"
    security_groups = ["${aws_security_group.emr_master_sg.id}"]
  }

  tags = {
    Name = "emre-editor"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_master_2_editor" {
  security_group_id = aws_security_group.emr_master_sg.id

  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 63535
  referenced_security_group_id = "${aws_security_group.emr_editor.id}"
  
  tags = {
    Name = "igress-2-emre-editor"
  }  
 }
 

#========================= PARA O STUDIO =========================
# https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio-security-groups.html

resource "aws_security_group" "workspace_sg" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-emrs-ws-sg"
  }
}
 
 
resource "aws_vpc_security_group_egress_rule" "workspace_2_engine_sg" {
  security_group_id = aws_security_group.workspace_sg.id

  from_port   = 18888
  ip_protocol = "tcp"
  to_port     = 18888
  referenced_security_group_id = "${aws_security_group.engine_sg.id}"
  
  tags = {
    Name = "egress-2-emre-engine"
  }  
 }

 
 