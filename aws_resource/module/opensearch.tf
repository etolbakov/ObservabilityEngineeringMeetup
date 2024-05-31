resource "aws_elasticsearch_domain" "opensearch" {
  domain_name           = var.cluster_name
  elasticsearch_version = var.cluster_version
  count                 = var.enabled ? 1 : 0

  cluster_config {
    dedicated_master_enabled = true
    dedicated_master_count   = var.master_instance_count
    dedicated_master_type    = var.master_instance_type

    instance_count = var.hot_instance_count
    instance_type  = var.hot_instance_type

    warm_enabled = var.warm_enabled
    warm_count   = var.warm_enabled ? var.warm_instance_count : null
    warm_type    = var.warm_enabled ? var.warm_instance_type : null

    cold_storage_options {
      enabled = var.cold_enabled
    }

    zone_awareness_enabled = (var.availability_zones > 1) ? true : false

    zone_awareness_config {
      availability_zone_count = var.availability_zones
    }
  }

  log_publishing_options {
    enabled                  = var.cloudwatch_log_enabled
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cw_index.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    enabled                  = var.cloudwatch_log_enabled
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cw_search.arn
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    enabled                  = var.cloudwatch_log_enabled
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cw_application.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  log_publishing_options {
    enabled                  = var.cloudwatch_log_enabled
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cw_audit.arn
    log_type                 = "AUDIT_LOGS"
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = var.internal_user_database_enabled
    master_user_options {
      master_user_arn      = var.internal_user_database_enabled ? var.master_user_arn : null
      master_user_name     = var.internal_user_database_enabled ? var.master_user_name : null
      master_user_password = var.internal_user_database_enabled ? var.master_user_password : null
    }
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest
    kms_key_id = var.encrypt_at_rest ? var.encrypt_kms_key_id : null
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_size = var.ebs_enabled ? var.ebs_volume_size : null
    volume_type = var.ebs_enabled ? var.ebs_volume_type : null
    iops        = var.ebs_enabled ? var.ebs_iops : null
  }

  domain_endpoint_options {
    enforce_https                   = var.enforce_https
    tls_security_policy             = var.tls_security_policy
    custom_endpoint_enabled         = var.custom_endpoint_enabled
    custom_endpoint                 = var.custom_endpoint_enabled ? var.custom_endpoint : null
    custom_endpoint_certificate_arn = var.custom_endpoint_enabled ? var.custom_endpoint_certificate_arn : null
  }

  cognito_options {
    enabled          = var.cognito_enabled
    user_pool_id     = var.cognito_enabled ? var.cognito_user_pool_id : ""
    identity_pool_id = var.cognito_enabled ? var.cognito_identity_pool_id : ""
    role_arn         = var.cognito_enabled ? var.cognito_role_arn : ""
  }

  dynamic "auto_tune_options" {
    for_each = var.autotune_enabled ? [1] : []
    content {
      desired_state       = var.autotune_options.desired_state
      rollback_on_disable = var.autotune_options.rollback_on_disable

      maintenance_schedule {
        start_at = var.autotune_options.maintenance_schedule.start_at
        duration {
          value = var.autotune_options.maintenance_schedule.duration
          unit  = "HOURS"
        }
        cron_expression_for_recurrence = var.autotune_options.maintenance_schedule.cron_expression
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}

resource "aws_elasticsearch_domain_saml_options" "opensearch_saml_options" {
  domain_name = var.cluster_name
  count       = var.saml_options_enabled ? 1 : 0
  saml_options {
    enabled                 = var.saml_options_enabled
    master_backend_role     = var.saml_options_master_backend_role
    master_user_name        = var.saml_options_master_user_name
    roles_key               = var.saml_options_roles_key
    session_timeout_minutes = var.saml_options_session_timeout_minutes
    subject_key             = var.saml_options_subject_key
    idp {
      entity_id        = var.saml_options_idp_entity_id
      metadata_content = var.saml_options_idp_metadata_content
    }
  }


  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_opensearch_domain_policy" "default" {
  count           = local.opensearch_enabled && (length(var.iam_authorizing_role_arns) > 0 || length(var.iam_role_arns) > 0) ? 1 : 0
  domain_name     = module.this.id
  access_policies = join("", data.aws_iam_policy_document.default[*].json)

  lifecycle {
    prevent_destroy = true
  }
}