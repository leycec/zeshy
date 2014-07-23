#!/usr/bin/env zsh
# --------------------( LICENSE                            )--------------------
# Copyright 2007-2014 by Cecil Curry.
# See "LICENSE" for additional details.
#
# --------------------( SYNOPSIS                           )--------------------
# Sourced by login zsh shells after sourcing ".zprofile" when run by "zeshy".
#print "[${0}] starting .zshrc (zeshy-specific)"

# ....................{ OPTIONS                            }....................
# Enable shell strictness. See wrapper script "zeshy" for further details.
setopt err_return no_unset warn_create_global

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

#FIXME: Something odd going on here. The error below is output when loggin
#in as the superuser (e.g., via "su") *DESPITE* such login otherwise
#succeeding. What the heck?
#FIXME: Nevermind. This is a non-issue: it's due to root's login shell being
#"zsh" and the various hacks that stem from that. Since we've already engaged
#in kludging there, the solution is another kludge: manually set such string
#globals to the empty string in "/etc/zsh/zshrc". *sigh*

# If even one global referenced below was not previously defined by the caller,
# such caller cannot be the "zeshy" wrapper script, the only caller permitted
# to source this script. Print an error and return nonzero exit status.
(( ${+ZESHY_ARGS} + ${+ZESHY_MAIN_SCRIPT} == 2 )) || {
    # print "ZESHY_MAIN_SCRIPT: ${ZESHY_MAIN_SCRIPT}"
    print 'zeshy: ${ZESHY_ARGS} and/or ${ZESHY_MAIN_SCRIPT} undefined.'
    print 'zeshy: Script "'${0}'" not sourced by "zeshy" or "zeshy-login".'
    return 1
} 1>&2
#print "[${0}] sourcing ${ZESHY_MAIN_SCRIPT} ${(Qz)ZESHY_ARGS}"
#print "[${0}] ZESHY_ARGS=${ZESHY_ARGS}"

# Source zeshy's entry script immediately *BEFORE* printing the first command
# prompt for the current interactive shell. (This script is sourced only under
# interactive invocations of "zeshy" and "zeshy-login".)
#
# Such indirection ensures that the zeshy codebase will be loaded *AFTER* zsh
# startup, which appears to be the only means of enabling TRAPZERR() (i.e.,
# converting failure status to thrown exceptions) during zeshy startup.
# (Curiously, avoiding such indirection by sourcing such script directly here
# does *NOT* suffice to enable such trap handler during zeshy startup, despite
# such script clearly defining such function. We attribute this to an as-yet
# unidentified bug in which zsh enables trap handlers defined by startup
# dotfiles only *AFTER* sourcing all such dotfiles. Curiously, the same bug
# also extends to shell options "ERR_RETURN" and "ERR_EXIT".)
#
# Enabling such trap handler during (rather than after) zeshy startup (and
# hence such indirection) is essential to "inoculating" zeshy startup against
# unanticipated errors.
function precmd() {
    # Undefine such hook, preventing zsh from erroneously reloading zeshy on
    # subsequent command prompts.
    unfunction precmd

    # Source zeshy's entry script. Convert the list of arguments previously
    # passed to wrapper script "zeshy" from a flattened string back into the
    # original list. Since only scalars (and hence *NOT* lists) can be
    # inherited by child shells, such circumlocution is sadly unavoidable. See
    # restore_list() for further details.
    source -- "${ZESHY_MAIN_SCRIPT}" "${(Qz)ZESHY_ARGS}"
    # print "dir stack [main/after]: ${ZESHY_USER_DIR_STACK_FILE}"
    # typeset -g ZESHY_USER_DIR_STACK_FILE="${ZESHY_USER_CACHE_DIR}/dir_stack"
    # typeset -g Z="${ZESHY_USER_CACHE_DIR}/dir_stack"
}

# --------------------( WASTELANDS                         )--------------------
# , conditionally compiling and autoloading the
    # zeshy codebase into the current digest file
#FUXME: Fix documentation.

# if this script  merely defining TRAPZERR() in zeshy's entry script appears to be
# insufficient to actually enable such trap handler during zeshy startup.)

#FUXME: O.K.; this is currently broken under my home setup. The reason is
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

# source -- "${ZESHY_MAIN_SCRIPT}" "${(Qz)ZESHY_ARGS}"
# the main zeshy script, thus loading zeshy.
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
