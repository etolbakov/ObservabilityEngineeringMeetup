locals {
  cluster_params = {
    cluster-x = {
      engine_version       = "OpenSearch_2.13"
      master_node_type     = "m6g.large.search"
      master_node_number   = 3
      data_node_type       = "r6g.2xlarge.search"
      data_node_number     = 3
    }
  }
}