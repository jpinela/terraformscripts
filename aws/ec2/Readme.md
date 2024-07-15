creating a simple ec2 instance

to get the string for the aws/ec2/keypair.tf file what I did was:
1. visit https://8gwifi.org/sshfunctions.jsp
2. insert a random passphrase (REMEMBER IT)
3. copy the private key and save it into a file like keypair.pem
4. copy the public key and paste it into the public_key argument of the keypair.tf
5. you then can use that pem file , with the passphrase to ssh into your instance.

that is it.

after that you can do the usual.
1. terraform init
2. terraform plan
3. terraform apply
4. (and finally) terraform destroy, to clean your resources and prevent useless costs.
