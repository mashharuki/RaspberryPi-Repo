#!/usr/bin/env bash
set -euo pipefail

log() { echo -e "\n\033[1;32m==>\033[0m $*"; }
warn() { echo -e "\n\033[1;33m[warn]\033[0m $*"; }

if [[ "${EUID}" -eq 0 ]]; then
  echo "このスクリプトは root ではなく通常ユーザーで実行してください。（sudo は内部で使います）" >&2
  exit 1
fi

USER_NAME="$(id -un)"
HOME_DIR="${HOME}"
PROFILE_FILE="${HOME_DIR}/.bashrc"

log "OS情報確認"
if ! command -v apt >/dev/null 2>&1; then
  echo "apt が見つかりません。Raspberry Pi OS / Debian 系で実行してください。" >&2
  exit 1
fi

log "パッケージ更新 & 基本ツール導入"
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y \
  git curl wget ca-certificates build-essential pkg-config \
  python3 python3-venv python3-pip unzip

log "Docker（docker.io + compose plugin）インストール"
curl -fsSL https://get.docker.com | sh
sudo systemctl enable --now docker

log "ユーザーを docker グループへ追加"
if ! groups "${USER_NAME}" | grep -q "\bdocker\b"; then
  sudo usermod -aG docker "${USER_NAME}"
  warn "docker グループに追加しました。反映にはログアウト/ログイン（または再起動）が必要です。"
else
  log "すでに docker グループに所属しています"
fi

log "nvm インストール"
NVM_VERSION="v0.40.1"
if [[ ! -d "${HOME_DIR}/.nvm" ]]; then
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
else
  log "nvm はすでに存在します: ${HOME_DIR}/.nvm"
fi

# shellcheck disable=SC1090,SC1091
export NVM_DIR="${HOME_DIR}/.nvm"
if [[ -s "${NVM_DIR}/nvm.sh" ]]; then
  . "${NVM_DIR}/nvm.sh"
else
  echo "nvm.sh が見つかりません。nvm のインストールに失敗している可能性があります。" >&2
  exit 1
fi

log "Node.js lts インストール & デフォルト化"
nvm install --lts
nvm alias default 'lts/*'
nvm use --lts

log "Corepack 有効化（pnpm / yarn）"
corepack enable
# 最新化したい場合は下を有効化
# corepack prepare pnpm@latest --activate
# corepack prepare yarn@stable --activate

log "bun インストール"
if [[ ! -d "${HOME_DIR}/.bun" ]]; then
  curl -fsSL https://bun.com/install | bash
else
  log "bun はすでに存在します: ${HOME_DIR}/.bun"
fi

log "bun の PATH 設定（.bashrc）"
grep -q 'BUN_INSTALL' "${PROFILE_FILE}" 2>/dev/null || {
  {
    echo ''
    echo '# bun'
    echo 'export BUN_INSTALL="$HOME/.bun"'
    echo 'export PATH="$BUN_INSTALL/bin:$PATH"'
  } >> "${PROFILE_FILE}"
}

# いまのシェルにも反映
export BUN_INSTALL="${HOME_DIR}/.bun"
export PATH="${BUN_INSTALL}/bin:${PATH}"

log "uv インストール"
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  log "uv はすでにインストール済みです"
fi

log "uv の PATH 設定（~/.local/bin）"
grep -q 'HOME/.local/bin' "${PROFILE_FILE}" 2>/dev/null || {
  {
    echo ''
    echo '# uv (and other local user tools)'
    echo 'export PATH="$HOME/.local/bin:$PATH"'
  } >> "${PROFILE_FILE}"
}

export PATH="${HOME_DIR}/.local/bin:${PATH}"

log "インストール結果チェック"
echo "---- versions ----"
docker --version || true
docker compose version || true
node -v
npm -v
pnpm -v
yarn -v
bun -v || true
uv --version || true
echo "------------------"

log "完了"
warn "docker グループ追加を反映するため、いったんログアウト→ログイン（または sudo reboot）してください。"
warn "反映後に: docker run hello-world を試すと確認できます。"

