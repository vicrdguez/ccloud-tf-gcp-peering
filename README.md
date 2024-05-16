## Running with Nix
This repo is built with Nix. If you are a nix user you don't need to have any extra tool (such as
terraform or gcloud) installed.

First run the following to enter the devshell with all dependencies

```bash
nix develop
```

From here you can use the project as usual, using the terraform commands. However the build comes
with some nix automations to run all with Nix:

```bash
# To deploy the Pre-requisites (GCP resources) if needed. If you already have them provisioned, 
# you can skip this ones
nix run .#pre-plan
nix run .#pre-apply

# Deploy a Confluent Cloud cluster with VPC peering
nix run .#plan
nix run .#apply
```

The apply commands run `terraform plan` if there is no `tfplan` file found, so you can just run the
_apply_ variants if you want.

If you don't have nix and you have `terraform` and `gcloud` installed, just use as you are used to,
the `gcp/` folder contains the needed GCP resources (pre-requisites) and `confluent/` contains the
actual code to deploy a Confluent Cloud cluster with VPC Peering

## Requirements

The following requirements are needed by this module:

- <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) (1.76.0)

- <a name="requirement_google"></a> [google](#requirement\_google) (5.29.0)

## Providers

The following providers are used by this module:

- <a name="provider_confluent"></a> [confluent](#provider\_confluent) (1.76.0)

- <a name="provider_google"></a> [google](#provider\_google) (5.29.0)

## Resources

The following resources are used by this module:

- [confluent_kafka_cluster.dedicated_cluster](https://registry.terraform.io/providers/confluentinc/confluent/1.76.0/docs/resources/kafka_cluster) (resource)
- [confluent_network.gcp-peering-net](https://registry.terraform.io/providers/confluentinc/confluent/1.76.0/docs/resources/network) (resource)
- [confluent_peering.gcp](https://registry.terraform.io/providers/confluentinc/confluent/1.76.0/docs/resources/peering) (resource)
- [google_compute_network_peering.to-cc](https://registry.terraform.io/providers/hashicorp/google/5.28.0/docs/resources/compute_network_peering) (resource)
- [confluent_environment.target-env](https://registry.terraform.io/providers/confluentinc/confluent/1.76.0/docs/data-sources/environment) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_cc-cloud-api-key"></a> [cc-cloud-api-key](#input\_cc-cloud-api-key)

Description: Confluent Cloud 'cloud' API Key used to create resources

Type: `string`

### <a name="input_cc-cloud-api-secret"></a> [cc-cloud-api-secret](#input\_cc-cloud-api-secret)

Description: Confluent Cloud 'cloud' API secret used to create resources

Type: `string`

### <a name="input_cc-cluster-availability"></a> [cc-cluster-availability](#input\_cc-cluster-availability)

Description: Availability of the target cluster. Options limited to: [SINGLE\_ZONE, MULTI\_ZONE, LOW, HIGH]

Type: `string`

### <a name="input_cc-cluster-ckus"></a> [cc-cluster-ckus](#input\_cc-cluster-ckus)

Description: The number of CKUs for the target cluster

Type: `number`

### <a name="input_cc-cluster-name"></a> [cc-cluster-name](#input\_cc-cluster-name)

Description: Name of the target cluster to deploy

Type: `string`

### <a name="input_cc-peering-network-name"></a> [cc-peering-network-name](#input\_cc-peering-network-name)

Description: The name of the Confluent Network used for the private cluster

Type: `string`

### <a name="input_cc-target-env-id"></a> [cc-target-env-id](#input\_cc-target-env-id)

Description: Environment ID target for the cluster deployment

Type: `string`

### <a name="input_gcp-cidr"></a> [gcp-cidr](#input\_gcp-cidr)

Description: GCP CIDR used for Peering

Type: `string`

### <a name="input_gcp-peering-name"></a> [gcp-peering-name](#input\_gcp-peering-name)

Description: The name of the peering connection from GCP to CC

Type: `string`

### <a name="input_gcp-project"></a> [gcp-project](#input\_gcp-project)

Description: GCP project to use for the deployment

Type: `string`

### <a name="input_gcp-region"></a> [gcp-region](#input\_gcp-region)

Description: Region for the deployment

Type: `string`

### <a name="input_gcp-vpc-network-name"></a> [gcp-vpc-network-name](#input\_gcp-vpc-network-name)

Description: GCP VPC used for peering with Confluent Cloud

Type: `string`

### <a name="input_gcp-zone"></a> [gcp-zone](#input\_gcp-zone)

Description: The GCP region

Type: `string`

## Outputs

The following outputs are exported:

### <a name="output_cc-cluster-bootstrap-server"></a> [cc-cluster-bootstrap-server](#output\_cc-cluster-bootstrap-server)

Description: The bootstrap server of the new cluster

### <a name="output_cc-cluster-rest-endpont"></a> [cc-cluster-rest-endpont](#output\_cc-cluster-rest-endpont)

Description: The REST endpoint of the new cluster

### <a name="output_cc-cluster-zones"></a> [cc-cluster-zones](#output\_cc-cluster-zones)

Description: The zones the new cluster is deployed in
