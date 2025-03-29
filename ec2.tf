
resource "aws_instance" "web" {
  ami           = "ami-0c1ac8a41498c1a9c"
  instance_type = "t3.micro"

  tags = {
    Name = "baragnini"
  }

  root_block_device {
    delete_on_termination = true
  }
}