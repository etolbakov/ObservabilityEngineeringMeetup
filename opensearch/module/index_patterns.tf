resource "elasticsearch_kibana_object" "index_pattern" {
  for_each = local.index_patterns
  index    = ".kibana"
  body     = jsonencode(each.value)
}