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
# Clear global list ${path} and hence global string ${PATH}, if inherited from a
# parent shell. Doing so allows Zeshy to reliably test whether or not the
# canonical "/etc/zsh/zprofile" script sourced by zsh immediately after sourcing
# this script establishes a default login profile (e.g., by sourcing
# "/etc/profile.env"). If it does, ${path} will be non-empty by the time zsh
# sources Zeshy's ".zshrc" script, which sources the main Zeshy script; else,
# ${path} will remain empty. In the former case, the main Zeshy script must not
# establish a default login profile (since "/etc/zsh/zprofile" has already done
# so). In the latter case, the main Zeshy script must establish a default login
# profile. In either case, only clearing ${path} here subsequently allows the
# main Zeshy script to decide which case applies.
path=( )

# Source the current user's ".zprofile", if found.
[[ -f "${ZESHY_USER_ZDOTDIR}/.zprofile" ]] &&
    source -- "${ZESHY_USER_ZDOTDIR}/.zprofile"

# --------------------( WASTELANDS                         )--------------------
