resource "elasticsearch_ingest_pipeline" "ingest_pipeline" {
  for_each = local.ingest_pipelines

  name = each.key
  body = jsonencode(each.value)
}