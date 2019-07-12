# Eclipse ioFog Platform

The Eclipse ioFog Platform project provides a means by which to spin up and deploy an Eclipse ioFog stack running
in the Cloud. Currently, we demonstrate how to achieve this on GKE (Google Kubernetes Engine), although since we are using 
[Terraform](https://www.terraform.io/) under the covers you can easily extend/contribute to support your preferred 
cloud infrastructure provider.

# Requirements

* [GCloud SDK](https://cloud.google.com/sdk/) 
* [Terraform](https://www.terraform.io/) (v0.11.x)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [iofogctl](https://github.com/eclipse-iofog/iofogctl)

`./bootstrap.sh` will download those dependencies and initialise terraform variable file `./my_vars.tfvars`.

## Usage

Run `./bootstrap.sh` to ensure all required dependencies are present and initialise terraform variable file `./my_vars.tfvars`.

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
| `google_application_credentials`           | *Path to [gcloud service account json key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)*                         |
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

## Agent list
The variable `agent_list` contains a list of remote hardware on top of which you would like us to deploy an ioFog agent, connect it to the GKE hosted controller, and include it inside our Kubernetes network.
To do so we require the following information (per remote resource):
```
 {
     name = "<AGENT_NAME>", # Name used to register the agent with the controller
     user = "<AGENT_USER>", # User name for ssh connection into the resource
     host = "<AGENT_IP>", # host for ssh connection into the resource
     port = "<SSH_PORT>", # port for ssh connection into the resource
     keyfile = "<PRIVATE_SSH_KEY>" # Absolute path to the private key used to ssh into the resource
 }
```

## Option to deploy agent nodes on [Packet](https://www.packet.com/)
On top of providing a list of existing resources in the `agent_list` variable, we support deployment of agent nodes on [packet](https://www.packet.com/) provided you have an account.
In situations where you do not have your own devices acting as edge nodes, you can sping a few nodes on packet to act as agents. You will need Packet token to setup packet provider on terraform. Also be aware of account limitation for example,unable to spin more than 2 arm nodes per project. 
You will also need to make sure you have [uploaded an ssh key](https://support.packet.com/kb/articles/ssh-access) on your packet project that will be used by automation to add to newly created instances.

Warning: We will look for the `packet_auth_token` variable. If it is defined, we will try to spin up Packet nodes according to the other variables. If it is empty or commented, we will not load anything Packet related.

Additional variables:

| Variables              | Description                                                  |
| -----------------------|:------------------------------------------------------------:|
| `packet_auth_token`    | *packet [auth token](https://support.packet.com/kb/articles/api-integrations)*                 |
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