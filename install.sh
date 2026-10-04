#!/usr/bin/env bash
# Bootstrap zsh + oh-my-zsh + my configs.
#   wget -qO- https://raw.githubusercontent.com/fetuffani/dotfiles/main/install.sh | bash
# Re-run any time to pull the latest configs (existing files are backed up once).
set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/fetuffani/dotfiles.git}"
DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
CUSTOM="$ZSH_DIR/custom"

need() { command -v "$1" >/dev/null || { echo "missing: $1" >&2; exit 1; }; }
if [ "$(id -u)" -eq 0 ]; then SUDO=""; else SUDO="sudo"; fi

if ! command -v git >/dev/null || ! command -v zsh >/dev/null || ! command -v curl >/dev/null; then
  $SUDO apt-get update -qq && $SUDO apt-get install -y -qq git zsh curl
fi
need git; need zsh; need curl

# dotfiles repo
if [ -d "$DIR/.git" ]; then git -C "$DIR" pull --ff-only; else git clone "$REPO_URL" "$DIR"; fi

# oh-my-zsh (don't touch .zshrc, we link our own)
if [ ! -d "$ZSH_DIR" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

clone() { [ -d "$2/.git" ] || git clone --depth=1 "$1" "$2"; }
clone https://github.com/romkatv/powerlevel10k.git            "$CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions.git     "$CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$CUSTOM/plugins/zsh-syntax-highlighting"

# link configs, backing up real files once
link() {
  local src="$DIR/$1" dst="$HOME/$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then mv "$dst" "$dst.bak"; echo "backed up $dst -> $dst.bak"; fi
  ln -sfn "$src" "$dst"
}
link zshrc .zshrc
link p10k.zsh .p10k.zsh
# machine-specific stuff goes in ~/.zshrc.local (not tracked); see zshrc

git -C "$DIR" config core.hooksPath .githooks

# default shell
if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
  $SUDO chsh -s "$(command -v zsh)" "$(id -un)" || echo "run: chsh -s $(command -v zsh)"
fi
echo "Done. Start a new shell with: exec zsh"
