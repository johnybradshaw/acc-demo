# outputs.tf

# modules/lke

output "cluster_link" {
  description = "The link to the LKE cluster in the Linode Cloud Manager."
  value       = module.lke.cluster_link
}

output "cluster_endpoint" {
  description = "The API endpoint for the deployed LKE cluster."
  value       = module.lke.cluster_endpoint
}

output "cluster_kubeconfig" {
  description = "The Kubeconfig file for the deployed LKE cluster."
  value       = module.lke.cluster_kubeconfig
  sensitive   = true
}

# modules/lke-networking

output "lke_firewall_url" {
  description = "The link to the firewall created for the LKE cluster."
  value       = module.lke-networking.lke_firewall_url
}

# modules/lke-helm 

output "wordpressURL" {
    value = module.lke-helm.wordpressURL
    description = "Wordpress URL"
}
output "wordpressAdmin" {
    value = module.lke-helm.wordpressAdmin
    description = "Wordpress Admin URL"
}
output "wordpressUsername" {
    value = module.lke-helm.wordpressUsername
    description = "Wordpress Username"
}
output "wordpressPassword" {
    value = module.lke-helm.wordpressPassword
    description = "Wordpress Password"
    sensitive = true
}