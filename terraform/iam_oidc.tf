resource "aws_iam_openid_connect_provider" "github-actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  # GitHub Actions の OIDC 固有値（固定）
  thumbprint_list = [
    "2b18947a6a9fc7764fd8b5fb18a863b0c6dac24f"
  ]
}
