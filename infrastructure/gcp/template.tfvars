# Cloud provider
# How to generate a gcloud service account json file: https://cloud.google.com/iam/docs/creating-managing-service-account-keys
google_application_credentials = "<path-to-google-service-account-json>"

# Dev variables
project_id          = "<your-gcp-project-id>"
environment         = "<your-environment-name>" # Pick any name you like. Can only contain lowercase letters, numbers and hyphens and must start with a letter.
gcp_region          = "us-west2"
gcp_service_account = "<gcp-service-account-name>" # Something in the vein of <service-name>@<project-id>.iam.gserviceaccount.com

# Packet sample config used to setup and arm or x86 edge nodes to your controller
packet_auth_token       = "<your-packet-auth-token>" # How to generate: https://support.packet.com/kb/articles/api-integrations
packet_project_id       = "<your-packet-project-id>"
packet_operating_system = "ubuntu_16_04"
packet_facility         = ["sjc1", "ewr1"]
packet_count_x86        = "1"
packet_plan_x86         = "c1.small.x86"
packet_count_arm        = "0"
packet_plan_arm         = "c2.large.arm"
