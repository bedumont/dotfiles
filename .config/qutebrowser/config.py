# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

# Load autoconfig.yml
config.load_autoconfig()

config.bind('z', 'spawn --userscript qute-pass --dmenu-invocation dmenu')
config.bind('Z', 'spawn --userscript qute-pass --dmenu-invocation dmenu --password-only')
config.bind('<F12>', 'config-cycle input.spatial_navigation')

def bind(keys, *commands, mode='normal'):
    config.bind(keys, ' ;; '.join(commands), mode=mode)

#bind(';m', 'hint all spawn -v /home/ben/scripts/umpv --force-window yes {hint-url}', 'message-info "Select video to load with umpv."')
bind(';m', 'hint links spawn /home/ben/scripts/umpv {hint-url}', 'message-info "Select video to load with umpv."')
bind(';M', 'spawn /home/ben/scripts/umpv {url}', 'message-info "Video sent to mpv."')

c.content.host_blocking.lists.append( str(config.configdir) + "/blockedHosts")
c.aliases = {
    "Zotero": "hint links userscript zotero",
    "q": "quit", "w": "session-save",
    "wq": "quit --save",
    "zotero": "spawn --userscript zotero",
    "umpv": "spawn /home/ben/scripts/umpv {url}",
    "aumpv": "spawn /home/ben/scripts/umpv --append {url}"
}
