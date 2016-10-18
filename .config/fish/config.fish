# source all path modifications
source ~/.config/fish/path.fish
source ~/.config/fish/secrets.fish
# Base16 Shell
# eval sh $HOME/.config/base16-shell/base16-chalk.dark.sh

# Use emacs for any EDITOR actions, creating a new frame as opposed to using 
# the current frame, don't wait for the server to return, and use alternate 
# editor to spawn emacs in daemon mode if not running.
set --export --global ALTERNATE_EDITOR ""
set --export --global EDITOR "emacsclient --create-frame --no-wait --alternate-editor="""

set fish_term24bit 1

