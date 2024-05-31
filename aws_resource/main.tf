
module "opensearch" {
  source  = "./module/"
  for_each            = local.cluster_params

  cluster_name        = each.key
  engine_version      = each.value["engine_version"]
  master_node_type    = each.value["master_node_type"]
  master_node_number  = each.value["master_node_number"]
  data_node_type      = each.value["data_node_type"]
  data_node_number    = each.value["data_node_number"]
}
