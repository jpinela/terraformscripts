resource "aws_instance" "example_ec2_server" {
  ami           = "ami-04e914639d0cca79a"
  instance_type = "t2.micro"

  tags = {
    Name = "PIs Ec2Example"
  }
  key_name = aws_key_pair.emr_keypair.key_name
}