# azure-container-apps
Host FeatBit Feature Flag Service in production environment using Azure Container APPs

## Azure Getting Started

https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-build

```bash
# use the Azure CLI tool to setup your account permissions locally.
az login --tenant 551443f2-94bb-4dd3-a22f-1d267240fe40

# Once you have chosen the account subscription ID, set the account with the Azure CLI.
az account set --subscription "5776697f-f76a-4a4a-9b42-ce2dbe5d7475"

# Create a Service Principal
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475"
```

```bash

# {
#   "appId": "805e4e42-b6e1-4fb0-b348-2fac2bf30ffc",
#   "displayName": "azure-cli-2023-09-06-06-01-56",
#   "password": "X9v8Q~vfC55r3GFIcbF2bQAyuSimqo~LOILvzcIk",
#   "tenant": "551443f2-94bb-4dd3-a22f-1d267240fe40"
# }

# These values map to the Terraform variables like so:

# appId is the client_id defined above.
# password is the client_secret defined above.
# tenant is the tenant_id defined above.

$Env:ARM_CLIENT_ID = "805e4e42-b6e1-4fb0-b348-2fac2bf30ffc"
$Env:ARM_CLIENT_SECRET = "X9v8Q~vfC55r3GFIcbF2bQAyuSimqo~LOILvzcIk"
$Env:ARM_SUBSCRIPTION_ID = "5776697f-f76a-4a4a-9b42-ce2dbe5d7475"
$Env:ARM_TENANT_ID = "551443f2-94bb-4dd3-a22f-1d267240fe40"
```

