# terraform.tf

terraform {
    required_version = ">= 1.5.7"

    required_providers {
        linode = {
            source = "linode/linode"
            version = ">= 2.9.3"
        }
        random = {
            source = "hashicorp/random"
            version = ">=3.5.1"
        }
        http = {
          source = "hashicorp/http"
          version = ">=2.1.0"
        }
        kubectl = {
          source  = "alekc/kubectl"
          version = ">= 2.0.2"
        }
    }
}

# Initialise the Linode provider
provider "linode" {
  alias = "default"
  token = var.linode_config.api_token

}

# Initialise the Random provider
provider "random" {
  # alias = "default"
}

# Decode the kubeconfig
# Get the LKE cluster object
data "linode_lke_cluster" "lke_cluster" {
    provider = linode.default # Use the Linode provider with the default alias

    id = module.lke.cluster_id
}

locals {
    #depends_on = [ data.linode_lke_cluster.lke_cluster ]
    alias = "default"
    kube_config_decoded = base64decode(data.linode_lke_cluster.lke_cluster.kubeconfig)
    kube_config_map     = yamldecode(local.kube_config_decoded)
    user_name           = local.kube_config_map.users[0].name
    user_token          = local.kube_config_map.users[0].user.token
}
provider "helm" {
    alias = "default"

    kubernetes {
        host  = local.kube_config_map.clusters[0].cluster.server
        token = local.user_token

        cluster_ca_certificate = base64decode(
            local.kube_config_map.clusters[0].cluster["certificate-authority-data"]
        )
    }
}

# Initialise the Kubernetes provider
provider "kubernetes" {
    alias = "default"

    host  = local.kube_config_map.clusters[0].cluster.server
    token = local.user_token

    cluster_ca_certificate = base64decode(
        local.kube_config_map.clusters[0].cluster["certificate-authority-data"]
    )
}

provider "kubectl" {
    alias = "default"

    host  = local.kube_config_map.clusters[0].cluster.server
    token = local.user_token

    cluster_ca_certificate = base64decode(
        local.kube_config_map.clusters[0].cluster["certificate-authority-data"]
    )

    load_config_file = false # Disables local loading of the KUBECONFIG
    apply_retry_count = 15 # Allows kubernetes commands to be retried
}

provider "random" {
  alias = "default"
}