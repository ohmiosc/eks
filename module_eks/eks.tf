module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = "eks-lamark-certi"
  cluster_version = "1.25"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {resolve_conflicts = "OVERWRITE"}
  }
  vpc_id     = "vpc-0b5047bc48612be61"
  subnet_ids = ["subnet-0a5e74c4927206ccb", "subnet-0807102eee6ab8f69"]

  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 500
  }

  eks_managed_node_groups = {
    eks_certi_g = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "eks_certi_g"
      }

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }

    eks_certi_spot = {
      desired_size = 1
      min_size     = 1
      max_size     = 10

      labels = {
        role = "eks_certi_spot"
      }

      taints = [{
        key    = "market"
        value  = "spot"
        effect = "NO_SCHEDULE"
      }]

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn  = module.eks_admins_iam_role.iam_role_arn
      username = module.eks_admins_iam_role.iam_role_name
      groups   = ["system:masters"]
    },
  ]


  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
  }

  tags = {
    Environment = "staging"
  }
}

# https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2009
data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  # token                  = data.aws_eks_cluster_auth.default.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.default.id]
    command     = "aws"
  }
}