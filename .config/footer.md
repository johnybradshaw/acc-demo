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
