#
# ~/.zprofile
#

# Load interactive config if present
[[ -f ~/.zshrc ]] && source ~/.zshrc

# Start X only on tty1
if [[ -z "$DISPLAY" && "$XDG_VTNR" == 1 ]]; then
    exec xinit -- :1
fi
