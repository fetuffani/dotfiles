export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"

# Prompt is handled by starship (Catppuccin Macchiato), not an oh-my-zsh theme
ZSH_THEME=""

plugins=(git docker zsh-autosuggestions zsh-syntax-highlighting)

# Catppuccin Macchiato colors for syntax highlighting (must load before the plugin)
source "${${(%):-%x}:A:h}/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh"
# Autosuggestion color: Catppuccin Macchiato overlay1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#8087a2'

source $ZSH/oh-my-zsh.sh

command -v starship >/dev/null && eval "$(starship init zsh)"

# machine-specific overrides (untracked)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
