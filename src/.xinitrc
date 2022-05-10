# Disable access control for the current user.
xhost +SI:localuser:$USER

# Make Java applications aware this is a non-reparenting window manager.
export _JAVA_AWT_WM_NONREPARENTING=1

# Set default cursor.
xsetroot -cursor_name left_ptr

# Set keyboard repeat rate.
xset r rate 200 60

# start some programs
caffeine-indicator &
#tint2 &
dropbox start

# for EXWM
#emacs --daemon -f exwm-enable
#exec emacsclient -c
#emacs -f exwm-enable

# for EXWM-X
#emacs --daemon --eval '(require (quote exwm-x))'
#exec emacsclient -c
emacs --eval '(require (quote exwm-x))'
