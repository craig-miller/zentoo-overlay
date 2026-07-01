# Copyright 2026 Craig Miller
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for app-misc/kanata"

ACCT_USER_ID=-1
ACCT_USER_GROUPS=( kanata input )
ACCT_USER_HOME=/dev/null
ACCT_USER_SHELL=/bin/false

acct-user_add_deps
