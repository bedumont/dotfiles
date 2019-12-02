# Example aliases
alias cfz="vim $XDG_CONFIG_HOME/zsh/.zshrc" \
        cfp="vim $XDG_CONFIG_HOME/zsh/.zprofile" \
        cfi="vim $XDG_CONFIG_HOME/i3/config" \
        suck="cd ~/.local/suckless" \ pipinstall="pip install --user" \
        sourcez="source $XDG_CONFIG_HOME/zsh/.zshrc" \
        MA2="cd ~/ULB/MA2-Polytech" \
        mfe="cd ~/ULB/MA2-Polytech/MFE" \
        MFE="cd ~/ULB/MA2-Polytech/MFE; source ~/ULB/MA2-Polytech/MFE/venv/bin/activate" \
        config="/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME" \
        mutt='cd ~/downloads && mutt' \
        suckclean="make clean && rm  -f config.h && git reset --hard origin/master" \
        fixwifi="sudo ip link set wlan0 down" \
        updt="sudo pacman -Syu && pkill -RTMIN+9 dwmblocks && setbg -r" \
        pinstall="sudo pacman -S" \
        mpvrecord="mpv --demuxer-lavf-format video4linux2 --demuxer-lavf-o-set input_format=mjpeg av://v4l2:/dev/video0" \
        x="sxiv -ft *" \
        hh="cd ~/" \
        pp="cd ~/pictures" \
        ddd="cd ~/documents" \
        bb="cd ~/builds" \
        ls="ls --color=auto" \
        mbsync="mbsync -c $XDG_CONFIG_HOME/isync/mbsyncrc" \
        xo="xdg-open" \
        paper="cd $HOME/documents/papers/ && zathura" \
        gch="git checkout" \
        gb="git branch" \
        ga="git add" \
        gc="git commit" \

# Load zsh-syntax-highlignting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
# Lines configured by zsh-newuser-install
HISTFILE=$ZDOTDIR/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob notify
unsetopt beep nomatch
bindkey -v
bindkey '^[[Z' reverse-menu-complete
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ben/.zshrc'
zstyle ':completion:*' menu select

autoload -Uz compinit colors vcs_info
compinit
colors
# End of lines added by compinstall
source $ZDOTDIR/prompts/my_prompt.zsh
