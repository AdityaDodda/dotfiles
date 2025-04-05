if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting #Supresses fish's intro message

## Sashimi Prompt ##
function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -g red (set_color -o red)
  set -g blue (set_color -o blue)
  set -l green (set_color -o green)
  set -g normal (set_color normal)

  set -l ahead (_git_ahead)
  set -g whitespace ' '

  if test $last_status = 0
    set initial_indicator "$green◆"
    set status_indicator "$normal❯$cyan❯$green❯"
  else
    set initial_indicator "$red✖ $last_status"
    set status_indicator "$red❯$red❯$red❯"
  end
  set -l cwd $cyan(basename (prompt_pwd))

  if [ (_git_branch_name) ]

    if test (_git_branch_name) = 'main'
      set -l git_branch (_git_branch_name)
      set git_info "$normal git:($red$git_branch$normal)"
    else
      set -l git_branch (_git_branch_name)
      set git_info "$normal git:($blue$git_branch$normal)"
    end

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  # Notify if a command took more than 5 minutes
  if [ "$CMD_DURATION" -gt 300000 ]
    echo The last command took (math "$CMD_DURATION/1000") seconds.
  end

  echo -n -s $initial_indicator $whitespace $cwd $git_info $whitespace $ahead $status_indicator $whitespace
end

function _git_ahead
  set -l commits (command git rev-list --left-right '@{upstream}...HEAD' 2>/dev/null)
  if [ $status != 0 ]
    return
  end
  set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
  set -l ahead  (count (for arg in $commits; echo $arg; end | grep -v '^<'))
  switch "$ahead $behind"
    case ''     # no upstream
    case '0 0'  # equal to upstream
      return
    case '* 0'  # ahead of upstream
      echo "$blue↑$normal_c$ahead$whitespace"
    case '0 *'  # behind upstream
      echo "$red↓$normal_c$behind$whitespace"
    case '*'    # diverged from upstream
      echo "$blue↑$normal$ahead $red↓$normal_c$behind$whitespace"
  end
end

function _git_branch_name
  echo (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty 2>/dev/null)
end
## END OF PROMPT##

## NAVIGATION ##
function up
    set -l d ""
    set -l limit $argv[1]

    # Default to limit of 1
    if test -z "$limit" -o "$limit" -le 0
        set limit 1
    end

    for i in (seq 1 $limit)
        set d "../$d"
    end

    # perform cd. Show error if cd fails
    if not cd "$d"
        echo "Couldn't go up $limit dirs."
    end
end

## ALIASES ##
#Pacman
alias pacs='sudo pacman -S' #Install the package required 
alias pacss='sudo pacman -Ss' #Search the package required
alias pacsg='sudo pacman -Sg' #Search the group package required
alias pacsyu='sudo pacman -Syu' #Synchronize the packages and upgrade them all
alias pacr='sudo pacman -R' # Remove the package required
alias pacrs='sudo pacman -Rs' # Remove the package required with dependencies
alias pacrns='sudo pacman -Rns' # Remove the package required with dependencies,conifg also
alias unlock='sudo rm /var/lib/pacman/db.lck' #Remove Pacman Lock

#cd Commands
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

# Git Commands
alias gi='git init'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gcc='git clone'
alias gd='git diff'
alias gb='git branch'
alias gr='git restore'
alias gp='git push'

# ls Commands
alias ls='eza'
alias la='eza --all'
alias ll='eza --long --header --icons --git --all'

#Interactive Commands
alias rm='trash -v'
alias cp='cp -i'
alias mv='mv -i'

#Power Commands
alias shutdown='sudo shutdown now'
alias reboot='sudo reboot now'

#Other Commands
alias ff=fastfetch
alias ht=htop
#alias vim=nvim
alias bt=bpytop
alias man=batman
alias cat=bat
alias icat='kitten icat'
alias kd='kitten diff'
alias kc='kitten clipboard'

# Zoxide Configuration
zoxide init fish | source
