# Eclipse ioFog Platform

The Eclipse ioFog Platform project provides a means by which to spin up and deploy an Eclipse ioFog stack running
in the Cloud. Currently, we demonstrate how to achieve this on GKE (Google Kubernetes Engine), although since we are using 
[Terraform](https://www.terraform.io/) under the covers you can easily extend/contribute to support your preferred 
cloud infrastructure provider.

# Requirements

* [GCloud SDK](https://cloud.google.com/sdk/) 
* [Terraform](https://www.terraform.io/) (v0.11.x)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [iofogctl] (https://github.com/eclipse-iofog/iofogctl)

You can run `./bootstrap.sh` in order to download those dependencies.

You will also require the following environment variables
```sh
  export GOOGLE_APPLICATION_CREDENTIALS=<path-to-json>
  # How to generate a service account json file: https://cloud.google.com/iam/docs/creating-managing-service-account-keys
```
You can edit the file `./my_credentials.sh` to provide your [keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).

## Usage

Run `./bootstrap.sh` to ensure all required dependencies are present and initialise terraform files.

If you didn't have `gcloud` prior to running the bootstrap script, please ensure `gcloud` is in your PATH.
You can do so by running:
```sh
  source /usr/local/lib/google-cloud-sdk/completion.bash.inc
  source /usr/local/lib/google-cloud-sdk/path.bash.inc
```

Edit the file `./my_vars.tfvars` according to the table below.

To deploy your ioFog stack, run `./deploy.sh`
To destroy your ioFog stack, run `./destroy.sh`

| Variables              | Description                                                  |
| -----------------------|:------------------------------------------------------------:|
| `project_id`           | *id of your google platform project*                         |
| `environment`          | *unique name for your environment*                           |
| `gcp_region`           | *region to spin up the resources*                            |
| `controller_image`     | *docker image link for controller setup*                     |
| `connector_image`      | *docker image link for connector setup*                      |
| `scheduler_image`      | *docker image link for scheduler setup*                      |
| `operator_image`       | *docker image link for operator setup*                       |
| `kubelet_image`        | *docker image link for kubelet setup*                        |
| `controller_ip`        | *list of edge ips, comma separated to install agent on*      |
| `iofogUser_name`       | *name for registration with controller*                      |
| `iofogUser_surname`    | *surname for registration with controller*                   |
| `iofogUser_email`      | *email to use to register with controller*                   |
| `iofogUser_password`   | *password(length >=8) for user registeration with controller*|
| `iofogctl_namespace`   | *namespace to be used with iofogctl commands*                |
| `agent_list`           | *list of agents to be deployed*                              |


## Option to deploy agent nodes on [Packet](https://www.packet.com/)
On top of providing a list of existing resources in the `agent_list` variable, we support deployment of agent nodes on [packet](https://www.packet.com/) provided you have an account.
In situations where you do not have your own devices acting as edge nodes, you can sping a few nodes on packet to act as agents. You will need Packet token to setup packet provider on terraform. Also be aware of account limitation for example,unable to spin more than 2 arm nodes per project. 
You will also need to make sure you have [uploaded an ssh key](https://support.packet.com/kb/articles/ssh-access) on your packet project that will be used by automation to add to newly created instances.

You will also require the following environment variables
```sh
  export PACKET_AUTH_TOKEN=<YOUR_PACKET_API_KEY>
  # How to generate: https://support.packet.com/kb/articles/api-integrations
```
You can edit the file `./my_credentials.sh` to provide your [keys](https://support.packet.com/kb/articles/api-integrations).

Warning: We will instruct terraform to load packet agents only if the PACKET_AUTH_TOKEN environment variable is set (or uncommented in `./my_credentials.env`)

Additional variables:

| Variables              | Description                                                  |
| -----------------------|:------------------------------------------------------------:|
| `packet_project_id`    | *packet project id to spin agents on packet*                 |
| `operating_system`     | *operating system for edge nodes on packet*                  |
| `packet_facility`      | *facilities to use to drop agents*                           |
| `count_x86`            | *number of x86(make sure your project plan allow)*           |
| `plan_x86`             | *server plan for device on x86 available on facility chosen* |
| `count_arm`            | *number of arm agents to spin up*                            |
| `plan_arm`             | *server plan for device on arm available on facility chosen* |
| `ssh_key`              | *path to ssh key to be used for accessing packet edge nodes* |

### Helpful Commands

- Login to gcloud: `gcloud auth login`

- Kubeconfig for gke cluster: `gcloud container clusters get-credentials <<CLUSTER_NAME>> --region <<REGION>>`

- Delete a particular terraform resource: `terraform destroy -target=null_resource.iofog -var-file=vars.tfvars -auto-approve`

- Terraform Output `terraform output ` or `terraform output -module=packet_edge_nodes`