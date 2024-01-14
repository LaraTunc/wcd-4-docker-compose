# Docker Compose

This project showcases a straightforward containerized application, with its image hosted on Docker Hub.

In addition to the containerized app, the project provides Terraform scripts to streamline the creation of fundamental AWS infrastructure components. These scripts automate the configuration of a VPC, public subnet, IGW (Internet Gateway), route table, security group, and an EC2 instance within your AWS account. The EC2 instance launches by fetching the containerized application image from Docker, running it on port 3000.
The primary objective of the project is to pull images for this app and MongoDB, launching them on an EC2 instance using Docker Compose.

Explore the Docker Hub repository for the containerized React application [here](https://hub.docker.com/r/laratunc/nodeapp).

# Instructions

Follow these steps to set up and run the project:

1. **Navigate to the "terraform" directory**

```sh
cd terraform
```

2.  **Install Terraform**

    Ensure Terraform is installed on your system. If not, you can follow the official [Terraform Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

3.  **Provision resources**

    Create essential AWS infrastructure components, including a VPC, public subnet, IGW, route table, security group, and an EC2 instance in your AWS profile. Ensure Ansible is installed before running this command.

```sh
terraform init
terraform plan
terraform apply --auto-approve
```

4. **Retrieve the Public IPv4 address of EC2**

   The instance should be named eval-4-instance.

5. **Use the app**

   Open your web browser and enter the following URL, replacing <public-ipv4-address-of-your-instance> with the actual Public IPv4 address of your EC2 instance:
   `http://<public-ipv4-address-of-your-instance>:3000`

6. **Voila 🎉**

   You should see an application that displays famous quotes.

<img src="/public/images/app.gif" height=550>

7. **Destroy**

   To tear down the provisioned resources, run the following.

```sh
terraform destroy
```

# Architecture

![architecture](public/images/architecture.png)

# Running the App Locally

```sh
$ yarn
$ yarn start
```

## Additional Resources

- [GitHub Repository](https://github.com/LaraTunc/wcd-4-docker-compose)
- [Docker Hub Repository](https://hub.docker.com/r/laratunc/nodeapp)
- [Docs Used](#)
  - [Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
  - [Docker Multi-platform Images](https://docs.docker.com/build/building/multi-platform/)
  - Class material used: compose-demo
