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

# ....................{ MAIN                               }....................
#FIXME: O.K.; this is currently broken under my home setup. The reason is
#fairly subtle but simple: @{main} undefines all globals matching "ZESHY_"*
#*AFTER* wrapper script "bin/zeshy" sets such globals. Why does this
#unexpectedly occur? Because we currently source zeshy from "/etc/zsh/zshrc"
#and friends in our home setup, which *IS BLATANTLY WRONG.* It's time to fully
#embrace "zeshy" and switch from "zsh" to "zeshy-login" as our login shell;
#then, excise all mention of "zeshy" from "/etc/zshrc".
#
#Doing so *WILL* correct this issue by ensuring the following order of sourced
#scripts on running "zeshy":
#
#1. "bin/zeshy".
#2. "src/.zshrc" (i.e., this script).
#3. "src/main".
#
#Then edit "/etc/passwd" accordingly. See "bin/zeshy" for further details.

# If even one global referenced below was not previously defined by the caller,
# such caller cannot be the "zeshy" wrapper script, the only caller permitted
# to source this script. Print an error and return nonzero exit status.
(( ${+ZESHY_ARGS} + ${+ZESHY_MAIN_SCRIPT} == 2 )) || {
    # print "ZESHY_MAIN_SCRIPT: ${ZESHY_MAIN_SCRIPT}"
    print 'zeshy: ${ZESHY_ARGS} and/or ${ZESHY_MAIN_SCRIPT} undefined.'
    print 'zeshy: Script "'${0}'" not sourced by wrapper script "zeshy".'
    return 1
} 1>&2

# Source the main zeshy script, thus loading zeshy. Convert the list of
# arguments previously passed to the "zeshy" wrapper script from a string back
# into its original list. Since strings but not lists cannot be inherited by
# subshells, such circumlocution is sadly unavoidable. See restore_list() for
# further details.
#print "[${0}] sourcing ${ZESHY_MAIN_SCRIPT} ${(Qz)ZESHY_ARGS}"
#print "[${0}] ZESHY_ARGS=${ZESHY_ARGS}"
source -- "${ZESHY_MAIN_SCRIPT}" "${(Qz)ZESHY_ARGS}"

# --------------------( WASTELANDS                         )--------------------
# (( ${+ZESHY_ARGS} + ${+ZESHY_MAIN_SCRIPT} + ${+ZESHY_ZDOTDIR_USER} == 3 )) || {
#     # print "ZESHY_MAIN_SCRIPT: ${ZESHY_MAIN_SCRIPT}"
#     print 'zeshy: At least one of ${ZESHY_ARGS}, ${ZESHY_MAIN_SCRIPT}, and/or'
#     print 'zeshy: ${ZESHY_ZDOTDIR_USER} undefined.'
#     print 'zeshy: Script "'${0}'" not sourced by wrapper "zeshy".'
#     return 1
# } 1>&2
# 
# # If the current's user ${ZDOTDIR} is zeshy's ${ZDOTDIR}, something has gone
# # terribly awry. To avoid infinite recursion, print an error and return non-zero
# # exit status.
# if [[ "${ZESHY_ZDOTDIR_USER}" == "${ZDOTDIR}" ]] {
#     print 'zeshy: User ${ZDOTDIR} is zeshy''s ${ZDOTDIR} "'${ZESHY_ZDOTDIR_USER}'".'
#     print 'zeshy: Prematurely terminating to avoid infinite recursion.'
#     return 1
# } 1>&2
#
# # Absolute path of the current user's ".zshrc".
# local zshrc_user_filename="${ZESHY_ZDOTDIR_USER}/.zshrc"
# 
# # Source such script, if found.
# if [[ -f "${zshrc_user_filename}" ]] {
# #   print "[${0}] sourcing user dotfile \"${zshrc_user_filename}\" from zeshy dotfile \"${0}\"..."
#     source -- "${zshrc_user_filename}"
# }

#Of course, we haven't even created the "zeshy-local" symbolic link yet. So do
#so: e.g.,
#
#    >>> sudo ln -s /usr/local/bin/zeshy /usr/local/bin/zeshy-login

# (( ${+ZESHY_ARGS} + ${+ZESHY_MAIN_SCRIPT} + ${+ZESHY_ZDOTDIR_USER} == 3 )) || {
#     print 'zeshy: At least one of ${ZESHY_ARGS}, ${ZESHY_MAIN_SCRIPT}, and/or'
#     print 'zeshy: ${ZESHY_ZDOTDIR_USER} undefined.'

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
#source -- "${ZESHY_MAIN_SCRIPT}" "${(z)ZESHY_ARGS}"
    #FUXME: ZESHY_ARGS="${@}" is wrong; we need to export a proper list, here.
    #Verify that ".zshrc" actually imports a proper zsh list.
