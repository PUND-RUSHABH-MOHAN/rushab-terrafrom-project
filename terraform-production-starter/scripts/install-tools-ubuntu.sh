#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Terraform / DevOps Toolchain Installer
# Target: Ubuntu Linux x86_64 / amd64
# ============================================================

# Versions
TFLINT_VERSION="0.64.0"
TRIVY_VERSION=""                 # Empty = latest from repository
CHECKOV_VERSION=""               # Empty = latest
TFDOCS_VERSION="v0.19.0"
CONFTEST_VERSION="0.56.0"

# ------------------------------------------------------------
# Colors
# ------------------------------------------------------------

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ------------------------------------------------------------
# Check OS / Architecture
# ------------------------------------------------------------

if [[ "$(uname -s)" != "Linux" ]]; then
    error "This script is intended for Linux."
    exit 1
fi

ARCH="$(uname -m)"

if [[ "$ARCH" != "x86_64" ]]; then
    error "This script currently supports x86_64/amd64 only."
    error "Detected architecture: $ARCH"
    exit 1
fi

log "Detected Linux x86_64"

# ------------------------------------------------------------
# Install basic dependencies
# ------------------------------------------------------------

log "Installing required system packages..."

sudo apt-get update

sudo apt-get install -y \
    curl \
    wget \
    unzip \
    tar \
    gnupg \
    software-properties-common \
    pipx

# ------------------------------------------------------------
# Terraform
# ------------------------------------------------------------

if command -v terraform >/dev/null 2>&1; then
    log "Terraform already installed: $(terraform version | head -n 1)"
else
    log "Installing Terraform..."

    sudo install -m 0755 -d /etc/apt/keyrings

    wget -O- https://apt.releases.hashicorp.com/gpg \
        | sudo gpg --dearmor \
        -o /etc/apt/keyrings/hashicorp-archive-keyring.gpg

    echo \
      "deb [signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] \
      https://apt.releases.hashicorp.com \
      $(. /etc/os-release && echo "$VERSION_CODENAME") main" \
      | sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt-get update
    sudo apt-get install -y terraform
fi

# ------------------------------------------------------------
# TFLint
# ------------------------------------------------------------

if command -v tflint >/dev/null 2>&1; then
    log "TFLint already installed: $(tflint --version | head -n 1)"
else
    log "Installing TFLint ${TFLINT_VERSION}..."

    TMP_DIR="$(mktemp -d)"

    curl -fsSL \
      "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" \
      -o "${TMP_DIR}/tflint.zip"

    unzip -q "${TMP_DIR}/tflint.zip" -d "${TMP_DIR}"

    sudo install -m 0755 \
      "${TMP_DIR}/tflint" \
      /usr/local/bin/tflint

    rm -rf "${TMP_DIR}"
fi

# ------------------------------------------------------------
# Trivy
# ------------------------------------------------------------

if command -v trivy >/dev/null 2>&1; then
    log "Trivy already installed: $(trivy --version | head -n 1)"
else
    log "Installing Trivy..."

    wget -qO - \
      https://aquasecurity.github.io/trivy-repo/deb/public.key \
      | sudo gpg --dearmor --yes \
      -o /usr/share/keyrings/trivy.gpg

    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
      | sudo tee /etc/apt/sources.list.d/trivy.list

    sudo apt-get update
    sudo apt-get install -y trivy
fi

# ------------------------------------------------------------
# Checkov
# ------------------------------------------------------------

export PATH="$HOME/.local/bin:$PATH"

if command -v checkov >/dev/null 2>&1; then
    log "Checkov already installed: $(checkov --version)"
else
    log "Installing Checkov..."

    pipx ensurepath >/dev/null 2>&1 || true

    pipx install checkov
fi

# ------------------------------------------------------------
# pre-commit
# ------------------------------------------------------------

if command -v pre-commit >/dev/null 2>&1; then
    log "pre-commit already installed: $(pre-commit --version)"
else
    log "Installing pre-commit..."

    pipx ensurepath >/dev/null 2>&1 || true

    pipx install pre-commit
fi

# ------------------------------------------------------------
# terraform-docs
# ------------------------------------------------------------

if command -v terraform-docs >/dev/null 2>&1; then
    log "terraform-docs already installed: $(terraform-docs --version)"
else
    log "Installing terraform-docs ${TFDOCS_VERSION}..."

    TMP_DIR="$(mktemp -d)"

    TFDOCS_FILE="terraform-docs-${TFDOCS_VERSION}-linux-amd64.tar.gz"

    curl -fsSL \
      "https://terraform-docs.io/dl/${TFDOCS_VERSION}/${TFDOCS_FILE}" \
      -o "${TMP_DIR}/terraform-docs.tar.gz"

    tar -xzf "${TMP_DIR}/terraform-docs.tar.gz" \
      -C "${TMP_DIR}" \
      terraform-docs

    sudo install -m 0755 \
      "${TMP_DIR}/terraform-docs" \
      /usr/local/bin/terraform-docs

    rm -rf "${TMP_DIR}"
fi

# ------------------------------------------------------------
# Conftest
# ------------------------------------------------------------

if command -v conftest >/dev/null 2>&1; then
    log "Conftest already installed: $(conftest --version | head -n 1)"
else
    log "Installing Conftest ${CONFTEST_VERSION}..."

    TMP_DIR="$(mktemp -d)"

    curl -fsSL \
      "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" \
      | tar -xz -C "${TMP_DIR}" conftest

    sudo install -m 0755 \
      "${TMP_DIR}/conftest" \
      /usr/local/bin/conftest

    rm -rf "${TMP_DIR}"
fi

# ------------------------------------------------------------
# AWS CLI v2
# ------------------------------------------------------------

if command -v aws >/dev/null 2>&1; then
    log "AWS CLI already installed: $(aws --version)"
else
    log "Installing AWS CLI v2..."

    TMP_DIR="$(mktemp -d)"

    curl -fsSL \
      https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
      -o "${TMP_DIR}/awscliv2.zip"

    unzip -q \
      "${TMP_DIR}/awscliv2.zip" \
      -d "${TMP_DIR}"

    sudo "${TMP_DIR}/aws/install"

    rm -rf "${TMP_DIR}"
fi

# ------------------------------------------------------------
# GitHub CLI
# ------------------------------------------------------------

if command -v gh >/dev/null 2>&1; then
    log "GitHub CLI already installed: $(gh --version | head -n 1)"
else
    log "Installing GitHub CLI..."

    if command -v snap >/dev/null 2>&1; then
        sudo snap install gh --classic
    else
        warn "Snap is not installed."
        warn "Installing GitHub CLI using apt repository..."

        sudo mkdir -p -m 755 /etc/apt/keyrings

        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
          | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null

        sudo chmod go+r \
          /etc/apt/keyrings/githubcli-archive-keyring.gpg

        echo "deb [arch=$(dpkg --print-architecture) \
          signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] \
          https://cli.github.com/packages stable main" \
          | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

        sudo apt-get update
        sudo apt-get install -y gh
    fi
fi

# ------------------------------------------------------------
# Final verification
# ------------------------------------------------------------

echo
echo "============================================================"
echo " Installation complete"
echo "============================================================"
echo

log "Terraform:"
terraform version

echo
log "TFLint:"
tflint --version

echo
log "Trivy:"
trivy --version

echo
log "Checkov:"
checkov --version

echo
log "terraform-docs:"
terraform-docs --version

echo
log "Conftest:"
conftest --version

echo
log "pre-commit:"
pre-commit --version

echo
log "AWS CLI:"
aws --version

echo
log "GitHub CLI:"
gh --version

echo
echo "============================================================"
log "All tools have been installed successfully."
echo "============================================================"
echo
