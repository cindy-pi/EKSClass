variable "hello_world" {
  description = "A variable to hold the Hello World message"
  default     = "Hello, World!"
}

output "hello_world_message" {
  value = var.hello_world
}

resource "null_resource" "hello_world_echo" {
  provisioner "local-exec" {
    command = "echo Hello, World!"
  }
}
