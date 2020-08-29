module "k3s" {
    source = "./k3s"
    k3s_token = var.k3s_token
    instance_type = var.instance_type
    num_workers = var.num_workers
    cluster_name = var.cluster_name
    dns_domain_name = var.dns_domain_name
    zone_id = var.zone_id
} 
