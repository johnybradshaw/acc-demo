# main.tf

# Get the current user's profile
data "linode_profile" "me" {
    provider = linode.default # Use the Linode provider with the default alias
}

# Create the LKE cluster
module "lke" {
    source = "./modules/lke"

    linode_config = var.linode_config # Pass the Linode configuration to the module
    lke_cluster   = var.lke_cluster # Pass the LKE cluster configuration to the module

    providers = {
        linode = linode.default
        random = random.default
    }
}

# Create the LKE cluster networking
module "lke-networking" {

    source = "./modules/lke-networking"

    linode_config = var.linode_config # Pass the Linode configuration to the module
    lke_cluster_id   = module.lke.cluster_id # Pass the LKE cluster configuration to the module

    providers = {
        linode = linode.default
    }
}

module "lke-helm" {

    source = "./modules/lke-helm"

    linode_config = var.linode_config # Pass the Linode configuration to the module
    lke_cluster_id = module.lke.cluster_id # Pass the LKE cluster configuration to the module
    dns = var.dns # Pass the DNS configuration to the module
    production = var.production # Pass the production flag to the module
    subdomain = var.subdomain # Pass the subdomain to the module

    providers = {
        linode = linode.default
        helm = helm.default
        kubernetes = kubernetes.default
        kubectl = kubectl.default
        random = random.default
    }

}
