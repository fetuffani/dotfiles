# Checa no máximo 1x por dia se há commits novos dos dotfiles no GitHub.
# Não bloqueia o shell: o `git fetch` roda em background e o resultado aparece
# no próximo shell. Nunca faz pull sozinho; só avisa.
_dotfiles_update_check() {
  local dir="$1" cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
  local stamp="$cache/last-check" behind
  [[ -d "$dir/.git" ]] || return
  mkdir -p "$cache"

  # aviso (barato, sem rede): usa o estado do último fetch
  behind=$(git -C "$dir" rev-list --count 'HEAD..@{u}' 2>/dev/null)
  if [[ -n "$behind" && "$behind" -gt 0 ]]; then
    print -P "%F{yellow}dotfiles:%f $behind commit(s) novo(s) no GitHub. Atualize com: %F{cyan}$dir/install.sh%f"
  fi

  # fetch em background se o último check tem mais de 24h (ou nunca rodou)
  local -a fresh
  fresh=( $stamp(N.mh-24) )
  if (( ${#fresh} == 0 )); then
    touch "$stamp"
    { GIT_TERMINAL_PROMPT=0 timeout 20 git -C "$dir" fetch -q &>/dev/null } &!
  fi
}
_dotfiles_update_check "${${(%):-%x}:A:h}"
unfunction _dotfiles_update_check
