
# Azure Infra with Terragrunt & Terraform

## Overview
This repository manages Azure infrastructure using Terragrunt and Terraform, supporting multiple environments (dev, prod) with reusable modules and safe, DRY configuration.

---

## Folder Structure

```
root.hcl
env/
  dev/
    env.hcl
    rg/
      terragrunt.hcl
    storage/
      terragrunt.hcl
    network/
      terragrunt.hcl
  prod/
    env.hcl
    rg/
      terragrunt.hcl
    storage/
      terragrunt.hcl
modules/
  resource-group/
    main.tf
    outputs.tf
    variables.tf
  storage-account/
    main.tf
    outputs.tf
    variables.tf
  networking/
    main.tf
    outputs.tf
    variables.tf
```

---

## How It Works

### 1. root.hcl
- Defines global settings (remote state, provider, and how to load environment config).
- Loads the correct `env.hcl` for the current environment using `read_terragrunt_config(find_in_parent_folders("env.hcl"))`.
- All modules inherit these settings by including `root.hcl`.

### 2. env/{dev,prod}/env.hcl
- Contains environment-specific variables: `env_name`, `location`, `subscription_id`, tags, networking, and storage settings.
- Example:
  ```hcl
  locals {
    env_name        = "dev"
    location        = "eastus"
    subscription_id = "..."
    tags = {
      Environment = local.env_name
      Project     = "MyProject"
      Owner       = "DevOpsTeam"
    }
    vnet_name       = "vnet-${local.env_name}"
    subnet_name     = "subnet-${local.env_name}"
    address_space   = ["10.0.0.0/16"]
    subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24"]
    storage_sku     = "Standard_LRS"
  }
  ```

### 3. env/{env}/{module}/terragrunt.hcl
- Each module (resource group, storage, network) includes `root.hcl` and loads its environment's `env.hcl`.
- Inputs for the module are set using values from the loaded `env.hcl`.
- For complex types (lists/maps), use `jsonencode` in Terragrunt and `jsondecode` in Terraform:
  ```hcl
  inputs = {
    vnet_name           = local.env.locals.vnet_name
    subnet_name         = local.env.locals.subnet_name
    address_space       = jsonencode(local.env.locals.address_space)
    subnet_prefixes     = jsonencode(local.env.locals.subnet_prefixes)
    resource_group_name = dependency.rg.outputs.name
    location            = local.env.locals.location
    tags                = jsonencode(local.env.locals.tags)
  }
  ```

### 4. modules/
- Contains reusable Terraform modules for resources (resource group, storage account, networking, etc).
- Example for networking:
  ```hcl
  resource "azurerm_virtual_network" "vnet" {
    name                = var.vnet_name
    resource_group_name = var.resource_group_name
    location            = var.location
    address_space       = jsondecode(var.address_space)
    tags                = jsondecode(var.tags)
  }

  resource "azurerm_subnet" "subnets" {
    for_each             = { for i, prefix in jsondecode(var.subnet_prefixes) : i => prefix }
    name                 = "${var.subnet_name}-${each.key}"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [each.value]
  }
  ```

---

## Handling Complex Types (jsonencode/jsondecode)
- When passing lists or maps from Terragrunt to Terraform, always use `jsonencode` in Terragrunt and `jsondecode` in Terraform.
- This ensures the correct type is received by Terraform, avoiding type errors.

---

## Adding/Changing Parameters or Environments
- To add/change parameters for an environment, edit the relevant `env/{dev,prod}/env.hcl` file.
- To add a new environment (e.g., staging), copy the folder structure and create a new `env.hcl`.
- To add a new module, create a new folder in `modules/` and a corresponding Terragrunt config in each environment.

---

## Typical Workflow
1. Edit `env/dev/env.hcl` or `env/prod/env.hcl` to set environment-specific values.
2. Add or update modules in `modules/` as needed.
3. Run Terragrunt commands from the desired environment folder (e.g., `env/dev` or `env/prod`).
   - Example: `terragrunt run-all apply` from `env/dev`.

---

## Best Practices & Tips
- Always review changes in dev before applying to prod.
- Use Terragrunt's `dependency` block for cross-module dependencies (e.g., storage depends on resource group).
- Use `mock_outputs` in dependencies for init/planning phases.
- Use `jsonencode`/`jsondecode` for all complex types (lists/maps) in Terragrunt inputs and Terraform modules.
- Keep modules generic and reusable.
- Separate state files by environment for safety.

---

## Troubleshooting
- **Type errors (string vs list/map):** Use `jsonencode` in Terragrunt and `jsondecode` in Terraform.
- **Missing outputs in dependencies:** Ensure the dependency module is applied or use `mock_outputs`.
- **Environment-specific values not picked up:** Check that you are running Terragrunt from the correct environment folder and that `find_in_parent_folders("env.hcl")` resolves to the right file.


## C:\Users\Illuru Yadhu Vamsi\Documents\Infra\.github\workflows\terragrunt.yml
--terragrunt-non-interactive → no interactive prompts from Terragrunt itself.
-auto-approve → automatically approves Terraform changes.

strategy:
  matrix:
    app:
      - app1
      - app2
What happens here:
GitHub creates 2 parallel executions of the same job:
One for app1
One for app2

Internally:
nginx
Copy code
Job 1 → matrix.app = app1
Job 2 → matrix.app = app2






outputs:
  matrix: ${{ steps.set-matrix.outputs.matrix }}
🔹 This job will produce one output called matrix
🔹 That output will look like:
{"app":["app1"]} or {"app":["app1","app2"]} or {"app":[]}

This output is used by the next job to decide what to deploy.

## SHA in Git usually means: A unique ID that Git gives to every commit

if [ "${{ github.event_name }}" = "workflow_dispatch" ]; then
What this means
${{ github.event_name }} is replaced before execution

Bash sees something like:

bash
Copy code
if [ "workflow_dispatch" = "workflow_dispatch" ]; then

or
bash
Copy code
if [ "push" = "workflow_dispatch" ]; then
Example:
Trigger	                  Value
Manual click	            workflow_dispatch
Git push	                push

## This bash script compares two commit SHAs, checks which app folders changed, builds a JSON matrix accordingly, and outputs it for the next job to use.






If you trigger manually (from GitHub UI):
→ It says: “Run all apps and environments.”

If this is the first commit (no previous commit to compare):
→ It also says: “Run all apps and environments.”

Otherwise, check what files changed:
Example: You changed app1/dev/main.tf
It sees: app1 in dev changed
It adds {"app":"app1","env":"dev"} to the list.
Only this app/environment will be deployed.


This GitHub Action job helps detect which apps and environments changed and prepares a “list” (called a matrix) for the next job to use.

Step by step
1️⃣ Checkout the code
uses: actions/checkout@v4


This step just grabs your code so the workflow can see what changed.

2️⃣ Install jq
sudo apt-get install -y jq


jq is a tool that makes it easy to work with JSON in scripts.

3️⃣ Detect changes

This is the main part. Think of it like this:

If you trigger manually (from GitHub UI):
→ It says: “Run all apps and environments.”

If this is the first commit (no previous commit to compare):
→ It also says: “Run all apps and environments.”

Otherwise, check what files changed:

Example: You changed app1/dev/main.tf

It sees: app1 in dev changed

It adds {"app":"app1","env":"dev"} to the list.

Only this app/environment will be deployed.

How the matrix looks

After detecting changes, it makes a list like this:

{
  "include": [
    {"app":"app1","env":"dev"},
    {"app":"app2","env":"prod"}
  ]
}


This list is called a matrix.

The next job can use this to only run for app1/dev and app2/prod.

4️⃣ Show the matrix
echo '${{ steps.set-matrix.outputs.matrix }}'


This just prints the matrix for you to see in logs.















