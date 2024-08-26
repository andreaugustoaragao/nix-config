{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    customPaneNavigationAndResize = false;
    newSession = true;
    extraConfig = ''
      set-option -g default-shell ${pkgs.fish}/bin/fish
      set-option -sg escape-time 10
      set-option -g focus-events on
      set-option -g mouse on
      # vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      bind-key % split-window -h -c "#{pane_current_path}"
      bind-key '"' split-window -p 30 -v -c "#{pane_current_path}"

    '';
    plugins = [
      pkgs.tmuxPlugins.rose-pine
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
  };
}
