# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

# Load autoconfig.yml
config.load_autoconfig()

c.content.host_blocking.lists.append( str(config.configdir) + "/blockedHosts")
c.aliases = {
    "Zotero": "hint links userscript zotero",
    "q": "quit", "w": "session-save",
    "wq": "quit --save",
    "zotero": "spawn --userscript zotero",
    "umpv": "spawn /home/ben/scripts/umpv {url}",
    "aumpv": "spawn /home/ben/scripts/umpv --append {url}"
}
c.bindings.commands = {
    "hint": {
        "<Escape>": "leave-mode"
    },
    "normal": {
        ",n": "spawn --userscript youtube-dl",
        ";n": "hint links userscript youtube-dl",
        ";N": "hint url userscript youtube-dl",
        ";M": "spawn --userscript view_in_umpv {url}",
        ";m": "hint links userscript view_in_umpv",
        "<F12>": "config-cycle input.spatial_navigation",
        "H": "back",
        "J": "tab-next",
        "K": "tab-prev",
        "L": "forward",
        "M": "bookmark-add",
        "z": "spawn --userscript qute-pass --dmenu-invocation dmenu",
        "Z": "spawn --userscript qute-pass --dmenu-invocation dmenu --password-only",
        "h": "scroll left",
        "l": "scroll right",
        "m": "quickmark-save",
        "\u00f9": "spawn mpv {url}"
    }
}

c.url.searchengines = {
    "DEFAULT": "https://www.startpage.com/do/asearch?q={}",
    "a": "https://wiki.archlinux.org/index.php?search={}",
    "dd": "https://duckduckgo.com/?q={}",
    "g": "https://www.google.com/search?hl=en&q={}",
    "py": "https://docs.python.org/3/search.html?q={}", "tf": "https://www.tensorflow.org/s/results/?q={}", "we": "https://en.wikipedia.org/w/index.php?search={}",
    "wf": "https://fr.wikipedia.org/w/index.php?search={}",
    "y": "https://www.youtube.com/results?search_query={}",
}
