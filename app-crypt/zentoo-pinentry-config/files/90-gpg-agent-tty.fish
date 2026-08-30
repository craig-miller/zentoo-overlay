# Keep gpg-agent pointed at the current interactive TTY for terminal pinentry.
status is-interactive; or exit

set -l tty_name (tty 2>/dev/null)
if test -n "$tty_name"; and test "$tty_name" != "not a tty"
    set -gx GPG_TTY "$tty_name"
    command -q gpg-connect-agent; and gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
end
