#!/usr/bin/env bash
# Install AND sync: zsh + oh-my-zsh + starship (Catppuccin Macchiato) + my configs.
# Safe to re-run any time: pulls the latest dotfiles, updates oh-my-zsh, plugins and
# starship, and re-applies the symlinks.
#   first run:  wget -qO- https://raw.githubusercontent.com/fetuffani/dotfiles/main/install.sh | bash
#   later:      ~/dotfiles/install.sh
set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/fetuffani/dotfiles.git}"
DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
CUSTOM="$ZSH_DIR/custom"
BIN="$HOME/.local/bin"

log()  { printf '\033[1;35m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; }
need() { command -v "$1" >/dev/null || { echo "missing: $1" >&2; exit 1; }; }
if [ "$(id -u)" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi

if ! command -v git >/dev/null || ! command -v zsh >/dev/null || ! command -v curl >/dev/null; then
  log "installing packages"
  $SUDO apt-get update -qq && $SUDO apt-get install -y -qq git zsh curl
fi
need git; need zsh; need curl

# 1. dotfiles repo: clone or fast-forward
log "syncing dotfiles"
if [ -d "$DIR/.git" ]; then
  git -C "$DIR" pull --ff-only || warn "could not fast-forward $DIR (local commits or changes?); keeping local state"
else
  git clone "$REPO_URL" "$DIR"
fi
git -C "$DIR" config core.hooksPath .githooks

# 2. oh-my-zsh: install or update
if [ ! -d "$ZSH_DIR" ]; then
  log "installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "updating oh-my-zsh"
  git -C "$ZSH_DIR" pull -q --ff-only || warn "oh-my-zsh update failed"
fi

# 3. plugins: clone or update
sync_repo() {
  if [ -d "$2/.git" ]; then log "updating $(basename "$2")"; git -C "$2" pull -q --ff-only || warn "update failed: $2"
  else log "installing $(basename "$2")"; git clone -q --depth=1 "$1" "$2"; fi
}
sync_repo https://github.com/zsh-users/zsh-autosuggestions.git     "$CUSTOM/plugins/zsh-autosuggestions"
sync_repo https://github.com/zsh-users/zsh-syntax-highlighting.git "$CUSTOM/plugins/zsh-syntax-highlighting"

# 4. starship prompt: install or upgrade into ~/.local/bin (no sudo)
log "installing/updating starship"
mkdir -p "$BIN"
curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$BIN" >/dev/null || warn "starship install failed"

# 5. link configs, backing up real files once
link() {
  local src="$DIR/$1" dst="$HOME/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then mv "$dst" "$dst.bak"; log "backed up $dst -> $dst.bak"; fi
  ln -sfn "$src" "$dst"
}
log "linking configs"
link zshrc .zshrc
link starship.toml .config/starship.toml

# 6. clean up leftovers from the old powerlevel10k setup
[ -L "$HOME/.p10k.zsh" ] && rm -f "$HOME/.p10k.zsh"
[ -d "$CUSTOM/themes/powerlevel10k" ] && rm -rf "$CUSTOM/themes/powerlevel10k" && log "removed powerlevel10k"

# 7. default shell
if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
  $SUDO chsh -s "$(command -v zsh)" "$(id -un)" || warn "run: chsh -s $(command -v zsh)"
fi
log "done. Start a new shell with: exec zsh"
