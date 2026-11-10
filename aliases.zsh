alias dcup='docker compose -f ./docker-compose.yml up -d --remove-orphans' # brings up all containers if one is not defined after dcup
alias dcdown='docker compose -f ./docker-compose.yml stop'                 # brings down all containers if one is not defined after dcdown
alias dcpull='docker compose -f ./docker-compose.yml pull'                 # pulls all new images unless one is specified
alias dclogs='docker compose -f ./docker-compose.yml logs -tf --tail="50" '
alias dcupdt='docker images --format "{{.Repository}}:{{.Tag}}" | xargs -L1 sudo docker pull; sudo docker compose up -d'
alias rsync='rsync --stats --partial -P --info=name1 --info=progress1 -a -h --ignore-existing --append-verify'

# function instead of alias so the container name is passed as an argument: dctail <container>
dctail() { docker logs -tf --tail="50" "$@"; }

# gerenciador TUI de sessões do tmux (bin/tmx); `tmux <args>` continua repassando ao tmux real
# (função em vez de alias: se o tmx ainda não estiver instalado, cai no tmux real)
tmux() { if (( $+commands[tmx] )); then tmx "$@"; else command tmux "$@"; fi }
