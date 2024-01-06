
resource "null_resource" "update_kubeconfig_and_apply_config" {
  provisioner "local-exec" {
    command = <<-EOT
      export KUBECONFIG=.kube  # Adjust the path to your kubeconfig file
      aws eks --region ${local.cluster_region} update-kubeconfig --name ${local.cluster_name}

      cat > amazon-vpc-cni.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: amazon-vpc-cni
  namespace: kube-system
data:
  enable-network-policy-controller: "false"
  enable-windows-ipam: "true"
EOF

      kubectl apply -f amazon-vpc-cni.yaml
    EOT
  }

  depends_on = [
    module.eks.cluster_name
  ]
}


