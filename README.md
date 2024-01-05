# acc-demo

A simple demo to build a Wordpress app on the Akamai Connected Cloud, configuring a Fully Qualified Domain (FQDN) using a custom Dynamic DNS (DDNS) service.

**Note** When cloning this repo you must either add the `--recurse-submodules` flag e.g.:

```bash
git clone --recurse-submodules https://github.com/johnybradshaw/acc-demo.git
```

or from within the directory after a standard clone:

```bash
git submodule update --init
```

## What does this repo do?

This repo helps you build Wordpress on Akamai Connected Cloud, it does this by creating:

Akamai Connected Cloud Infrastructure:

- Kubernetes Cluster (LKE)
- Load Balancer (Nodebalancer)
- Firewall

On LKE it will deploy:

- NGINX Ingress Controller
- Metrics-Server
- Cert-Manager

Which will then let it deploy:

- MariaDB Database in a Highly Available (HA) configuration
- Wordpress
- TLS Certificate

And this will be secured by a TLS Certificate for the site provided by Let's Encrypt.

This design is modular, and depends on the upstream modules:

- [`lke`](https://github.com/johnybradshaw/acc-lke)
- - Deploys the Linode Kubernetes Cluster
- [`lke-networking`](https://github.com/johnybradshaw/acc-lke-networking)
- - Deploys the Firewall to protect the Cluster
- [`lke-helm`](https://github.com/johnybradshaw/acc-lke-helm)
- - Deploys the following Helm charts:
- - - [metrics-server](https://artifacthub.io/packages/helm/metrics-server/metrics-server)
- - - - Enables Horizontal Pod Autoscaling
- - - [cert-manage](https://artifacthub.io/packages/helm/cert-manager/cert-manager)
- - - - Enables automatic TLS Certificate creation
- - - [nginx](https://artifacthub.io/packages/helm/bitnami/nginx)
- - - - Enables and manages Kubernetes Ingress via a reverse proxy and loadbalancer
- - - [wordpress](https://artifacthub.io/packages/helm/bitnami/wordpress)
- - - - Deploys the application and database

### Dependancies

It is dependant on a [Dynamic DNS service](https://github.com/johnybradshaw/acc-ddns) to provide a Fully Qualified Domain Name (FQDN) based on the username of the person running this Terraform.

The DDNS service requires a `secret_key`, acting as a 'pre-shared key' to hash and sign the request.

<!-- BEGIN_TF_DOCS -->
<!-- The module-name will be auto generated by the script -->
# acc-lke-helm *module*

This module deploys NGINX-Ingress, Metrics Server, Cert-Manager, and Wordpress on a [Linode Kubernetes (LKE) Cluster](https://www.linode.com/docs/products/compute/kubernetes/) on the [Akamai Connected Cloud](https://www.akamai.com/solutions/cloud-computing) using [Terraform](https://terraform.io) and Helm Charts.

## Important

The readme.md has the following sections:

- Requirements - Min requirements for the module to run
- Providers - Providers required by the module
- Inputs- Inputs to the module
- Outputs - Outputs from the module
- Usage - How to use the module

#### Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement_terraform) (>= 1.5.7)

- <a name="requirement_http"></a> [http](#requirement_http) (>=2.1.0)

- <a name="requirement_kubectl"></a> [kubectl](#requirement_kubectl) (>= 2.0.2)

- <a name="requirement_linode"></a> [linode](#requirement_linode) (>= 2.9.3)

- <a name="requirement_random"></a> [random](#requirement_random) (>=3.5.1)

#### Providers

The following providers are used by this module:

- <a name="provider_linode.default"></a> [linode.default](#provider_linode.default) (2.10.0)

#### Modules

The following Modules are called:

##### <a name="module_lke"></a> [lke](#module_lke)

Source: ./modules/lke

Version:

##### <a name="module_lke-helm"></a> [lke-helm](#module_lke-helm)

Source: ./modules/lke-helm

Version:

##### <a name="module_lke-networking"></a> [lke-networking](#module_lke-networking)

Source: ./modules/lke-networking

Version:

#### Required Inputs

The following input variables are required:

##### <a name="input_dns"></a> [dns](#input_dns)

Description: DNS Configuration

Type:

```hcl
object({
      # domain    = string         // Domain name for the application
      # soa_email = string         // SOA email address for the domain
      ddns      = string         // DDNS hostname
      ddns_secure = bool         // Use HTTPS for DDNS service
    })
```

##### <a name="input_linode_config"></a> [linode_config](#input_linode_config)

Description: Configuration for Linode services.

Type:

```hcl
object({
    email     = string // Linode account email address
    api_token = string // Linode API token
    region    = string // Linode region to deploy to
    secret_key = string // Secret key for DDNS
    tags = list(string) // Tags to apply to all resources
  })
```

##### <a name="input_lke_cluster"></a> [lke_cluster](#input_lke_cluster)

Description: LKE Cluster Configuration

Type:

```hcl
object({
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
```

#### Optional Inputs

The following input variables are optional (have default values):

##### <a name="input_production"></a> [production](#input_production)

Description: Use production certificates (true) or staging certificates (false)

Type: `bool`

Default: `false`

#### Outputs

The following outputs are exported:

##### <a name="output_cluster_endpoint"></a> [cluster_endpoint](#output_cluster_endpoint)

Description: The API endpoint for the deployed LKE cluster.

##### <a name="output_cluster_kubeconfig"></a> [cluster_kubeconfig](#output_cluster_kubeconfig)

Description: The Kubeconfig file for the deployed LKE cluster.

##### <a name="output_cluster_link"></a> [cluster_link](#output_cluster_link)

Description: The link to the LKE cluster in the Linode Cloud Manager.

##### <a name="output_lke_firewall_url"></a> [lke_firewall_url](#output_lke_firewall_url)

Description: The link to the firewall created for the LKE cluster.

##### <a name="output_wordpressAdmin"></a> [wordpressAdmin](#output_wordpressAdmin)

Description: Wordpress Admin URL

##### <a name="output_wordpressPassword"></a> [wordpressPassword](#output_wordpressPassword)

Description: Wordpress Password

##### <a name="output_wordpressURL"></a> [wordpressURL](#output_wordpressURL)

Description: Wordpress URL

##### <a name="output_wordpressUsername"></a> [wordpressUsername](#output_wordpressUsername)

Description: Wordpress Username

## Usage

Sample usage of this module is as shown below. For detailed info, look at inputs and outputs.

### Step 1

Create a `terraform.tfvars` file and update with:

```hcl
linode_config = {
  email = "" // Linode account email address
  api_token = "" // Linode API token
  region = "" // // Linode region to deploy to
  secret_key = "" // Secret key for DDNS
  tags        = ["cloud-day", "wordpress"]
}

dns = {  // DNS settings
  ddns = ""  // DDNS domain name for the application
  ddns_secure = true // DDNS secure domain name for the application
}

lke_cluster = {
  name        = "lke-tf-par"  // Name of your LKE cluster
  region      = "fr-par"  // Region where your LKE cluster will be deployed
  k8s_version = "1.28"  // Kubernetes version for your LKE cluster
  tags        = ["dev"]
  high_availability = true // Enable high availability for your LKE cluster
  node_pools  = [  // Node pools configuration
    {
      type        = "g7-highmem-1"  // Type of nodes in the first pool
      count       = 3  // Number of nodes in the first pool
      autoscaler = {  // Enable autoscaling for the first pool
        min_nodes         = 3  // Minimum number of nodes in the first pool
        max_nodes         = 5  // Maximum number of nodes in the first pool
        }
    },
    # {
    #   type        = "g6-standard-2"  // Type of nodes in the second pool
    #   count       = 3  // Number of nodes in the second pool
    #   autoscaler = {  // Disable autoscaling for the first pool
    #     min_nodes         = 3  // Minimum number of nodes in the first pool
    #     max_nodes         = 7  // Maximum number of nodes in the first pool
    #   }
    # }
  ]
}

production = true  // Enable production mode for your application

```

### Step 2

Verify your settings using the following command:

```bash
terraform init
terraform plan
```

### Step 3

Apply the changes

```bash
terraform apply
```

You will see a list of outputs similar to:

```bash
Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

cluster_endpoint = "https://51cb2a61-74a7-4ab5-bc48-6f97991b9e88.fr-par-1.linodelke.net:443"
cluster_kubeconfig = <sensitive>
cluster_link = "https://cloud.linode.com/kubernetes/clusters/123456/summary"
lke_firewall_url = "https://cloud.linode.com/firewalls/123456"
wordpressAdmin = "https://username.ddns.domain.name/wp-login.php"
wordpressPassword = <sensitive>
wordpressURL = "https://username.ddns.domain.name"
wordpressUsername = "username"
```

### Step 4

The build will take sometime to complete, once Terraform reports the build as complete you will need to wait up to 5 minutes for the certificate to be generated and applied.

For security reasons the password to your Wordpress account is not shown automatically, to view it you can run the following command:

`terraform output wordpressPassword`

And then login to Wordpress using the `wordpressAdmin` URL and `wordpressUsername` shown in the output.

### Step 5

To clean up simply run:

`terraform destroy`

And confirm to remove all created resources.
<!-- END_TF_DOCS -->