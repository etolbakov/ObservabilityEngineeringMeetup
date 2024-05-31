locals {
  index_templates = merge({
    for filename in var.index_template_files :
    replace(basename(filename), "/\\.yaml.tftpl$/", "") => yamldecode(file(filename))
  }, var.index_templates)

  index_patterns = merge({
    for filename in var.index_patterns_files :
    replace(basename(filename), "/\\.yaml.tftpl$/", "") => yamldecode(file(filename))
  }, var.index_patterns)

  ism_policies = merge({
    for filename in var.ism_policy_files :
    replace(basename(filename), "/\\.yaml.tftpl$/", "") => yamldecode(file(filename))
  }, var.ism_policies)

  ingest_pipelines = merge({
    for filename in var.ingest_pipelines :
    replace(basename(filename), "/\\.yaml.tftpl$/", "") => yamldecode(file(filename))
  }, var.ingest_pipelines)

  roles = merge({
    for filename in var.role_files :
    replace(basename(filename), "/\\.yaml.tftpl$/", "") => yamldecode(file(filename))
  }, var.roles)

  role_mappings = merge({
    for filename in var.role_mapping_files :
    replace(basename(filename), "/\\.yaml.tftpl$/", "") => yamldecode(file(filename))
  }, var.role_mappings)
}