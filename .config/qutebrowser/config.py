# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

# Load autoconfig.yml
config.load_autoconfig()

config.bind('z', 'spawn --userscript qute-pass --dmenu-invocation dmenu')
config.bind('Z', 'spawn --userscript qute-pass --dmenu-invocation dmenu --password-only')
config.bind('<F12>', 'config-cycle input.spatial_navigation')
config.bind('<Ctrl-Shift-y>', 'hint links spawn --detach mpv --force-window yes {hint-url}')

def bind(keys, *commands, mode='normal'):
    config.bind(keys, ' ;; '.join(commands), mode=mode)

bind(',m', 'spawn --userscript view_in_umpv -d')
bind(';m', 'hint all spawn -v umpv {hint-url}', 'message-info "Select video to load with umpv."')
bind(';M', 'hint all spawn -v umpv --append {hint-url}', 'message-info "Select video to append to umpv playlist."')

c.content.host_blocking.lists.append( str(config.configdir) + "/blockedHosts")
