

# Create a KV secrets engine
resource "vault_mount" "tfc" {
  path        = "tfc"
  type        = "kv"
  options     = { version = "2" }
  description = "KV mount for OIDC demo with TFC"
}

# Create a secret in the KV engine

resource "vault_kv_secret_v2" "tfc" {
  mount = vault_mount.tfc.path
  name  = "api-token"
  data_json = jsonencode(
    {
      apiToken = "${tfe_team_token.cicd-user.token}"
    }
  )
}

# Create a policy granting the GitHub repo access to the KV engine
resource "vault_policy" "tfc" {
  name = "github-actions-oidc"

  policy = <<EOT
path "${vault_kv_secret_v2.tfc.path}" {
  capabilities = ["list","read"]
}
EOT
}

# Create the JWT auth method to use GitHub
resource "vault_jwt_auth_backend" "jwt" {
  description        = "JWT Backend for GitHub Actions"
  path               = "jwt"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
}

# Create the JWT role tied to the repo
resource "vault_jwt_auth_backend_role" "example" {
  backend           = vault_jwt_auth_backend.jwt.path
  role_name         = "github-actions-role"
  token_policies    = [vault_policy.tfc.name]
  token_max_ttl     = "3600"
  bound_audiences   = ["https://github.com/${var.github_organization}"]
  bound_claims_type = "glob"
  bound_subject     = "repo:${var.github_organization}/*"
  user_claim        = "actor"
  role_type         = "jwt"
}