 
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

