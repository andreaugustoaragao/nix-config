{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;

    extensions = with pkgs.vscode-extensions; [
      brettm12345.nixfmt-vscode
      vscodevim.vim
      yzhang.markdown-all-in-one
      ms-vscode.makefile-tools
      golang.go
      redhat.java
      mvllow.rose-pine
      pkief.material-icon-theme
      humao.rest-client
      ms-azuretools.vscode-docker
    ];

    userSettings = {
      update.mode = "none";
      window.zoomLevel = 0;
      terminal.integrated.fontFamily = "JetBrainsMono Nerd Font";
      terminal.integrated.fontSize = 14;
      terminal.integrated.shell.linux = "${pkgs.fish}/bin/fish";
      terminal.integrated.defaultProfile.linux = "${pkgs.fish}/bin/fish";

      editor = {
        fontFamily = "'JetbrainsMono Nerd Font', 'monospace', monospace, 'Droid Sans Fallback'";
        fontLigatures = true;
        inlineSuggest.enabled = true;
        bracketPairColorization.enabled = true;
      };

      workbench = {
        iconTheme = "material-icon-theme";
        colorTheme = "Rosé Pine"; # Material Theme Ocean High Contrast
      };
    };
  };
}
