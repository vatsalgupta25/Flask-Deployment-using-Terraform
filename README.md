Flask Deployment using Terraform.
For using the project, Make sure you have an aws account, an aws user with ec2 and s3 permissions (though iam) in your ide.
make sure you have terraform installed properly.
clone the repository.
create the neccesary underlying infrastruture through 02_setup.tf file and the proceed with 03_tf file.
remember to change the id's for vpc, subnet , and sg's in 03_tf.tf file, which you would have received from 02_setup.tf file.
terraform init
terraform plan
terraform apply 
make sure to type in yes.
you will get the ip of your ec2 instance in the output.
connect to the ip from above on port 5000 to validate the flask app.

