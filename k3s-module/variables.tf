variable "k3s_token" {
    type = string
    description = "K3s token"
    default = "d2da4318bbbe36d3c129107c8d52e83a3161ce83"
}

variable "instance_type" {
    type = string
    description = "EC2 instance type"
    default = "t2.micro"
}

variable "num_workers" {
    type = number
    description = "Number of worker nodes"
    default = 2
}

variable "cluster_name" {
    type = string
    description = "The Kubernetes Cluster Name"
    default = "k3s-david"
}

variable "dns_domain_name" {
   type = string
   description = "The Kubernetes DNS Domain Name"
   default = "sda-dev-projects.nl"
}

variable "zone_id" {
    type = string
    description = "AWS DNS Zone ID for records creation"
    default = "Z1BQBEESZM3Q8"
}
