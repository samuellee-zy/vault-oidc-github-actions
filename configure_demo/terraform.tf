terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~>4.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  cloud {
    organization = "samuellee-dev"
    workspaces {
      project = "AWS"
      name = "vault-oidc-github-action"
    }
  }
}

provider "github" {
  token = var.github_token
}

provider "vault" {
  address = var.vault_server_url
}