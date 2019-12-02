conda_env() {
    if [ ! -z "$CONDA_PREFIX" ]
    then
        print -n " %{$fg_bold[white]%}on %{$fg_bold[blue]%}ꓛ ${CONDA_PREFIX##*/}%{$reset_color%}"
    fi
}

PROMPT='
%B%(?.%F{green}λ.%F{red}X) %~%b%f
%B%F{blue}%(!.#.>)%f%b '
RPROMPT='%*'
