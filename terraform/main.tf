module "networking" {
  source      = "./modules/networking"
  environment = var.environment
}

module "security" {
  source      = "./modules/security"
  environment = var.environment
  vpc_id      = module.networking.vpc_id
}

module "alb" {
  source            = "./modules/alb"
  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = [module.networking.public_subnet_a_id, module.networking.public_subnet_b_id]
  security_group_id = module.security.alb_security_group_id
  depends_on        = [module.networking]
}

module "iam" {
  source      = "./modules/iam"
  environment = var.environment
}

module "logging" {
  source      = "./modules/logging"
  environment = var.environment
}

module "ecr" {
  source      = "./modules/ecr"
  environment = var.environment
}

module "ecs" {
  source                = "./modules/ecs"
  environment           = var.environment
  cloud_api_image       = "${module.ecr.repository_url}:v1"
  execution_role_arn    = module.iam.execution_role_arn
  log_group_name        = module.logging.log_group_name
  public_subnet_ids     = [module.networking.public_subnet_a_id, module.networking.public_subnet_b_id]
  ecs_security_group_id = module.security.ecs_security_group_id
  target_group_arn      = module.alb.target_group_arn

  depends_on = [
    module.alb,
    module.iam,
    module.networking,
    module.security,
  ]
}
