# variables.tf

variable "linode_config" {
  description = "Configuration for Linode services."
  type = object({
    email     = string // Linode account email address
    api_token = string // Linode API token
    region    = string // Linode region to deploy to
    secret_key = string // Secret key for DDNS
    tags = list(string) // Tags to apply to all resources
  })
}

variable "dns" {
    description = "DNS Configuration"
    type = object({
      # domain    = string         // Domain name for the application
      # soa_email = string         // SOA email address for the domain
      ddns      = string         // DDNS hostname
      ddns_secure = bool         // Use HTTPS for DDNS service
    })
}

variable "lke_cluster" {
  description = "LKE Cluster Configuration"
  type = object({
    name        = string         // Name of the LKE cluster
    region      = string         // Linode region for the LKE cluster
    k8s_version = string         // Kubernetes version for the LKE cluster
    high_availability = bool     // Enable or disable high availability
    tags        = list(string)   // Tags for the LKE cluster
    node_pools  = list(object({  // List of node pools for the LKE cluster
      type  = string             // Type of nodes in the pool
      count = number             // Number of nodes in the pool
      autoscaler = optional(object({
        min_nodes = number
        max_nodes = number
      }))
    }))
  })
}

variable "production" {
  description = "Use production certificates (true) or staging certificates (false)"
  type = bool
  default = false
}

variable "subdomain" {
  description = "Subdomain for the Wordpress site"
  type = string

  validation {
    condition     = can(regex("^[a-zA-Z]+$", var.subdomain))
    error_message = "The subdomain must only contain letters."
  }
}