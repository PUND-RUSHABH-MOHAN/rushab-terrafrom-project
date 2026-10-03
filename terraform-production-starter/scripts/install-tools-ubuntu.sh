#!/usr/bin/env bash
# Installs the Terraform toolchain on Ubuntu 22.04 / 24.04 (amd64).
# Usage: chmod +x scripts/install-tools-ubuntu.sh && ./scripts/install-tools-ubuntu.sh
set -euo pipefail

TFDOCS_VERSION="v0.19.0"
CONFTEST_VERSION="0.56.0"

echo "==> Base packages"
sudo apt-get update
sudo apt-get install -y curl wget unzip gnupg lsb-release \
  software-properties-common git make jq python3 pipx

echo "==> Terraform (official HashiCorp apt repo)"
wget -O- https://apt.releases.hashicorp.com/gpg \
  | sudo gpg --dearmor --yes \
      -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) \
signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform

echo "==> TFLint"
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh \
  | bash

echo "==> Trivy (security scanner)"
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | sudo gpg --dearmor --yes -o /usr/share/keyrings/trivy.gpg
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb generic main" \
  | sudo tee /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install -y trivy

echo "==> Checkov + pre-commit (via pipx)"
pipx ensurepath
pipx install checkov
pipx install pre-commit

echo "==> terraform-docs"
TFDOCS_URL="https://terraform-docs.io/dl/${TFDOCS_VERSION}"
TFDOCS_FILE="terraform-docs-${TFDOCS_VERSION}-linux-amd64.tar.gz"
curl -sSLo /tmp/terraform-docs.tar.gz "${TFDOCS_URL}/${TFDOCS_FILE}"
tar -xzf /tmp/terraform-docs.tar.gz -C /tmp terraform-docs
sudo install -m 0755 /tmp/terraform-docs /usr/local/bin/terraform-docs

echo "==> Conftest (OPA policy checks)"
CONFTEST_URL="https://github.com/open-policy-agent/conftest/releases/download"
CONFTEST_FILE="conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz"
curl -sSL "${CONFTEST_URL}/v${CONFTEST_VERSION}/${CONFTEST_FILE}" \
  | tar -xz -C /tmp conftest
sudo install -m 0755 /tmp/conftest /usr/local/bin/conftest

echo "==> AWS CLI v2"
if ! command -v aws >/dev/null 2>&1; then
  curl -sSLo /tmp/awscliv2.zip \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
  unzip -q -o /tmp/awscliv2.zip -d /tmp
  sudo /tmp/aws/install
fi

echo "==> Versions"
terraform -version
tflint --version
trivy --version | head -1
terraform-docs --version
conftest --version
aws --version
echo "Open a new shell (or run: source ~/.bashrc) so pipx tools are on PATH."
