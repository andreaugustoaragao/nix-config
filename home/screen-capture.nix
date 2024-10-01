{
  pkgs,
  config,
  lib,
  ...
}: {
  services.flameshot = {
    enable = false;
    settings = {
      General = {
        disabledTrayIcon = false;
        showStartupLaunchMessage = false;
        savePath = "${config.home.homeDirectory}/screenshots";
      };
    };
  };

  home.packages = with pkgs; [
    maim
    pinta
    (writeShellScriptBin "screenshot-x11" ''
      #!/usr/bin/env bash
      filename=$(date +%Y%m%d-%I%M%S-%N).png
      output=${config.home.homeDirectory}/screenshots/$filename

      case "$1" in
        "full") maim "$output" && xclip -selection clipboard -t image/png "$output"  || exit;;
        "select") maim -b 5 -l -c 0.3,0.4,0.6,0.4 -s "$output" && xclip -selection clipboard -t image/png "$output"  || exit;;
      esac

      notify-send -a "screenshot"  -i $output "new" "$filename - click to edit" --action="open_pinta,Open with Pinta" && bash -c 'pinta "'"$output"'"'
    '')
  ];
}
