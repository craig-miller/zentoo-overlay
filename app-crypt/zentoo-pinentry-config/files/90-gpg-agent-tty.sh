# Keep gpg-agent pointed at the current interactive TTY for terminal pinentry.
case $- in
    *i*) ;;
    *) return 0 2>/dev/null || exit 0 ;;
esac

if command -v tty >/dev/null 2>&1; then
    GPG_TTY=$(tty 2>/dev/null || true)
    if [ -n "${GPG_TTY}" ] && [ "${GPG_TTY}" != "not a tty" ]; then
        export GPG_TTY
        command -v gpg-connect-agent >/dev/null 2>&1 \
            && gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
    fi
fi
