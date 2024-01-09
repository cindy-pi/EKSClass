## <p style="text-align: center;">Terraform to AWS Lab</p>

Welcome to my Terraform to AWS lab.  First we need to discuss what terraform is for:

Terraform is an infrastructure as code tool that lets you build, change, and version infrastructure safely and efficiently. This includes low-level components like compute instances, storage, and networking; and high-level components like DNS entries and SaaS features.

### *Here are the 3 main stages of terraform:*


![Alt text](./diagrams/exhibit-01-terraform.avif)

The Write Stage is where we store the code part of our:
<br>
<br>
**<p style="text-align: center;">Infrastructure as Code (IaC)<br> main.tf**</p>

```
variable "hello_world" {
  description = "A variable to hold the Hello World message"
  default     = "Hello, World!"
}

resource "null_resource" "hello_world_echo" {

  provisioner "local-exec" {
    command = "echo ${var.hello_world}"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

output "hello_world_message" {
  value = var.hello_world
}

```
### Variable (hello world):  
This is a declaration of a variable named hello_world. Variables in Terraform are used to make configurations more dynamic and flexible. This particular variable is set to hold a default message "Hello, World!" and comes with a descriptive comment.  
<br>
**Variables** are used to define values that can be reused throughout the Terraform configuration. Variables enhance flexibility and reusability by allowing parameters to be changed without altering the main configuration.

### Resource (null resource with local-exec provisioner):  
This resource is used to execute a command on the local machine running Terraform, not on a cloud resource. The local-exec provisioner here is configured to echo the hello_world variable. The triggers attribute ensures that this resource is always executed on each apply, using the timestamp() function.  
<br>
**Resources** are the core component of Terraform, representing infrastructure objects such as virtual networks, compute instances, or higher-level components like DNS records. A resource block declares a piece of infrastructure, its type, and its configuration.

### Output (hello world message):  
The output is a way to display or export data from Terraform configurations. In this case, it outputs the value of the hello_world variable, making it visible when Terraform applies the configuration.  
<br>
**Outputs** are used to extract useful information about the resources, like IP addresses or other computed data. Outputs can be queried or displayed after Terraform has run, and can also be used to pass data to other Terraform configurations.  

### Data Sources

### Providers
