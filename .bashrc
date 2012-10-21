#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global defintions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

PS1='[\u@\h \W]\$ '

alias ls='ls --color=auto'
alias ll='ls -l'

# Work stuff
alias vmssh='ssh -L 8222:localhost:8222 -L 8333:localhost:8333 -L 8334:localhost:8334'
alias spssh='ssh -L 8000:localhost:8000 pumpkin'

alias ..0="cd ."
alias ..1="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."

# Don't beep!
#amixer -q -c 0 set Beep,0 0% mute

# Put my custom scripts and manually installed programs into path
export PATH=$PATH:~/bin


