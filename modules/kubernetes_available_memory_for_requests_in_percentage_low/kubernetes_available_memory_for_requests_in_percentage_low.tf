resource "shoreline_notebook" "kubernetes_available_memory_for_requests_in_percentage_low" {
  name       = "kubernetes_available_memory_for_requests_in_percentage_low"
  data       = file("${path.module}/data/kubernetes_available_memory_for_requests_in_percentage_low.json")
  depends_on = [shoreline_action.invoke_update_memory_requests,shoreline_action.invoke_update_nodegroup_config_nodepool_scale_cluster_resize]
}

resource "shoreline_file" "update_memory_requests" {
  name             = "update_memory_requests"
  input_file       = "${path.module}/data/update_memory_requests.sh"
  md5              = filemd5("${path.module}/data/update_memory_requests.sh")
  description      = "Optimize memory usage of applications running on the cluster by tuning their memory requests and limits."
  destination_path = "/agent/scripts/update_memory_requests.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_nodegroup_config_nodepool_scale_cluster_resize" {
  name             = "update_nodegroup_config_nodepool_scale_cluster_resize"
  input_file       = "${path.module}/data/update_nodegroup_config_nodepool_scale_cluster_resize.sh"
  md5              = filemd5("${path.module}/data/update_nodegroup_config_nodepool_scale_cluster_resize.sh")
  description      = "Increase available memory on the Kubernetes cluster by adding more nodes or increasing the memory allocated to existing nodes."
  destination_path = "/agent/scripts/update_nodegroup_config_nodepool_scale_cluster_resize.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_memory_requests" {
  name        = "invoke_update_memory_requests"
  description = "Optimize memory usage of applications running on the cluster by tuning their memory requests and limits."
  command     = "`chmod +x /agent/scripts/update_memory_requests.sh && /agent/scripts/update_memory_requests.sh`"
  params      = ["DEPLOYMENT","NAMESPACE"]
  file_deps   = ["update_memory_requests"]
  enabled     = true
  depends_on  = [shoreline_file.update_memory_requests]
}

resource "shoreline_action" "invoke_update_nodegroup_config_nodepool_scale_cluster_resize" {
  name        = "invoke_update_nodegroup_config_nodepool_scale_cluster_resize"
  description = "Increase available memory on the Kubernetes cluster by adding more nodes or increasing the memory allocated to existing nodes."
  command     = "`chmod +x /agent/scripts/update_nodegroup_config_nodepool_scale_cluster_resize.sh && /agent/scripts/update_nodegroup_config_nodepool_scale_cluster_resize.sh`"
  params      = []
  file_deps   = ["update_nodegroup_config_nodepool_scale_cluster_resize"]
  enabled     = true
  depends_on  = [shoreline_file.update_nodegroup_config_nodepool_scale_cluster_resize]
}

