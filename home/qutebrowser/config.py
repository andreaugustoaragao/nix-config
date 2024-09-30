config.load_autoconfig()
config.set("fonts.default_size", "14pt")
config.set("colors.webpage.preferred_color_scheme", "dark")
config.set("tabs.show", "switching")
config.set("statusbar.show", "in-mode")
config.set("content.javascript.clipboard", "access")


import os
from urllib.request import urlopen

# load your autoconfig, use this, if the rest of your config is empty!
config.load_autoconfig()

if not os.path.exists(config.configdir / "theme.py"):
    theme = "https://raw.githubusercontent.com/catppuccin/qutebrowser/main/setup.py"
    with urlopen(theme) as themehtml:
        with open(config.configdir / "theme.py", "a") as file:
            file.writelines(themehtml.read().decode("utf-8"))

if os.path.exists(config.configdir / "theme.py"):
    import theme

    theme.setup(c, "mocha", True)
