{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    home.packages = with pkgs; [
      go
      # editor support
      go-tools # honnef.co/go/tools/...@latest
      gotools # golang.org/x/tools
      golint # golang.org/x/lint
      gocode-gomod # github.com/stamblerre/gocode
      gotests # github.com/cweill/gotests
      impl # github.com/josharian/impl
      reftools # github.com/davidrjenni/reftools/cmd/fillstruct
      gopkgs # github.com/uudashr/gopkgs/v2/cmd/gopkgs
      go-outline # github.com/ramya-rao-a/go-outline
      go-symbols # github.com/acroca/go-symbols
      godef # github.com/rogpeppe/godef
      gogetdoc # github.com/zmb3/gogetdoc
      gomodifytags # github.com/fatih/gomodifytag
      revive # github.com/mgechev/revive
      delve # github.com/go-delve/delve/cmd/dlv
      gore # golang repl: github.com/motemen/gore
      gopls
      iferr
      gotestsum
      gomodifytags
      gofumpt
      mockgen
      golangci-lint
      richgo
      go-tools
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [vim-go];

    programs.vscode = {
      userSettings = {
        "go.docsTool" = "godoc";
        "go.formatTool" = "goimports";
        "go.useLanguageServer" = true;
      };

      extensions = with pkgs.vscode-extensions; [
        golang.go
      ];
    };

    home.sessionVariables = {
      GOPATH = "${config.xdg.dataHome}/go";
    };

    home.sessionPath = [
      "$HOME/.local/share/go/bin"
    ];
  };
}
