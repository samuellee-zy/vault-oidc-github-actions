# Create the necessary GitHub secrets
data "github_repository" "repo" {
  full_name = "${var.github_organization}/${var.github_repository}"
}

resource "github_actions_secret" "secrets" {
  for_each = {
    "VAULT_ADDR"        = var.vault_server_url
    "VAULT_NAMESPACE"   = "admin"
    "VAULT_SECRET_PATH" = vault_kv_secret_v2.tfc.path
    "VAULT_SECRET_KEY"  = "apiToken"
    "VAULT_ROLE"        = vault_jwt_auth_backend_role.example.role_name
    "GITHUB_TOKEN"      = var.github_token
  }
  secret_name     = each.key
  plaintext_value = each.value
  repository      = var.github_repository
}