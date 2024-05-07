# Ranjith’s Assignment -1

This guide will help you deploy Terraform, which includes staging and production network modules along with web servers. Follow these steps to successfully deploy.

## Step 1: Staging Network Module

1. **Navigate to the Directory**: Change your working directory to the folder:

    ```bash
    cd Assignment/
    ```

2. **Implement the Staging Network Module**: Change the directory using the following command to move into the staging network directory:

    ```bash
    cd terraform/Project/Staging/network/
    ```

3. **Create an S3 Bucket**: Create an S3 bucket and replace its name with the existing name in the `network/config.tf` file:

    ```
    terraform-project-12
    ```

4. **Deploy the Configuration**: Deploy the configuration using the following commands:

    ```bash
    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    ```

## Step 2: Webserver Deployment

1. **Change to Webserver Directory**: Once the configuration is deployed successfully, change the directory to move into the webserver directory:

    ```bash
    cd ../webserver/
    ```

2. **Configure the Webserver**: Change the IP address in the `variable.tf` file for "my_private_ip" and "my_public_ip". The private IP should be replaced with the cloud9 instance private IP address and the public IP should be replaced with the cloud9 instance public IP address.

3. **Create an RSA Keypair**: Create an RSA keypair file and change the key pair name in the `webserver/main.tf` file for "aws_key_pair".

    ```bash
    ssh-keygen –t rsa project-staging 
    ```

    (or) change the file name in the `webserver/main.tf` file "aws_key_pair" and create a keypair using the above command.

4. **Deploy the Webserver**: Deploy the Webserver using the following commands:

    ```bash
    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    ```

## Step 3: Bastion Host Connection

1. **Connect to Bastion Host**: Once the webserver is successfully deployed, the bastion host can be connected using the following command:

    ```bash
    ssh -i <keypair_name> ec2-user@<bastion_public_ip>
    ```

    If you encounter an "Unprotected file" error, run the following command to change its unprotected state:

    ```bash
    chmod 400 <keypair_name>
    ```

    After this, the bastion host connection will be established successfully.

## Step 4: Connect VM2 through bastion host

1. **Create Key Pair on Bastion Host**: Create a keypair name using the following command on the bastion host:

    ```bash
    ssh-keygen –t rsa <keypair_file>
    ```

2. **Connect VM2 from Bastion Host**: Connect VM2 instance from the bastion host using the following command:

    ```bash
    ssh -i <keypair_name> ec2-user@<VM2_Private_ip>
    ```

    Once the connection is successfully established, try connecting using HTTP:

    ```bash
    curl <VM2_Private_IP>
    ```

    It will show the output "welcome......". Use the "exit" command to exit the host.

## Step 5: Production Network and Webserver

1. **Deploy the Production Network**: Change the directory to move into the Production/network using the following command:

    ```bash
    cd ../../Production/network/
    ```

    Create an S3 bucket and replace the name with the existing name in the `network/config.tf` file. Deploy using the following commands:

    ```bash
    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    ```

2. **Deploy the Production Webserver**: Once successfully deployed, move to the webserver folder using the following command:

    ```bash
    cd ../webserver
    ```

    Create an RSA keypair file using the following command:

    ```bash
    ssh-keygen –t rsa <keypair_file> 
    ```

    Replace the keypair name in the `main.tf` file and deploy using the following commands:

    ```bash
    terraform init
    terraform validate
    terraform plan
    terraform apply -auto-approve
    ```

After successfully deploying all the code, you can confirm the status of your infrastructure deployment in the AWS Management Console. Additionally, you can ensure the successful VPC peering connection by following these steps:

- Access the AWS Management Console.
- In the navigation pane, go to "VPC" and select "Peering Connections" from the menu on the left.
- Here, you can verify that the two VPCs created for staging and production environments are now successfully interconnected through VPC peering. This connection enables seamless communication between your environments, allowing them to work together as intended.

This provides a more structured and step-by-step approach for users to confirm their deployment and verify the VPC peering connection in the AWS portal.
