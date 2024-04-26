resource "tfe_team" "cicd-user" {
    name = "CICD"
    organization = var.tfc_org_name
    organization_access {
        manage_policies = true
        manage_policy_overrides = true
        manage_workspaces = true
        manage_vcs_settings = true
        manage_providers = true
        manage_modules = true
        manage_run_tasks = true
        manage_projects = true
    }
}

resource "time_rotating" "example" {
  rotation_days = 30
}

resource "tfe_team_token" "cicd-user" {
    team_id = tfe_team.cicd-user.id
    expired_at = time_rotating.example.rotation_rfc3339
}