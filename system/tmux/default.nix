{
  lib,
  inputs,
  system,
  config,
  pkgs,
  username,
  fullname,
  ...
}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.resurrect
      tmuxPlugins.tmux-fzf
      tmuxPlugins.continuum
    ];
    extraConfig = builtins.readFile ./tmux.conf;
  };

  environment.systemPackages = with pkgs; [
    (
      let
        scriptContent = builtins.readFile ./tmux-sessionizer;
      in
        writeShellScriptBin "tmux-sessionizer" scriptContent
    )
    (
      let
        scriptContent = builtins.readFile ./tmux-window-icons;
      in
        writeShellScriptBin "tmux-window-icons" scriptContent
    )
    (
      let
        scriptContent = builtins.readFile ./tmux-right-status;
      in
        writeShellScriptBin "tmux-right-status" scriptContent
    )
    (
      let
        scriptContent = builtins.readFile ./tmux-git-status;
      in
        writeShellScriptBin "tmux-git-status" scriptContent
    )
  ];
}
