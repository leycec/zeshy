#!/usr/bin/env zsh
# ====================[ .zshrc                             ]====================
#
# --------------------( LICENSE                            )--------------------
# Copyright 2007-2012 by Cecil Curry.
# See "COPYING" for additional details.
#
# --------------------( SYNOPSIS                           )--------------------
# Sourced by login zsh shells after sourcing ".zprofile" when run by "zeshy".

# ....................{ MAIN                               }....................
# Source the current user's ".zshrc", if found.
[[ -f "${ZESHY_USER_ZDOTDIR}/.zshrc" ]] &&
    source -- "${ZESHY_USER_ZDOTDIR}/.zshrc"

# If the absolute path of the main Zeshy script was not previously defined, this
# script was probably not run by "zeshy". Throw an exception!
(( ${+ZESHY_HOME_SCRIPT} )) || {
    print "zeshy: \${ZESHY_HOME_SCRIPT} not defined, so \"${0}\" not sourced by \"zeshy\"" 1>&2
    exit 1
}

# If the list of previously passed arguments was not previously defined, this
# script was probably not run by "zeshy". Throw an exception!
(( ${+ZESHY_ARGS} )) || {
    print "zeshy: \${ZESHY_ARGS} not defined, so \"${0}\" not sourced by \"zeshy\"" 1>&2
    exit 1
}

# Source the main Zeshy script, thus loading Zeshy. Convert the list of
# arguments previously passed to the "zeshy" wrapper script from a string back
# into its original list. Since strings but not lists cannot be inherited by
# subshells, such circumlocution is sadly unavoidable. See restore_list() for
# further details.
#print "ZESHY_ARGS: ${(Qz)ZESHY_ARGS}"
source -- "${ZESHY_HOME_SCRIPT}" "${(Qz)ZESHY_ARGS}"

# --------------------( WASTELANDS                         )--------------------
#source -- "${ZESHY_HOME_SCRIPT}" "${(z)ZESHY_ARGS}"
    #FUXME: ZESHY_ARGS="${@}" is wrong; we need to export a proper list, here.
    #Verify that ".zshrc" actually imports a proper Zsh list.
