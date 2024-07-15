
resource "aws_key_pair" "emr_keypair" {
	key_name="emr07_keypair"
	public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdH5HZmvKYI2YclSFbztCJY/CGdm3xouE07nnCh+DfbJhAUjzsvXJu5DA9yIBXLwAM19ES6V4Bh2Wkef7LgGvwauxTmoiBt9MVgxkLeCZ6V7RDjoTcBwmVfk4vQzptXsDJm2RFJl1BqEIN4GSpyjLjmjEywKIuO3HRPNyu8j2WtoI6GsRR52j9hI7LOSEOA7c57o8J27SIVq55XgDXVRLCtt90h11cdo/SESm7sJ9P0RWNj6lZq17fXx5VXsxdiJ1XKkBxxC+FE5s6INtrDqiM9F/5KGLe+d7ZDnK1sMf5/95qg6rlTy8ZWmna/Yg6qIjUXrtxJ4Mka0L46b1DxlUN"
	tags = {
		env = "teste" 
	}
}