# NOTE: Fish variable scoping is interesting. There are 3 scoping levels,
# local, global, and universal. Universal is a scope for all shells ever,
# and is not wanted for config files, because it cannot be unset by just
# removing a line from the config file, you have to explicitly unset it.
# Local is just for a certain function, which is not useful for config.
# That is why all of these variables are global.
#
# In addition, variables are not exported by default, which is why all of
# these have the export flag (same as export in bash). This allows other
# processes to pick up on variables set by the shell.
#
# In addition, $fish_user_paths is prepended to $PATH automatically, making it
# a great way to set $PATH.
# A good resource is https://nothingbutsnark.svbtle.com/trying-out-the-fish-shell
set --export --global ANDROID_TOOLS $HOME/android-sdk/platform-tools
set --export --global LOCAL_BIN $HOME/.local/bin
set --export --global YARN_BIN (yarn global bin)

# These lines were for a manual npm install to avoid needing sudo
# ========================================================
# set --export --global NPM_PACKAGES $HOME/.npm-packages
# set --export --global NPM_CONFIG_PREFIX $NPM_PACKAGES
# set --export --global NODE_PATH "$NPM_PACKAGES/lib/node_modules $NODE_PATH"
# set fish_user_paths $NPM_PACKAGES/bin $fish_user_paths

set fish_user_paths $ANDROID_TOOLS $fish_user_paths
set fish_user_paths $LOCAL_BIN $fish_user_paths
set fish_user_paths $YARN_BIN $fish_user_paths

