#!/usr/bin/env zsh
# ====================[ .zprofile                          ]====================
#
# --------------------( LICENSE                            )--------------------
# Copyright 2007-2013 by Cecil Curry.
# See "COPYING" for additional details.
#
# --------------------( SYNOPSIS                           )--------------------
# Sourced by login zsh shells before other dot files when run by "zeshy".

# ....................{ MAIN                               }....................
#FIXME: O.K.; now that we've eliminating sourcing of either system- or
#user-specific zsh dotfiles, the *ONLY* possible way ${PATH} could be set is if
#"/etc/zshenv" both exists and sets such path -- which seems mildly likely,
#although not the case under Gentoo. However, it's unclear how we could
#distinguish such case from the conventional case. The best thing to do is
#probably leave ${PATH} as is. *shrug*

# Clear global list ${path} and hence global string ${PATH}, if inherited from a
# parent shell. Doing so allows zeshy to reliably test whether or not the
# canonical "/etc/zsh/zprofile" script sourced by zsh immediately after sourcing
# this script establishes a default login profile (e.g., by sourcing
# "/etc/profile.env"). If it does, ${path} will be non-empty by the time zsh
# sources zeshy's ".zshrc" script, which sources the main zeshy script; else,
# ${path} will remain empty. In the former case, the main zeshy script must not
# establish a default login profile (since "/etc/zsh/zprofile" has already done
# so). In the latter case, the main zeshy script must establish a default login
# profile. In either case, only clearing ${path} here subsequently allows the
# main zeshy script to decide which case applies.
# path=( )

# --------------------( WASTELANDS                         )--------------------
# Source the current user's ".zprofile", if found.
# if [[ -f "${ZESHY_USER_ZDOTDIR}/.zprofile" ]] {
#     source -- "${ZESHY_USER_ZDOTDIR}/.zprofile"
# }
