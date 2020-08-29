variable "k3s_token" {
    type = string
    description = "K3s token"
}

variable "instance_type" {
    type = string
    description = "EC2 instance type"
}

variable "num_workers" {
    type = number
    description = "Number of worker nodes"
}

variable "cluster_name" {
    type = string
    description = "The Kubernetes Cluster Name"
}

variable "dns_domain_name" {
   type = string
   description = "The Kubernetes DNS Domain Name"
}

variable "zone_id" {
    type = string
    description = "AWS DNS Zone ID for records creation"
}
