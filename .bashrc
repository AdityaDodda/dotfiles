#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

### ALIASES ###
#Navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

#Pacman
alias pacs='sudo pacman -S' #Install the package required 
alias pacss='sudo pacman -Ss' #Search the package required
alias pacsg='sudo pacman -Sg' #Search the group package required
alias pacsyu='sudo pacman -Syu' #Synchronize the packages and upgrade them all
alias pacr='sudo pacman -R' # Remove the package required
alias pacrs='sudo pacman -Rs' # Remove the package required with dependencies
alias pacrns='sudo pacman -Rns' # Remove the package required with dependencies,conifg also
alias unlock='sudo rm /var/lib/pacman/db.lck' #Remove Pacman Lock

# ls Commands
alias la='ls -a'
alias ll='ls -alh'

#Interactive Commands
alias cp='cp -i'
alias rm='trash -v'
alias mv='mv -i'

#Power Commands
alias shutdown='sudo shutdown now'
alias reboot='sudo reboot now'

#Other Commands
alias nf=neofetch
alias ht=htop
#alias vim=nvim
alias bt=bpytop
alias man=batman
alias cat=bat
alias icat='kitten icat'
alias kd='kitten diff'
alias kc='kitten clipboard'

#Starship Prompt
eval "$(starship init bash)"

# Emacs Client and Server path
export PATH="$HOME/.config/emacs/bin:$PATH"
alias emacs="emacsclient -c -a 'emacs'"

