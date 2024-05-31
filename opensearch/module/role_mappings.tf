resource "elasticsearch_opensearch_roles_mapping" "role_mapping" {
  for_each = {
    for key, value in local.role_mappings :
    key => value if !contains(["all_access", "security_manager"], key)
  }

  role_name     = each.key
  description   = try(each.value.description, "")
  backend_roles = try(each.value.backend_roles, [])
  hosts         = try(each.value.hosts, [])
  users         = try(each.value.users, [])
}