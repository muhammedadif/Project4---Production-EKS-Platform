module "networking" {

  source = "./modules/networking"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_1 = "10.0.1.0/24"
  public_subnet_2 = "10.0.2.0/24"

  az1 = "us-east-1a"
  az2 = "us-east-1b"

  private_subnet_1 = "10.0.101.0/24"
  private_subnet_2 = "10.0.102.0/24"

}

module "iam" {

  source = "./modules/iam"

}

module "eks" {
  source = "./modules/eks"

  cluster_name = "production-eks-cluster"

  kubernetes_version = "1.33"

  cluster_role_arn = module.iam.eks_cluster_role_arn

  private_subnet_ids = module.networking.private_subnet_ids

  cluster_security_group_id = module.networking.eks_cluster_security_group_id

  node_role_arn = module.iam.eks_node_role_arn
}