/*
    AWS parameters
*/

provider "aws" {
  access_key 	= "${var.aws_access_key}"
  secret_key 	= "${var.aws_secret_key}"
  region 		= "${var.aws_region}"
}

resource "aws_key_pair" "ljubon-key-practice" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}


/*
    Network configuration
*/

resource "aws_vpc" "PublicServers_VPC" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags { Name = "Public-servers_VPC" }
}

resource "aws_internet_gateway" "PublicServers_GW" {
  vpc_id = "${aws_vpc.PublicServers_VPC.id}"
  tags {Name = "InternetGateway"}
}

resource "aws_subnet" "PublicServers_Subnet" {
  vpc_id = "${aws_vpc.PublicServers_VPC.id}"

  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.availability_zone}"

  tags {Name = "Public Subnet"}
}

resource "aws_route_table" "public_routing" {
  vpc_id = "${aws_vpc.PublicServers_VPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.PublicServers_GW.id}"
  }

  tags {Name = "Public Subnet"}
}

resource "aws_route_table_association" "public_routingAssociation" {
  subnet_id = "${aws_subnet.PublicServers_Subnet.id}"
  route_table_id = "${aws_route_table.public_routing.id}"
}

/*
    Security settings
*/

resource "aws_security_group" "public" {
  name = "vpc_public"
  description = "Allow incoming HTTP, HTTPS, SSH, ICMP connections."

  # inbound
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    # SSH
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  vpc_id = "${aws_vpc.PublicServers_VPC.id}"

  tags {Name = "PublicServers"}
}

/*
    Instances / Servers
*/

resource "aws_instance" "server_1" {
  ami = "${var.amis}"
  private_ip = "${lookup(var.instance_ips, count.index)}"
  availability_zone = "${var.availability_zone}"
  private_ip = "192.168.1.201"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.PublicServers_Subnet.id}"
  source_dest_check = false
  associate_public_ip_address = true

  tags {Name = "Server_1"}
}

resource "aws_eip" "server_1_EIP" {
  instance = "${aws_instance.server_1.id}"
  vpc = true
}

resource "aws_instance" "server_2" {
  ami = "${var.amis}"
  private_ip = "${lookup(var.instance_ips, count.index)}"
  availability_zone = "${var.availability_zone}"
  private_ip = "192.168.1.202"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.PublicServers_Subnet.id}"
  source_dest_check = false
  associate_public_ip_address = true

  tags {Name = "Server_2"}
}

resource "aws_eip" "server_2_EIP" {
  instance = "${aws_instance.server_2.id}"
  vpc = true
}

resource "aws_instance" "server_3" {
  ami = "${var.amis}"
  private_ip = "${lookup(var.instance_ips, count.index)}"
  availability_zone = "${var.availability_zone}"
  private_ip = "192.168.1.203"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.public.id}"]
  subnet_id = "${aws_subnet.PublicServers_Subnet.id}"
  source_dest_check = false
  associate_public_ip_address = true

  tags {Name = "Server_3"}
}

resource "aws_eip" "server_3_EIP" {
  instance = "${aws_instance.server_3.id}"
  vpc = true
}

/*
    Outputs
*/

output "Server1" {
  value = "Server_1 -> ${aws_eip.server_1_EIP.public_ip}"
}
output "Server2" {
  value = "Server_1 -> ${aws_eip.server_2_EIP.public_ip}"
}
output "Server3" {
  value = "Server_3 -> ${aws_eip.server_3_EIP.public_ip}"
}
