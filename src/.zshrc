#!/usr/bin/env zsh
# ====================[ .zshrc                             ]====================
#
# --------------------( LICENSE                            )--------------------
# Copyright 2007-2013 by Cecil Curry.
# See "COPYING" for additional details.
#
# --------------------( SYNOPSIS                           )--------------------
# Sourced by login zsh shells after sourcing ".zprofile" when run by "zeshy".
#print "[${0}] starting .zshrc (zeshy-specific)"

# ....................{ SANITY                             }....................
# If even one global referenced below was not previously defined by the caller,
# such caller is not the "zeshy" wrapper script, the only caller permitted to
# source this script. Print an error and return non-zero exit status.
(( ${+ZESHY_ARGS} + ${+ZESHY_HOME_SCRIPT} + ${+ZESHY_ZDOTDIR_USER} == 3 )) || {
    print 'zeshy: At least one of ${ZESHY_ARGS}, ${ZESHY_HOME_SCRIPT}, and/or'
    print 'zeshy: ${ZESHY_ZDOTDIR_USER} undefined.' 1>&2
    print 'zeshy: "'${0}'" not sourced by wrapper script "zeshy".' 1>&2
    return 1
}

# If the current's user ${ZDOTDIR} is zeshy's ${ZDOTDIR}, something has gone
# terribly awry. To avoid infinite recursion, print an error and return non-zero
# exit status.
if [[ "${ZESHY_ZDOTDIR_USER}" == "${ZDOTDIR}" ]] {
    print 'zeshy: User ${ZDOTDIR} is zeshy''s ${ZDOTDIR} "'${ZESHY_ZDOTDIR_USER}'".' 1>&2
    print 'zeshy: Prematurely terminating to avoid infinite recursion.' 1>&2
    return 1
}

# ....................{ MAIN                               }....................
# Absolute path of the current user's ".zshrc".
local zshrc_user_filename="${ZESHY_ZDOTDIR_USER}/.zshrc"

# Source such script, if found.
if [[ -f "${zshrc_user_filename}" ]] {
#   print "[${0}] sourcing user dotfile \"${zshrc_user_filename}\" from zeshy dotfile \"${0}\"..."
    source -- "${zshrc_user_filename}"
}

# Source the main zeshy script, thus loading zeshy. Convert the list of
# arguments previously passed to the "zeshy" wrapper script from a string back
# into its original list. Since strings but not lists cannot be inherited by
# subshells, such circumlocution is sadly unavoidable. See restore_list() for
# further details.
#print "[${0}] sourcing ${ZESHY_HOME_SCRIPT} ${(Qz)ZESHY_ARGS}"
#print "[${0}] ZESHY_ARGS=${ZESHY_ARGS}"
source -- "${ZESHY_HOME_SCRIPT}" "${(Qz)ZESHY_ARGS}"

# --------------------( WASTELANDS                         )--------------------
#   ZESHY_ZDOTDIR_USER="${HOME}"
#   print "${zshrc_filename}"(:A)
#   print "${0}"(:A)
#   local zshrc_user_filename; zeshy_filename="$(print -- "${0}"(:A))" &>/dev/null || {
#       print "zeshy: current script \"${0}\" not found" 1>&2
#       exit 1
#   }

    # If such script is *THIS* script, something has gone terribly awry. To
    # avoid infinite recursion, print an error and return non-zero exit status.
#   [[ "${zshrc_filename}"(:A) == "${0}"(:A) ]] && {

# If the absolute path of the main zeshy script was not previously defined, this
# script was probably not run by "zeshy". Throw an exception!
# If the list of previously passed arguments was not previously defined, this
# script was probably not run by "zeshy". Throw an exception!
#source -- "${ZESHY_HOME_SCRIPT}" "${(z)ZESHY_ARGS}"
    #FUXME: ZESHY_ARGS="${@}" is wrong; we need to export a proper list, here.
    #Verify that ".zshrc" actually imports a proper zsh list.
