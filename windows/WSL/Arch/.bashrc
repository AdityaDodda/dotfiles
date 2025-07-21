#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

## HIST SIZE ##
HISTSIZE=1000
HISTFILESIZE=1000

### SHOPT ###
shopt -s cmdhist    # saves multi-line commands in history as single line
shopt -s histappend # do not overwrite history

## Ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

### ARCHIVE EXTRACTION ###
# usage: ex <file>
ex() {
    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *.deb) ar x "$1" ;;
        *.tar.xz) tar xf "$1" ;;
        *.tar.zst) unzstd "$1" ;;
        *) echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

### NAVIGATION ###
up() {
    local d=""
    local limit="$1"

    #Default to limit of 1
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
        limit=1
    fi

    for ((i = 1; i <= limit; i++)); do
        d="../$d"
    done

    #perform cd. Show error if cd fails
    if ! cd "$d"; then
        echo "Couldn't go up $limit dirs."
    fi
}

### ALIASES ###
#Pacman
alias pacs='sudo pacman -S'                   #Install the package required
alias pacss='sudo pacman -Ss'                 #Search the package required
alias pacsg='sudo pacman -Sg'                 #Search the group package required
alias pacsyu='sudo pacman -Syu'               #Synchronize the packages and upgrade them all
alias pacr='sudo pacman -R'                   # Remove the package required
alias pacrs='sudo pacman -Rs'                 # Remove the package required with dependencies
alias pacrns='sudo pacman -Rns'               # Remove the package required with dependencies,config also
alias unlock='sudo rm /var/lib/pacman/db.lck' #Remove Pacman Lock

#Git Commands
alias gi='git init'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gn='git notes add -m'
alias gcl='git clone'
alias gd='git diff'
alias gb='git branch'
alias gr='git restore'
alias gh='git checkout'
alias gp='git push'
alias gl='git log'
alias gll='git pull'

#ls Commands
alias ls='eza --long --group-directories-first'
alias la='eza --long --all --group-directories-first'
alias ll='eza --long  -g --header --icons --git --all --group-directories-first'
alias lt='eza --tree'

#cd Commands
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

#Interactive Commands
alias cp='cp -i'
alias rm='trash -v'
alias mv='mv -i'

#Other Commands
alias ff=fastfetch
alias y=yazi
#alias vim=nvim
alias bt=btop
alias man=batman
alias cat=bat
alias lg=lazygit

## NVM Configuration ##
[ -s /usr/share/nvm/init-nvm.sh ] && \. /usr/share/nvm/init-nvm.sh

### EXPORTS ###
#Starship Prompt
eval "$(starship init bash)"

#Yazi Configuration
export EDITOR="nvim" # Sets the default editor for opening files

#Zoxide Configuration
eval "$(zoxide init bash)"
_ZO_DOCTOR=0
