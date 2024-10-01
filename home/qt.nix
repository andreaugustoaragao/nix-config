{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style = {
      name = "kvantum";
    };
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Catppuccin-Frape-Blue
    '';

    "Kvantum/Catppuccin-Frape-Blue".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Frape-Blue";
  };
}
