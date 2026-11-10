# dotfiles

zsh + oh-my-zsh + starship (Catppuccin Macchiato). Run `./install.sh` to install or sync (pulls, updates omz, plugins and starship, re-links).

On a new server:

    wget -qO- https://raw.githubusercontent.com/fetuffani/dotfiles/main/install.sh | bash

To sync later: `~/dotfiles/install.sh` (after `git push` from the other machine).

Recommended font: **CommitMono Nerd Font Mono**, set in the terminal you connect from (client side). Download: https://www.nerdfonts.com/font-downloads

Also set the terminal colors to Catppuccin Macchiato (client side).

Machine-specific config and secrets go in `~/.zshrc.local` (untracked).

`tmux` (alias para `bin/tmx`) abre um gerenciador TUI de sessões: Enter entra, `r` renomeia, `n` cria, `d` mata. Com argumentos (`tmux ls`, `tmux new -s x`) repassa ao tmux real.

O shell avisa se há commits novos no GitHub (checa 1x por dia em background; não atualiza sozinho, rode `~/dotfiles/install.sh`).
