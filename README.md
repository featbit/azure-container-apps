# Deploy FeatBit to Azure with Terraform

This repo contains terraform code for deploying FeatBit on Azure. FeatBit is a feature flag service that helps you manage feature flags and evaluate them in real-time. You can find more information about FeatBit in [FeatBit official website](https://www.featbit.co/) and [Github Repo](https://github.com/featbit/featbit).

![Deploy to Azure](featbit-azure-container-apps.drawio.png)

As shown in the figure above, FeatBit's services are deployed as Azure Container Apps (ACA) in Azure. Such as FeatBit's UI portal, FeatBit's API server, FeatBit's evaluation server, FeatBit's DA server. Evaluation service and API service communicate with DA service inside ACA.

>>> Note: ACA is actually a managed Kubernetes cluster. You can find more information about ACA in [Azure Container Apps official document](https://docs.microsoft.com/en-us/azure/container-apps/). 

All services are located in an Azure VNet, we use private endpoint and private DNS zone to secure the access to Azure Cache for Redis and Azure CosmosDB for MongoDB. You can find more information about private endpoint and private DNS zone in [Azure official document](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview).

FeatBit's UI portal, API server and Evaluation server are exposed to the public internet through an Azure Load Balancer and Azure IP addresses. You can find more information about Azure Load Balancer in [Azure official document](https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview).

## Azure Getting Started


If you're not familiar with Terraform Azure Provider, you can follow the steps in the [official Azure Provider tutorial](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build).

## Deploy FeatBit to your Azure

```bash
# run terraform init to download the required providers
terraform init

# run terraform plan to see what will be deployed
terraform plan

# run terraform apply to deploy FeatBit to your Azure
terraform apply
```

Before applying the Terraform deployment, you can modify variables defined in variables.tf files to customize your deployment. For example, you can

- Change the name of the resource group by changing the value of the `resource_group_name` variable in the `variables.tf` file in the `terraform` directory.
- Change the name of the resources location by changing the value of `location` variable in the `variables.tf` file in the `terraform` directory.
- Change the redis configuration by changing the value of `redis` variable in the `variables.tf` file in the `terraform` directory.

For changing cpu, memory, number of replica of each container app, currently you need to edit directly in the `main.tf` file in the `terraform/aca` directory. We will add these variables in the future.

## Support

For any questions, you can create an issue, contact us by joining our [Slack channel](https://join.slack.com/t/featbit/shared_invite/zt-1ew5e2vbb-x6Apan1xZOaYMnFzqZkGNQ) or email us to [support@featbit.co](mailto:support@featbit.co)

## Important Notes

The terraform code is for FeatBit Standard version ([see difference between Standard and Pro version](https://docs.featbit.co/docs/tech-stack/standard-vs.-professional)), for Pro version and High Available solutions you can contact us by joining our [Slack channel](https://join.slack.com/t/featbit/shared_invite/zt-1ew5e2vbb-x6Apan1xZOaYMnFzqZkGNQ) or email us to [contact@featbit.co](mailto:contact@featbit.co).