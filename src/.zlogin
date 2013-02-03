#!/usr/bin/env zsh
# ====================[ .zlogin                            ]====================
#
# --------------------( LICENSE                            )--------------------
# Copyright 2007-2013 by Cecil Curry.
# See "COPYING" for additional details.
#
# --------------------( SYNOPSIS                           )--------------------
# Sourced by login zsh shells after sourcing ".zprofile" and ".zshrc" when run
# by "zeshy".

# ....................{ MAIN                               }....................
# Source the current user's ".zlogin", if found.
[[ -f "${ZESHY_USER_ZDOTDIR}/.zlogin" ]] &&
    source -- "${ZESHY_USER_ZDOTDIR}/.zlogin"

# --------------------( WASTELANDS                         )--------------------
