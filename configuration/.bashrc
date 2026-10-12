#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\[\e[1;31m\][\u@\h] \[\e[0;36m\]\w \[\e[1;34m\]\$ \[\e[0m\]'
neofetch
