#!/usr/bin/env zsh
zmodload zsh/pcre
setopt rematch_pcre
local hmm="ok, hm, ya"

print ${hmm//[[:space:]]#,[[:space:]]#/,}
#[[ hmm =~ ^(hmm)$ ]] && print ok
#local args='integer siphon="ym", character funnel'
#local regex_arg='[,]+'
#local regex_args='^('${regex_arg}',\s*)*('${regex_arg}')(,\s*)?$'

#local args='(integer siphon="y,m", character funnel, boolean testm="ugh,)")'
#local regex_arg='([-_[:alnum:]]++)\s++([-_[:alnum:]]++)(?|(?:\s*+=\s*+"([^"]*+)")?|())'
#local regex_args='^\((?:'${regex_arg}',\s*+)*'${regex_arg}'(?:,\s*+)?\)$'

# O.K.; this works. I have no idea how fast it is, of course... but then, we
# shouldn't really *NEED* this to be obscenely fast, because we only need this
# when converting documentation to some human-readable format, which really
# shouldn't happen terribly often.
#
# Note that the PCRE contains a placeholder empty match "()". This efficiently
# works around a subtle PCRE or zsh bug: all optional capture groups except the
# last are assigned an array value. The last such group if not matched, however,
# is assigned no array value. Adding a placeholder match forces such group to
# always be assigned an array value as well. *sigh*
#local argstring='(integer siphon, character funnel, boolean testm)'
local argstring='(integer siphon="y,m", character funnel, boolean testm="ugh,)")'
local regex_arg='([-_[:alnum:]]++)\s++([-_[:alnum:]]++)(?:\s*+=\s*+"([^"]*+)")?'
local regex_comma='\s*+,\s*+'
local regex_args='^\(((?:'${regex_arg}${regex_comma}')*)'${regex_arg}'(?:'${regex_comma}')?\)()$'

# List of parsed arguments, each argument comprising three elements of such
# list: the argument's type, name, and default value (or empty string if no
# such value).
local -a args

# List of the last parsed argument.
local -a args_last

# Parse the last argument and capture the string of all arguments preceding
# such argument, to be parsed iteratively below.
[[ "${argstring}" =~ ${~regex_args} ]] && {
    for ((match_index=1; match_index <= ${#match}; ++match_index)) {
        print "match ${match_index}: ${match[${match_index}]}"
    }

    # Record the last parsed argument before overwriting ${match} below.
    args_last=( "${match[-4]}" "${match[-3]}" "${match[-2]}" )

#   print "match: ${match[1]}"

    # Regex parsing a single argument followed by a similar placeholder group.
    pcre_compile "${regex_arg}${regex_comma}()"
    pcre_study

    # Iteratively parse all arguments preceding the last.
    local args_sans_last="${match[1]}"
    integer match_set_index=0
    local ZPCRE_OP='0 0'
    while { pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${args_sans_last}" } {
        print "match set ${match_set_index}:"
        for ((match_index=1; match_index <= ${#match}; ++match_index)) {
            print "match ${match_index}: ${match[${match_index}]}"
        }
        ((++match_set_index))

        # Record the current parsed argument before overwriting ${match} above.
        args+=( "${match[1]}" "${match[2]}" "${match[3]}" )
    }

    # At this point, ${args} and ${args_last} contain the desired strings.
    # Great!
    print "args: ${args[@]}"
    print "args (last): ${args_last[@]}"
    print "proof:"
    for ((match_index=1; match_index <= ${#args}; ++match_index)) {
        print "arg ${match_index}: ${args[${match_index}]}"
    }
}

#pcre_compile "${regex_args}"
#pcre_study

#integer match_set_index=0
#local ZPCRE_OP='0 0'
#while { pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${args}" } {
#    print "match set ${match_set_index}:"
#    for ((match_index=1; match_index <= ${#match}; ++match_index)) {
#        print "match ${match_index}: ${match[${match_index}]}"
#    }
#}

#[[ "${args}" -pcre-match ${~regex_args} ]] && {
#[[ "${args}" =~ ${~regex_args} ]] && {
#    for ((match_index=1; match_index <= ${#match}; ++match_index)) {
#        print "match ${match_index}: ${match[${match_index}]}"
#    }
#}
#local regex_arg='[[:alnum:]-_]+\s+[[:alnum:]-_]+'
# Notes:
# * We have to match "((?:\s*+=...)?)" to ensure we can distinguish between when
#   an optional default value was specified and when not. In the latter case,
#   this match group is empty; otherwise, non-empty. (Surprisingly difficult, eh?)
    # If the final argument has no default value, forcefully append such value.
    # Absurdly, PCRE guarantees this for all arguments except the last.
#   (( ${#match} == 8 )) || match+=

exit

local prototype; prototype="
{globbable} [stdout: boolean, stderr: character, status: true]
 <ruth, benedict>[args: (integer siphon, character funnel), stdin: string input]"

[[ "${prototype}" =~ ^(\{[^}]+\})?.* ]] and {
    print "match: ${match[1]}"
}

exit

function get_str() {
    print 'reading...'
#   while [[ -p 0 ]]; do
#       print 'stdin: '
#       read -e
#   done
    local line
    while { IFS= read -r line } {
        print "stdin: ${line}"
    }
#   while [[ -p 0 ]] {
#       print "stdin: $(< /dev/stdin)"
#   }
    print ' [ok]'
#   print "stdin: $(< /dev/stdin)"
}

{
    print '...'
    sleep 1
    print '...'
} | get_str
#} >&1 | get_str

{
    [[ -p /dev/stdin ]] && print 'ok'
    read -t 0 && print 'yo'
    local hmm
    hmm="$(< /dev/stdin)"
    print "hmm: $hmm"
    IFS='' read -r -d '' hmm
    print "hmm: $hmm"
    cat /dev/stdin | read -r -d '' hmm
    print "hmm: $hmm"
    print "cat:"
    cat /dev/stdin
} <<'________________<heredoc?>________________'
oeuoeu
``yum''
oeuoeu
________________<heredoc?>________________
#,,,,,,,,,,,,,,,,<heredoc!>,,,,,,,,,,,,,,,,
#________________/heredoc/________________
#----------------<heredoc>----------------
#----------------(heredoc)----------------
#--------------(heredocument)--------------
#<|----------------------------------------
#---------------------------------------XO
#o()xxxx[{::::::::::::::::::::::::::::::::>x

exit

#print "fpath:"
#print -rl -- "${fpath[@]}"
autoload throw catch

{
    throw test
    print $((rand49()))
} always {
    catch '*' && {
        print "caught ${CAUGHT}"
    }
}

setopt extended_glob
local glob="-[a-z]#h"
#(( ${@[(i)([^-]*|-[a-z]#[chilv][a-z]#|--(command=*|help|interactive|login|version))]} <= # )) || {
#(( ${@[(i)-[a-z]#[chilv][a-z]#]} <= # )) || {
#(( ${@[(i)${~glob}]} <= # )) || {
#(( ${@[(i)${~glob}]} <= # )) || {
(( ${@[(i)-[a-z]#h]} <= # )) || {
    print 'not passed nothin'
}

local -a m; m=( hmm okok )
[[ -n "${(P)m[2]+x}" ]] || print 'okok not declared'
local okok
[[ -n "${(P)m[2]+x}" ]] || print 'okok not declared'

function hokay() {
    hmm
    yum
}

function hmm() {
    function yum() {
        print 'indeed.'
    }
}

hokay

#FIXME: It doesn't particularly matter, but *WHY THE F^CK CAN'T WE CALL throw()*?
#It's a builtin function. This is ridiculous. Sess is outta here for the evening.
#throw m
#{
#    throw WackyException
#} always {
#}

{
    local hello
    set -- ${(z)"$(< /dev/stdin)"}
    print "one (inner): ${1}\ntwo (inner): ${2}"
    hello="${1}"
#   local -a __args__; __args__=( ${(z)"$(< /dev/stdin)"} )
#   local one="${__args__[1]}" two="${__args__[2]}"
#   print "one: ${one}\ntwo: ${two}"
} <<<'yum "how yai"'

print "hello: ${hello}"

#set -- $(< /dev/stdin)
#print "one (outer): ${1}\ntwo (outer): ${2}"

local -A mapi; mapi=( ooommm mm33 33w uzu )
(( ${+mapi[33w]} )) && print 'mapi!\n'

local -a tyme; tyme=( oeuo mmm hhh 33 333 )
tyme[-1]=()
print "tyme: ${tyme[@]}"
print "tyme size: ${#tyme}"
print "tyme: ${tyme[1,0]}"
print "tyme: ${tyme[0,-1]}"

[[ -o login ]] && print 'login!'
print "argv: ${argv[@]}"
print "0: ${0}"
print "1: ${1}"
print "PID: ${$}"
cat "/proc/${$}/cmdline"
print

(( $ == $ )) && print 'pid comparable'

