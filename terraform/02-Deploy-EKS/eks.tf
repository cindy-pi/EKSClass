module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.20.0"  # Use the latest version

  cluster_name    = local.cluster_name
  cluster_version = "1.28"

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "eks-node-micro"
      #instance_types = ["t3.micro"]
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 1
    }
  }
  depends_on = [module.vpc.name]
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name             = local.cluster_name
  addon_name               = "vpc-cni"
  tags = {
    "eks_addon" = "vpc-cni"
    "terraform" = "true"
  }
  depends_on = [module.eks.cluster_name]
}
