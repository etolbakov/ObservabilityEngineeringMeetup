provider "elasticsearch" {
  url                   = local.cluster_endpoint
  kibana_url            = "${local.cluster_endpoint}/_dashboards"
  elasticsearch_version = "OpenSearch_2.11"
}

provider "elasticsearch" {
  alias                 = "audit_config"
  url                   = local.cluster_endpoint
  kibana_url            = "${local.cluster_endpoint}/_dashboards"
  elasticsearch_version = "8.5"
}