# source all path modifications
source ~/.config/fish/path.fish
source ~/.config/fish/secrets.fish
# Base16 Shell
# eval sh $HOME/.config/base16-shell/base16-chalk.dark.sh

set --export --global EDITOR "emacsclient -c -n -a """
set fish_term24bit 1

# tomorrow night bright theme
set fish_color_autosuggestion 969896
set fish_color_command c397d8
set fish_color_comment e7c547
set fish_color_cwd a1c659
set fish_color_cwd_root fb0120
set fish_color_end c397d8
set fish_color_error d54e53 --bold
set fish_color_escape 76c7b7
set fish_color_history_current 76c7b7
set fish_color_match 76c7b7
set fish_color_normal e0e0e0
set fish_color_operator 76c7b7
set fish_color_param 7aa6da
set fish_color_quote b9ca4a
set fish_color_redirection 70c0b1
set fish_color_search_match --background=303030
set fish_color_selection --background=303030
set fish_color_valid_path --underline
set fish_pager_color_completion e0e0e0
set fish_pager_color_description '505050'  'fda331'
set fish_pager_color_prefix 76c7b7
set fish_pager_color_progress 76c7b7
