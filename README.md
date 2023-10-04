# azure-container-apps

This repo includes terraform code of deploying [FeatBit (a feature flag service)](https://github.com/featbit/featbit) into Azure.

![Deploy to Azure](featbit-azure-container-apps.drawio.png)

As image shown above, this terraform code use Azure vnet, private endpoint and private DNS zone to secure the access to Azure Cache for Redis and Azure CosmosDB for MongoDB. DA server is also protected by Azure Container APPs firewall.

## Azure Getting Started

If you're not familiar with terraform Azure provider, you can follow the steps in [terraform's Azure Provider official tutorial](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build).


## Deploy FeatBit to your Azure

```bash
# run terraform init to download the required providers
terraform init

# run terraform plan to see what will be deployed
terraform plan

# run terraform apply to deploy FeatBit to your Azure
terraform apply
```

Before you apply the terraform deployment, you can change variables defined in variables.tf files to customize your deployment. For example, you can

- Change the name of the resource group by changing the value of `resource_group_name` variable in the file `variables.tf` under `terraform` folder.
- Change the name of the resources location by changing the value of `location` variable in the file `variables.tf` under `terraform` folder.
- Change the redis configuration by changing the value of `redis` variable in the file variables.tf under `terraform` folder.

For changing cpu, memory, number of replica of each container app, currently you need to edit directly in the file `main.tf` under `terraform/aca` folder. We will add these variables in the future.

## Support

For any questions, you can create an issue, contact us by joining our [Slack channel](https://join.slack.com/t/featbit/shared_invite/zt-1ew5e2vbb-x6Apan1xZOaYMnFzqZkGNQ) or email us to [support@featbit.co](mailto:support@featbit.co)

## Important Notes

The terraform code is for FeatBit Standard version ([see difference between Standard and Pro version](https://docs.featbit.co/docs/tech-stack/standard-vs.-professional)), for Pro version and High Available solutions you can contact us by joining our [Slack channel](https://join.slack.com/t/featbit/shared_invite/zt-1ew5e2vbb-x6Apan1xZOaYMnFzqZkGNQ) or email us to [contact@featbit.co](mailto:contact@featbit.co).