# Deploy FeatBit on Azure using Terraform

This repo contains terraform code for deploying FeatBit on Azure. FeatBit is a feature flag service that helps you manage feature flags and evaluate them in real-time. You can find more information about FeatBit in [FeatBit official website](https://www.featbit.co/) and [Github Repo](https://github.com/featbit/featbit).

![Deploy to Azure](featbit-azure-container-apps.drawio.png)

As shown in the figure above, FeatBit's services are deployed as Azure Container Apps (ACA) in Azure. Such as FeatBit's UI portal, FeatBit's API server, FeatBit's evaluation server, FeatBit's DA server. Evaluation service and API service communicate with DA service inside ACA.

> Note: ACA is actually a managed Kubernetes cluster. You can find more information about ACA in [Azure Container Apps official document](https://docs.microsoft.com/en-us/azure/container-apps/). 

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

To change cpu, memory, number of replicas of each container app, you currently have to edit directly in the `main.tf` file in the `terraform/aca` directory. We will add these variables in the future to make installation easier.

## Initialize MongoDB database

After the deployment is finished, you need to initialize database with some data. You can do this by running the following queries:

```bash
const dbName = "featbit";
print('use', dbName, 'database')
db = db.getSiblingDB(dbName)

print('seed started...')

// seed ids
const userId = UUID()
const organizationId = UUID()

// built-in policies
// see also: modules/back-end/src/Domain/Policies/BuiltInPolicy.cs
const ownerPolicyId = UUID("98881f6a-5c6c-4277-bcf7-fda94c538785")
const administratorPolicyId = UUID("3e961f0f-6fd4-4cf4-910f-52d356f8cc08")
const developerPolicyId = UUID("66f3687f-939d-4257-bd3f-c3553d39e1b6")

function getUUIDString() {
    return UUID().toString().split('"')[1];
}

// seed user
print('clean and seed collection: Users')
db.Users.deleteMany({})
db.Users.insertOne(
    {
        _id: userId,
        email: "test@featbit.com",
        password: "AQAAAAEAACcQAAAAELDHEjCrDQrmnAXU5C//mOLvUBJ7lnVFEMMFxNMDIIrF7xK8JDQKUifU3HH4gexNAQ==",
        name: "tester",
        createAt: new Date(),
        updatedAt: new Date()
    }
)
print('collection seeded: Users')

// seed organization
print('clean and seed collection: Organizations')
db.Organizations.deleteMany({})
db.Organizations.insertOne(
    {
        _id: organizationId,
        name: "playground",
        initialized: false,
        createdAt: new Date(),
        updatedAt: new Date()
    }
)
print('collection seeded: Organizations')

// seed organization users
print('clean and seed collection: OrganizationUsers')
db.OrganizationUsers.deleteMany({})
db.OrganizationUsers.insertOne(
    {
        _id: UUID(),
        organizationId: organizationId,
        userId: userId,
        invitorId: null,
        initialPassword: "",
        createdAt: new Date(),
        updatedAt: new Date()
    }
)
print('collection seeded: OrganizationUsers')

// seed system managed policies
print('clean and seed collection: Policies')
db.Policies.deleteMany({})
db.Policies.insertOne(
    {
        _id: ownerPolicyId,
        organizationId: null,
        name: "Owner",
        description: "Contains all permissions. This policy is granted to the user who created the organization",
        type: "SysManaged",
        statements: [
            {
                _id: getUUIDString(),
                resourceType: "*",
                effect: "allow",
                actions: ["*"],
                resources: ["*"]
            }
        ],
        createdAt: new Date(),
        updatedAt: new Date()
    }
)
db.Policies.insertOne(
    {
        _id: administratorPolicyId,
        organizationId: null,
        name: "Administrator",
        description: "Contains all the permissions required by an administrator",
        type: "SysManaged",
        statements: [
            {
                _id: getUUIDString(),
                resourceType: "account",
                effect: "allow",
                actions: ["UpdateOrgName"],
                resources: ["account/*"]
            },
            {
                _id: getUUIDString(),
                resourceType: "iam",
                effect: "allow",
                actions: ["CanManageIAM"],
                resources: ["iam/*"]
            },
            {
                _id: getUUIDString(),
                resourceType: "access-token",
                effect: "allow",
                actions: [
                    "ManageServiceAccessTokens",
                    "ManagePersonalAccessTokens",
                    "ListAccessTokens"
                ],
                resources: ["access-token/*"]
            },
            {
                _id: getUUIDString(),
                resourceType: "relay-proxy",
                effect: "allow",
                actions: [
                    "ManageRelayProxies",
                    "ListRelayProxies"
                ],
                resources: ["relay-proxy/*"]
            },
            {
                _id: getUUIDString(),
                resourceType: "project",
                effect: "allow",
                actions: [
                    "CanAccessProject",
                    "CreateProject",
                    "DeleteProject",
                    "UpdateProjectSettings",
                    "CreateEnv"
                ],
                resources: ["project/*"]
            },
            {
                _id: getUUIDString(),
                resourceType: "env",
                effect: "allow",
                actions: [
                    "DeleteEnv",
                    "UpdateEnvSettings",
                    "CreateEnvSecret",
                    "DeleteEnvSecret",
                    "UpdateEnvSecret"
                ],
                resources: ["project/*:env/*"]
            }
        ],
        createdAt: new Date(),
        updatedAt: new Date()
    }
)
db.Policies.insertOne(
    {
        _id: developerPolicyId,
        organizationId: null,
        name: "Developer",
        description: "Contains all the permissions required by a developer",
        type: "SysManaged",
        statements: [
            {
                _id: getUUIDString(),
                resourceType: "access-token",
                effect: "allow",
                actions: [
                    "ManageServiceAccessTokens",
                    "ManagePersonalAccessTokens",
                    "ListAccessTokens"
                ],
                resources: ["access-token/*"]
            },
            {
                _id: getUUIDString(),
                resourceType: "relay-proxy",
                effect: "allow",
                actions: [
                    "ManageRelayProxies",
                    "ListRelayProxies"
                ],
                resources: ["relay-proxy/*"]
            },
            {
                _id: getUUIDString(),
                resourceType: "project",
                effect: "allow",
                actions: [
                    "CanAccessProject"
                ],
                resources: ["project/*"]
            }
        ],
        createdAt: new Date(),
        updatedAt: new Date()
    }
)
print('collection seeded: Policies')

// seed member policy
print('clean and seed collection: MemberPolicies')
db.MemberPolicies.deleteMany({})
db.MemberPolicies.insertOne(
    {
        _id: UUID(),
        organizationId: organizationId,
        policyId: ownerPolicyId,
        memberId: userId,
        createdAt: new Date(),
        updatedAt: new Date()
    }
)
print('collection seeded: MemberPolicies')


const createdAtCollections = ["RelayProxies", "Projects", "AccessTokens", "Policies", "AuditLogs"];
createdAtCollections.forEach(collection => {
    db.getCollection(collection).createIndex(
        { "createdAt": -1 },
        { background: true }
    );
});
const updatedAtCollections = ["EndUsers", "FeatureFlags", "Segments"]
updatedAtCollections.forEach(collection => {
    db.getCollection(collection).createIndex(
        { "updatedAt": -1 },
        { background: true }
    );
});

```

## Run FeatBit

Once all services have started, you can access FeatBit's portal with public URL generated by ACA and log in with the default credentials:

- Username: test@featbit.com
- Password: 123456

## Important Notes

The Terraform code is actually only for the FeatBit Standard version. [Click here to see the difference between Standard and Pro version](https://docs.featbit.co/docs/tech-stack/standard-vs.-professional)

For Pro version, high availability solutions, or any other questions, you can contact us by creating an issue, joining our [Slack channel](https://join.slack.com/t/featbit/shared_invite/zt-1ew5e2vbb-x6Apan1xZOaYMnFzqZkGNQ), or emailing us at [support@featbit.co](mailto:support@featbit.co).
