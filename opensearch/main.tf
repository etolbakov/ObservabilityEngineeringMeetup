
module "opensearch_resources" {
  source = "./module"

  index_pattern_files   = fileset(path.module, "../cluster-x-config/index-patterns/*.yml.tftpl")
  index_template_files  = fileset(path.module, "../cluster-x-config/index-templates/*.yml.tftpl")
  ism_policy_files      = fileset(path.module, "../cluster-x-config/ism-policies/*.yml.tftpl")
  ingest_pipeline_files = fileset(path.module, "../cluster-x-config/ingest-pipelines/*.yml.tftpl")
  role_files            = fileset(path.module, "../cluster-x-config/roles/*.yml.tftpl")
  role_mapping_files    = fileset(path.module, "../cluster-x-config/role-mappings/*.yml.tftpl")
}