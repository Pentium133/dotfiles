# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias '..'='cd ..'
alias '...'='cd ../..'

# alias emacs='emacsclient -t --with-x-toolkit=lucid'

alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
alias gs='git status -s'
alias gd='git diff'

# Exports
export TERM="xterm-256color"
export EDITOR="emacsclient -t"
export ALTERNATE_EDITOR=""

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
. /etc/bash_completion.d/git

function parse_git_dirty {
  git diff --quiet HEAD &>/dev/null
    [[ $? == 1 ]] && echo "*"
}
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

function set_prompt {
# ANSI escape codes documented in:
# http://en.wikipedia.org/wiki/ANSI_escape_code
    case $TERM in
      xterm*)
      TITLEBAR='\[\033]0;\u@\h:$(dirs)\007\]'
      ;;
      *)
      TITLEBAR=""
      ;;
    esac
    local REDBOLD="\[\033[1;31m\]"
    local WHITE="\[\033[0;37m\]"
    local YELLOWBOLD="\[\033[1;33m\]"
    local NORMAL="\[\033[0m\]"
    export PS1="${TITLEBAR}\
$REDBOLD>>> \! $WHITE\u@\h\n\
$WHITE\@ $YELLOWBOLD\$(dirs)\n\
[\$(parse_git_branch)\$(parse_git_dirty)] \$$NORMAL "
}
set_prompt

if [ -f /usr/bin/grc ]; then
  alias grca="grc --colour=auto"

  for c in ping traceroute make diff last cvs netstat ifconfig uptime vmstat iostat df mount uname ps route lsmod whereis ; do
    alias ${c}="grca ${c}"
  done

  alias ll="grca ls --color=force -l"
  alias ccal="grca cal"
fi

#source /etc/bash_completion.d/git-flow-completion.bash
if [[ -s /home/serg/.rvm/scripts/rvm ]] ; then source /home/serg/.rvm/scripts/rvm ; fi

fortune
echo "____________________________________________________________________________"

setxkbmap -layout 'us,ru' -option 'grp:caps_toggle,grp_led: caps'