—————————————- Ranjith’s Assignment -1——————————————

This guide will help you deploy Assignment-1 , which includes staging and production network modules along with web servers. Follow these steps to successfully deploy the assignment.

Staging Network Module

1. Navigate to the Assignment Directory
Change your working directory to the Assignment folder:

       cd Assignment/

2. Implement the Staging Network Module

    Change the directory using below command to move into staging network directory

    cd terraform/Project/Staging/network/

3. Create an S3 Bucket

Create an S3 bucket and replace its name with the existing name in the network/config.tf file.

    terraform-project-12

4. Deploy the Configuration

    Deploy the configuration using the following commands:

    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    
Webserver Deployment    
    
5. Once the configuration is deployed successfully, change the directory to move into the webserver directory

    cd ../webserver/
    
6. Configure the Webserver 

Change the ip address in variable.tf file for "my_private_ip" and "my_public_ip"

my_private ip should be replaced with cloud9 instance private ip address and my_public_ip should be replaced with cloud9 instance public ip address
    
7. Create an RSA Keypair
    Create an RSA keypair file and change the key pair name in the webserver/main.tf file for "aws_key_pair."

    ssh-keygen –t rsa project-staging 
    
    (or)
    
    change the file name in webserver/main.tf file "aws_key_pair" and create a keypair using above command
    
8. Deploy the Webserver
Deploy the Webserver using below commands

    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    
9. Bastion Host Connection 
Once the webserver is successfully deployed, bastion host can be connected using below command

   ssh -i <keypair_name> ec2-user@<bastion public ip>

If you encounter an "Unprotected file" error, run the following command to change its unprotected state:

    chmod 400 <keypair_name>

After this bastion host connection will be established successfully 

10. Connect VM2 through bastion host

Create a keypair name using the below command in bastion host
       ssh-keygen –t rsa <keypair_file>  
Connect VM2 instance from bastion host using below command

        ssh -i <keypair_name> ec2-user@<VM2 Private ip>
        
Once the connection successfully established , try connecting using Http
    Curl <VM2_Private_IP>

It will show the output ""welcome......

Use "exit" command to exit host

11. Production Network and Webserver
 Deploy the Production Network

    Change the directory to move into Production/network using below command
    cd ../../Production/network/

   Create a s3 bucket and replace the name with the existing name in network/config.tf file
    
    Deploy using below commands
    
    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve

12. Deploy the Production Webserver

Once successfully deployed, move to the webserver folder using:

     cd ../webserver
    
Create a RSA keypair file using below command     

    ssh-keygen –t rsa <keypair_file> 
    
Replace the keypair name in main.tf file and Deploy using below commands
    
    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    
After successfully deploying all the code, you can confirm the status of your infrastructure deployment in the AWS Management Console. Additionally, you can ensure the successful VPC peering connection by following these steps:

Access the AWS Management Console.

In the navigation pane, go to "VPC" and select "Peering Connections" from the menu on the left.

Here, you can verify that the two VPCs created for staging and production environments are now successfully interconnected through VPC peering. This connection enables seamless communication between your environments, allowing them to work together as intended.

This provides a more structured and step-by-step approach for users to confirm their deployment and verify the VPC peering connection in the AWS portal.
    
    


    
      

   
   





