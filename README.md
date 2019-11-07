# Eclipse ioFog Platform

The Eclipse ioFog Platform project provides means to spin up and deploy minimal infrastructure. Currently, we demonstrate how to achieve this on GKE (Google Kubernetes Engine), although since we are using 
[Terraform](https://www.terraform.io/) under the covers you can easily extend/contribute to support your preferred 
cloud infrastructure provider.

## Required Tools

In order to setup the infrastructure we will need the following tools:

- [Terraform](https://www.terraform.io/) (version 0.12.\*, [installation instructions](https://learn.hashicorp.com/terraform/getting-started/install.html))
- GCloud SDK ([quickstart guide](https://cloud.google.com/sdk/docs/quickstarts))
- Kubectl ([installation instructions](https://kubernetes.io/docs/tasks/tools/install-kubectl/))

To then install a complete EdgeCompute Network (ECN), we will also need `iofogctl`: 

- [iofogctl](https://github.com/eclipse-iofog/iofogctl) ([installation instructions](../getting-started/quick-start.html))

We don't have to install these tools manually now. Later in the process, we will use a script to download those dependencies and initialise terraform variable file.

Provided script `./bootstrap.sh` will download those dependencies, see details below.

## Required Credentials

### GCP Service Account

First, we need to setup gcloud with our project. We can either establish a service account or use a personal account with GCP. In both cases, the minimal set of IAM roles required is:

- Compute Admin
- Kubernetes Engine Admin
- Service Account User

To login with a service account and setup our project, download the service account key file from GCP. Further details on how to setup a service account are available in the [GCP documentation](https://cloud.google.com/video-intelligence/docs/common/auth#set_up_a_service_account).

You can test authenticate gcloud with the newly created service account.

```bash
gcloud auth activate-service-account --key-file=service-account-key.json
```

If you no longer have the service account key file, it is possible to [generate another key using gcloud](https://cloud.google.com/sdk/gcloud/reference/iam/service-accounts/keys/create) or using the GCP console.

### Packet API Token

The platform tools also supports deployment of agent nodes on [packet](https://www.packet.com/). This step is entirely optional and is it possible to provide our own machines for ioFog Agents instead.

We will need Packet token to setup packet provider on terraform. First we have to [upload out ssh key](https://support.packet.com/kb/articles/ssh-access) that will be used by automation to add to newly created instances.

Next, retrieve a Packet [auth token](https://support.packet.com/kb/articles/api-integrations) and project ID from Packet website and save it for later.

## Usage

### Bootstrap Platform Tools

We can then run bootstrap to install all the required tools. It is possible to skip the installation step if we opt to instead provide the tools ourselves, please consult `./bootsrap.sh --help` for details.

```bash
./bootstrap.sh --gcloud-service-account service-account-key.json
```

### Modify Configuration File

First create a copy of the variables template file.

```bash
cp infrastructure/gcp/template.tfvars user.tfvars
```

Now we have to edit the `user.tfvars` file according to our credentials and desired infrastructure. There are three main sections in the file: general variables, agents list and packet variables. Let's start by modifying the following general variables:

| Variables                        | Description                                                  |
| -------------------------------- |:------------------------------------------------------------:|
| `google_application_credentials` | Path to the service account key file from [Google Cloud Platform Setup](#google-cloud-platform-setup) |             
| `gcp_service_account`            | Name of the GCP service account |
| `project_id`                     | GCP project ID |
| `environment`                    | Name of the infrastructure (to identify the resources on GCP and Packet) |   
| `gcp_region`                     | Region if GCP infrastructure |
| `packet_auth_token`              | Packet API key from [Packet Setup (Optional)](#packet-setup-optional) (Optional) |       
| `packet_project_id`              | Packet project ID (Optional) |
| `packet_operating_system`        | Packet operating system of all agents (Optional) |       
| `packet_facility`                | Packet regions (called facilities) (Optional) |       
| `packet_count_x86`               | Packet number of x86 instances (Optional) |
| `packet_plan_x86`                | Packet plan of x86 instances (Optional) |   
| `packet_count_arm`               | Packet number of arm instances (Optional) |       
| `packet_plan_arm`                | Packet plan of arm instances (Optional) |   


### Deploy and Destroy Infrastructure

To deploy the new infrastructure, run:

```bash
./deploy.sh user.tfvars
```

### Interact With Newly Deployed Infrastructure

Once the infrastructure is successfully deployed, we should be able to interact with the Kubernetes cluster. Terraform automatically setup our [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) for us. To use the newly created Kubernetes cluster, we need to define `KUBECONFIG` environment variable to point to a kubeconfig file created by Terraform. The kubeconfig file is always in `infrastructure/gcp/<environment>.kubeconfig`, where `<environemnt>` corresponds to the settings passed in our `user.tfvars` file.

```bash
export KUBECONFIG="$PWD/infrastructure/gcp/<environment>.kubeconfig"
```

Should we need to retrieve kubeconfig for our new cluster anytime in the future or from another machine, we can use `gcloud container clusters get-credentials environment --region gcp_region`, where `environment` and `gcp_region` refer to previously described variables.

Terraform generated `ecn.yaml` file according to [iofogctl specification](../tools/iofogctl/stack-yaml-spec.md). Most important are `kubeconfig` and `keyfile` parameters. The `kubeconfig` variable is the same as in [Interact With Newly Deployed Infrastructure](#interact-with-newly-deployed-infrastructure). `keyfile` refers to a private SSH key to access the given agent. For Packet agents, these must be uploaded to Packet according to [Packet Setup (Optional)](#packet-setup-optional). This is also where we can add additional agents (outside of the new infrastructure). 

### Destroy Infrastructure

To destroy the infrastructure (and all deployed ECNs), run:

```bash
./destroy.sh user.tfvars
```

Make sure the `tfvars` file is the same for both deploy and destroy invocations.

## Helpful Commands

- Login to gcloud: `gcloud auth login`

- Kubeconfig for gke cluster: `gcloud container clusters get-credentials <<CLUSTER_NAME>> --region <<REGION>>`

- Delete a particular terraform resource: `terraform destroy -target=null_resource.iofog -var-file=vars.tfvars -auto-approve`

- Terraform Output `terraform output ` or `terraform output -module=packet_edge_nodes`