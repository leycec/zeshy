#!/usr/bin/env zsh
# ====================[ .zprofile                          ]====================
#
# --------------------( LICENSE                            )--------------------
# Copyright 2007-2012 by Cecil Curry.
# See "COPYING" for additional details.
#
# --------------------( SYNOPSIS                           )--------------------
# Sourced by login zsh shells before other dot files when run by "zeshy".

# ....................{ MAIN                               }....................
# Source the current user's ".zprofile", if found.
[[ -f "${ZESHY_USER_ZDOTDIR}/.zprofile" ]] &&
    source -- "${ZESHY_USER_ZDOTDIR}/.zprofile"

# --------------------( WASTELANDS                         )--------------------
