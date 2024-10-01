config.load_autoconfig()
config.set("fonts.default_size", "12pt")
config.set("colors.webpage.preferred_color_scheme", "dark")
config.set("tabs.show", "switching")
config.set("statusbar.show", "in-mode")
config.set("content.javascript.clipboard", "access")
config.set("auto_save.session", True)
# https://peter.sh/experiments/chromium-command-line-switches/
c.qt.workarounds.disable_accelerated_2d_canvas = "never"
c.qt.args = [
    "enable-gpu-rasterization",
    "ignore-gpu-blocklist",
    "enable-accelerated-2d-canvas",
    "enable-accelerated-video-decode",
    "enable-accelerated-video-encode",
]
c.content.pdfjs = True
c.zoom.default = "125%"
config.bind("<Ctrl-=>", "zoom-in")
config.bind("<Ctrl-->", "zoom-out")
c.downloads.location.directory = "~/downloads/"
c.editor.command = [
    "neovide",
    "{file}",
    "--wayland_app_id",
    "qutebrowser_edit",
    "--x11-wm-class",
    "qutebrowser_edit",
]

c.colors.webpage.bg = ""  # use theme's colors if bg is not set
c.content.blocking.method = "both"
# c.fileselect.folder.command = ['alacritty','-e','lf']
# c.fileselect.handler


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
