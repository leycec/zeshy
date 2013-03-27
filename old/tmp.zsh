#!/usr/bin/env zsh
zmodload zsh/pcre
zmodload -F zsh/stat b:zstat
setopt extended_glob no_unset rc_quotes rematch_pcre
autoload throw catch

function die() {
    print "${*}" 1>&2
    throw zeshy_exception
}

#local -x y='999ou'; print "y: $(y='hmmm'; print $y)"; print "y: $y"
#readlink
#ls --full-time /dev/fd/1
#ls --full-time /dev/fd/1

#local hmm="ok, hm, ya"
#print ${hmm//[[:space:]]#,[[:space:]]#/,}
#[[ hmm =~ ^(hmm)$ ]] && print ok
#local args='integer siphon="ym", character funnel'
#local regex_arg='[,]+'
#local regex_args='^('${regex_arg}',\s*)*('${regex_arg}')(,\s*)?$'

#local args='(integer siphon="y,m", character funnel, boolean testm="ugh,)")'
#local regex_arg='([-_[:alnum:]]++)\s++([-_[:alnum:]]++)(?|(?:\s*+=\s*+"([^"]*+)")?|())'
#local regex_args='^\((?:'${regex_arg}',\s*+)*'${regex_arg}'(?:,\s*+)?\)$'

#typeset -gxA match
#[[ 'Mon' =~ '(?<DN>Mon|Fri|Sun)' ]] && {
#    for match_key (${(k)match}) {
#        print "match ${match_key}: ${match[${match_key}]}"
#    }
#    print "match DN: ${match[DN]}"
#}
#print
#local regex_arg_value_uncaptured='\s*+=\s*+"(?:\"|[^"])*"'
#local             regex_args='^\((?:'${regex_arg}${regex_comma}')*'${regex_arg}')(?:'${regex_comma}')?\)()$'
#local regex_arg_value_uncaptured='\s*+=\s*+(?:'"'(?:''|[^'])*'"')'
#local regex_arg_value_uncaptured='\s*+=\s*+(?:"((?:\\"|$\((?-1)\)|[^"])*)"|'"'(?:''|[^'])*'"'|)'
#local regex_asciidoc_cross_reference='(.*?)(?:$\{('${regex_ident}')\}|(?:(alias|function):)?('${regex_ident}')\(\))'

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
#
# Note this is *OVERKILL* for every other list. For every other list, after
# matching the entire list as a string simply compact delimiters down via
#      string_list="${string_list//[[:space:]]#,[[:space:]]#/,}"
# and then simply split such string on commas with
#      list values; list=( "${(s:,:)string_list}" )
# Very efficient. No need for manual iteration, unlike here. The above approach
# doesn't work here, of course, due to the possibility of quote-embedded commas.
#
# Note also that we *MUST* segregate the parsing of documentation from the
# handling of parsed data structures. We've accomplished this nicely here via
# data structures; just make sure we do so elsewhere. The idea is to handle such
# data structures after parsing in a manner corresponding to output requirements
# (e.g., ANSI, PDF, HTML). Note that newlines must somehow be preserved when
# outputting to terminals; this probably isn't *TOO* hard. Or...maybe it is. *sigh*
# Hmm. We want to preserve *ALL* whitespace when outputting to terminals, actually.
# That, or we need to handle wrapping manually (which might be a better idea, really).
# The wrapping rules should be pretty deterministic, so, heck, why not? The alternative
# (preserving whitespace) is a wicked problem, and I really can't be bothered.

#local documentation='grea_ter_men(integer siphon = ''y,m'', float funnel=3.1, integer system=-42, character awry, boolean testm="ugh,)")'
#local documentation='<grea_ter, men>[args: (integer siphon = ''y,m'', float funnel=3.1, integer system=-42, character awry, boolean testm="ugh,)]")]'
#local documentation='<grea_ter, men>[args: void]'
#local documentation='<grea_ter, men>[args: (integer siphon = ''y,m'', float funnel=3.1, integer system=-42, character awry, boolean testm="ugh,)"), stdin: void]'
#local documentation='<grea_ter, men>[args: (integer siphon = ''y,m'', float funnel=3.1, integer system=-42, character awry, boolean testm="ugh,)"), stdin: string input="ok]"]'
#local documentation='{globbable,} void <grea_ter, men,>[args: (integer siphon = ''y,m'', float funnel=3.1, integer system=-42, character awry, boolean testm="ugh,)"), stdin: (list list_name, string input="ok]")]'
#local documentation='{globbable,} character <grea_ter, men,>[args: (integer siphon = ''y,m'', float funnel=3.1, integer system=-42, character awry, boolean testm="ugh,)"), stdin: (list list_name, string input="ok]")]'
#local documentation='{globbable,} [stderr: character, status: integer] <grea_ter, men,>[args: (integer siphon = ''y,m'', float funnel=3.1, integer system=-42, character awry, boolean testm="ugh,)"), stdin: (list list_name, string input="ok]")] Yumyum.'
local documentation='<globbable,indefatiguable,execrable,variform,indecipherable,unmentionable,witty,erudite,  > [stderr: character, status: integer] {grea_ter, "men, womb",  }[args: (integer siphon = ''y,m'', float funnel=3.1, integer system=-42, character awry, boolean testm="ugh,)"), stdin: (list list_name, string input="ok]")] Yumyum. quite_interesting() oh how it ${bleeds_uhm}; le ende.

.test_em()
----------
my hel_lo() darling
----------
Yumyum ok_ok() hmmm.'

#FIXME: Shift everything below into a new
#parse_runnable_documentation_and_run_command() or
#run_command_after_matching_runnable_documentation() function. Yes, I rather
#prefer the latter, which integrates sensibly with other run_command_*()
#functions. Note that the AsciiDoc-specific logic needs to be shared with a similar
#run_command_after_matching_global_documentation(); hence, shift such logic into a
#separate match_documentation_description() function.
#FIXME: Suffix all regex variables capturing at least one match group with
#"_grouped", for consistency.

# zsh identifier (i.e., variable name).
local regex_ident='[-_[:alnum:]]++'

# Comma preceded and followed by optional whitespace.
local regex_comma='\s*+,\s*+'

# Function attributes. Zeshy currently prohibits single- and double-quoted
# attribute names, thus simplifying matching.
local regex_attrs='(?:<\s*+([^>]*+)>\s++)?'

# Function return types. Zeshy currently prohibits single- and double-quoted
# return types, thus simplifying matching.
#local regex_return_type=${regex_ident}
local regex_return_channel_grouped='('${regex_ident}')\s*+:\s*+('${regex_ident}')'
local                    regex_return_type=${regex_ident}
local regex_return_type_grouped='(?:void|('${regex_ident}'))'
local         regex_return_channels='\[\s*+[^]]*+\]'
local regex_return_channels_grouped='\[\s*+([^]]*+)\]'
local regex_return_type_or_channels='(?:'${regex_return_type}'|'${regex_return_channels}')\s++'
local regex_return_type_or_channels_grouped='(?:'${regex_return_type_grouped}'|'${regex_return_channels_grouped}')\s++'

# Function names. Since zsh permits single- and double-quoted function names,
# matching requires more than class negation.
local regex_name_unquoted=${regex_ident}
local regex_name_double_quoted='"(?:\\"|[^"])*"'
local regex_name_single_quoted="'(?:''|[^'])*'"
local regex_name_content=${regex_name_unquoted}'|'${regex_name_double_quoted}'|'${regex_name_single_quoted}
local       regex_name='(?:'${regex_name_content}')'
local regex_name_grouped='('${regex_name_content}')'
#local regex_name_list='\{\s*+([^}]*?)(?:'${regex_comma}')?\}'
local regex_names='\{\s*+((?:'${regex_name}${regex_comma}')*'${regex_name}')(?:'${regex_comma}')?\s*+\}'
local regex_name_or_names='(?:('${regex_name}')|'${regex_names}')\s*+'

# Function arguments.
local regex_arg_value_double_quoted='"(?:\\"|$\([^)]*+\)|[^"])*"'
local regex_arg_value_single_quoted=${regex_name_single_quoted}
local regex_arg_value_number='-?\d++\.\d++|-?\d++'
local regex_arg_value_content=${regex_arg_value_double_quoted}'|'${regex_arg_value_single_quoted}'|'${regex_arg_value_number}
local regex_arg_value_equals='\s*+=\s*+'
local regex_arg_value_grouped=${regex_arg_value_equals}'('${regex_arg_value_content}')'
local         regex_arg_value=${regex_arg_value_equals}'(?:'${regex_arg_value_content}')'
local regex_arg_grouped='('${regex_ident}')\s++('${regex_ident}')(?:'${regex_arg_value_grouped}')?'
local            regex_arg=${regex_ident}'\s++'${regex_ident}'(?:'${regex_arg_value}')?'
local regex_args_list_grouped='((?:'${regex_arg}${regex_comma}')*'${regex_arg}')(?:'${regex_comma}')?'
local          regex_args_list='(?:'${regex_arg}${regex_comma}')*'${regex_arg}'(?:'${regex_comma}')?'
local regex_args_grouped='\(\s*+(?:void|'${regex_args_list_grouped}')?\s*+\)'
local         regex_args='\(\s*+(?:void|'${regex_args_list}')?\s*+\)'
local regex_arg_channel_grouped='('${regex_ident}')\s*+:\s*+(?:(void|'${regex_arg}')|('${regex_args}'))'
local            regex_arg_channel=${regex_ident}'\s*+:\s*+(?:void|'${regex_arg}'|'${regex_args}')'
local regex_arg_channels='\[\s*+((?:'${regex_arg_channel}${regex_comma}')*'${regex_arg_channel}')(?:'${regex_comma}')?\s*+\]'
local regex_args_or_channels_grouped='(?:'${regex_args_grouped}'|'${regex_arg_channels}')'

# Function description. Ignore cross-references embedded in the following
# AsciiDoc-specific passthrough syntactic constructs, which AsciiDoc and hence
# Zeshy ignores for parsing purposes:
#
# * "`"-delimited passthrough quotes.
# * "pass:["- and "]"-delimited passthrough macros.
# * "+++"-delimited passthrough macros.
# * "$$"-delimited passthrough macros.
# * "\n----"-delimited listing blocks.
# * "\n...."-delimited literal blocks.
# * "\n////"-delimited comment blocks.
# * "\n++++"-delimited passthrough blocks.
# * "\n[literal]"-prefixed literal paragraphs.
# * "\n "- and "\n\t"-prefixed literal lines.
#
# Ignore cross-references embedded in the following AsciiDoc-specific anchored
# syntactic constructs, which AsciiDoc anchors for subsequent cross-referencing
# and hence should not themselves contain cross-references:
#
# * "\n."-prefixed block titles.
local regex_asciidoc_quote_backtick='\b`\N*?`\b'
local regex_asciidoc_macro_pass='pass:\[(?:\\\]|\N)*?\]'
local regex_asciidoc_macro_plus='\+\+\+\N*?\+\+\+'
local regex_asciidoc_macro_dollar='\$\$\N*?\$\$'
local regex_asciidoc_block_listing='-{4,}+\n.*?\n-{4,}+'
local regex_asciidoc_block_literal='\.{4,}+\n.*?\n\.{4,}+'
local regex_asciidoc_block_comment='/{4,}+\n.*?\n/{4,}+'
local regex_asciidoc_block_pass='\+{4,}+\n.*?\n\+{4,}+'
local regex_asciidoc_block_title_or_line_literal='(?:\.|[ \t]++)\N+'
local regex_asciidoc_paragraph_literal='^\[literal\]\n.*?(?:\n\n|\Z)'
local regex_asciidoc_cross_reference='((?:'${regex_asciidoc_quote_backtick}'|\b(?:'${regex_asciidoc_macro_pass}'|'${regex_asciidoc_macro_plus}'|'${regex_asciidoc_macro_dollar}')\b|^(?:'${regex_asciidoc_block_listing}'|'${regex_asciidoc_block_literal}'|'${regex_asciidoc_block_comment}'|'${regex_asciidoc_block_pass}'|'${regex_asciidoc_block_title_or_line_literal}')$|'${regex_asciidoc_paragraph_literal}'|.)*?)(\$\{'${regex_ident}'\}|(?:(alias|function):)?'${regex_ident}'\(\))'
local regex_asciidoc_suffix='(.*)'
local regex_asciidoc='\s*+(.*)'

# PCRE matching the beginning of `zeshy` function documentation. Dismantled,
# this is:
#
# * "(?s)", inducing '.' to match all characters including newline.
local ZESHY_DOCUMENTATION_PCRE_START='(?s)^\s*+'

# PCRE matching all semantic substrings (e.g., arguments, attributes, names)
# from `zeshy` documentation consisting of a `zeshy` function prototype and
# AsciiDoc description. Dismantled, this is:
#
# * "(?s)", inducing '.' to match all characters including newline.
local regex_documentation=${ZESHY_DOCUMENTATION_PCRE_START}${regex_attrs}${regex_return_type_or_channels_grouped}${regex_name_or_names}${regex_args_or_channels_grouped}${regex_asciidoc}'()$'

# PCRE matching all function attributes and names declared by a `zeshy` function
# prototype. Dismantled, this is:
#
# * "(?s)", inducing '.' to match all characters including newline.
local ZESHY_DOCUMENTATION_PCRE_ATTRIBUTES_AND_NAMES=${ZESHY_DOCUMENTATION_PCRE_START}${regex_attrs}${regex_return_type_or_channels}${regex_name_or_names}

print -r "documentation: ${documentation}"
print -r "regex_documentation: ${regex_documentation}"
print -r "ZESHY_DOCUMENTATION_PCRE_ATTRIBUTES_AND_NAMES: ${ZESHY_DOCUMENTATION_PCRE_ATTRIBUTES_AND_NAMES}"

# Map from machine-readable match index to human-readable match name. This is
# merely a convenience for improving code readability and maintainability.
local -a match_index_to_name; match_index_to_name=(
    'attrs'
    'return_type'
    'return_channels'
    'name'
    'names'
    'args'
    'arg_channels'
    'asciidoc'
    'placeholder'
)

# Map from human-readable match name to matched substring.
local -A match_name_to_match

# List of function attributes.
local -a attrs

# Map of function return channels. Each channel comprises one key-value pair of
# such map. Each key of such pair signifies the channel name (e.g., "stdout")
# and each value of such pair the type such channel returns (e.g., "integer").
#local -A return_channel

# List of function names.
local -a names

# List of function arguments. Each argument comprises three elements of such
# list (in order): argument type, name, and optional default value (reducing to
# the empty string if no such value was declared).
local -a args

# List of function standard input, in the same format as ${args}.
local -a stdin

# List of function AsciiDoc. Each odd element of such list signifies a string of
# unedited AsciiDoc and each even element a cross-reference to another Zeshy
# alias, function, or global to be converted into an AsciiDoc internal reference.
local -a asciidoc

# Name of the local variable to copy the current return channel type into (e.g.,
# "string_stdout", "string_stderr").
local string_return_channel_name

# Name of the local variable to copy the current argument channel into (e.g.,
# "string_args", "string_stdin").
local string_arg_channel_name

# Function attributes.
local string_attrs

# Function return type, if returning only a single type.
local string_return_type

# Function return channels, if returning more than one type.
local string_return_channels

# Function standard output.
local string_stdout

# Function standard error.
local string_stderr

# Function exit status.
local string_status

# Function names.
local string_names

# Function argument channels.
local string_arg_channels

# Function arguments.
local string_args

# Function standard input.
local string_stdin

# Function AsciiDoc description.
local string_asciidoc

# Previously matched indices, required for iterating matches.
local ZPCRE_OP='0 0'

# Parse the last argument and capture the string of all arguments preceding
# such argument, to be parsed iteratively below.
[[ "${documentation}" =~ ${~regex_documentation} ]] && {
    # Initialize the map from human-readable match name to matched substring.
    for ((match_index=1; match_index <= ${#match}; ++match_index)) {
        match_name_to_match[${match_index_to_name[${match_index}]}]="${match[${match_index}]}"
    }
    for match_name (${(k)match_name_to_match}) {
        print "match ${match_name}: ${match_name_to_match[${match_name}]}"
    }

    # If such function has attributes, match such attributes.
    string_attrs="${match_name_to_match[attrs]}"
    if [[ -n "${string_attrs}" ]] {
        # Split such attributes on commas after eliminating:
        #
        # * Optional whitespace surrounding commas (e.g., from " , " to ",").
        # * Optional trailing commas and/or whitespace.
        attrs=(
            "${(s:,:)${string_attrs//[[:space:]]#,[[:space:]]#/,}%%[[:space:]]#,#[[:space:]]#}"
        )
    }

    # If such function returns only a single type, record such type under
    # default return channel "stdout".
    string_stdout="${match_name_to_match[return_type]}"
    string_stderr=''
    string_status=''

    # If such function returns multiple types, record such types.
    string_return_channels="${match_name_to_match[return_channels]}"
    if [[ -n "${string_return_channels}" ]] {
        # Prepare to iteratively match each return channel.
        pcre_compile -- ${regex_return_channel_grouped}'(?:'${regex_comma}')?'
        pcre_study

        # Iteratively match each return channel name and list. For efficiency,
        # index matches with hardcoded indices.
        ZPCRE_OP='0 0'
        while {
            pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${string_return_channels}" } {
            # Identify the local variable to copy the current argument channel
            # into. If the local variable does not exist, throw an exception.
            string_return_channel_name="string_${match[1]}"
            [[ -n "${(P)string_return_channel_name+x}" ]] ||
                die "return channel \"${match[1]}\" unrecognized"

            : ${(P)string_return_channel_name::=${match[2]}}
        }
    }

    # If such function has only a single name, match such name.
    if [[ -n    "${match_name_to_match[name]}" ]] {
        names=( "${match_name_to_match[name]}" )
    # Else, such function has multiple names. Since single- and double-quoted
    # function names may contain commas, such names cannot be split on commas as
    # with function attributes above. Rather, match such names with iteration.
    } else {
        # Get such names as a string.
        string_names="${match_name_to_match[names]}"

        # Prepare to iteratively match each such name.
        pcre_compile -- ${regex_name_grouped}'(?:'${regex_comma}')?'
        pcre_study

        # Iteratively match. For efficiency, use hard-coded indices.
        ZPCRE_OP='0 0'
        while { pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${string_names}" } {
            names+="${match[1]}"
        }
    }

    print "names: ${names[@]}"

    # If such function accepts only a single argument list, record such list
    # under default argument channel "args".
    string_args="${match_name_to_match[args]}"
    string_stdin=''

    # If at least one argument channel was declared, record such channel.
    string_arg_channels="${match_name_to_match[arg_channels]}"
    if [[ -n "${string_arg_channels}" ]] {
        print "arg channels: ${string_arg_channels}"
        # Prepare to iteratively match each argument channel.
        pcre_compile -- ${regex_arg_channel_grouped}'(?:'${regex_comma}')?'
        pcre_study

        # Iteratively match each argument channel name and list. For efficiency,
        # index matches with hardcoded indices.
        ZPCRE_OP='0 0'
        while { pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${string_arg_channels}" } {
#           print "arg channel name: ${match[1]}\narg channel arg: ${match[2]}\narg channel args: ${match[3]}\nzpcre op: ${ZPCRE_OP}"
            # Identify the local variable to copy the current argument channel
            # into. If the local variable does not exist, throw an exception.
            string_arg_channel_name="string_${match[1]}"
            [[ -n "${(P)string_arg_channel_name+x}" ]] ||
                die "argument channel \"${match[1]}\" unrecognized"

            # If such argument channel accepts only a single argument,
            # centralize parse logic by converting to an argument list.
            if [[ -n "${match[2]}" ]] {
                : ${(P)string_arg_channel_name::=(${match[2]})}
            # Else, such argument channel accepts an argument list. Copy such
            # list as is.
            } else {
                : ${(P)string_arg_channel_name::=${match[3]}}
            }
        }
    }
#   print "args: ${string_args}\nstdin: ${string_stdin}"

    # If at least one passed argument was declared, record such argument.
    if [[ -n "${string_args}" ]] {
        # Prepare to iteratively match each argument followed by a placeholder.
        pcre_compile -- ${regex_arg_grouped}'(?:'${regex_comma}')?()'
        pcre_study

        # Iteratively match each argument type, name, and default value. For
        # efficiency, index matches with hardcoded indices.
        ZPCRE_OP='0 0'
        while { pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${string_args}" } {
            args+=( "${match[1]}" "${match[2]}" "${match[3]}" )
        }
    # Else, no passed arguments are accepted. Clear such list.
    } else {
        args=()
    }

    # If at least one standard input argument was declared, record such input.
    if [[ -n "${string_stdin}" ]] {
        # Prepare to iteratively match each argument followed by a placeholder.
        pcre_compile -- ${regex_arg_grouped}'(?:'${regex_comma}')?()'
        pcre_study

        # Iteratively match each argument type, name, and default value. For
        # efficiency, index matches with hardcoded indices.
        ZPCRE_OP='0 0'
        while { pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${string_stdin}" } {
            stdin+=( "${match[1]}" "${match[2]}" "${match[3]}" )
        }
    # Else, no standard input arguments are accepted. Clear such list.
    } else {
        stdin=()
    }

    # Record such AsciiDoc description stripped of optional trailing whitespace.
    string_asciidoc="${match_name_to_match[asciidoc]%%[[:space:]]##}"

    # Prepare to iteratively match each cross-reference in such description.
    # Dismantled, this is:
    #
    # * "-m", inducing ^ and $ to match newlines as well as the string start and
    #   end respectively.
    # * "-s", inducing . to match all characters including newline.
    pcre_compile -ms -- ${regex_asciidoc_cross_reference}
    pcre_study

    # Iteratively match each AsciiDoc-specific substring and Zeshy-specific
    # cross-reference. For efficiency, index matches with hardcoded indices.
    ZPCRE_OP='0 0'
    while { pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${string_asciidoc}" } {
        if [[ -n "${match[2]}" ]] {
            asciidoc+=( "${match[1]}" "${match[2]}" )
        } else {
            asciidoc+=( "${match[1]}" )
        }
    }

    # Match the last AsciiDoc-specific substring following the last Zeshy-
    # specific cross-reference.
    pcre_compile -- ${regex_asciidoc_suffix}
    pcre_study
    pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${string_asciidoc}"
    asciidoc+=( "${match[1]}" )

    # At this point, ${args} and ${args_last} contain the desired strings.
    # Great!
#   print "args: ${args[@]}"
#   print "names: ${names[@]}"
    print "------------"
    for ((match_index=1; match_index <= ${#attrs}; ++match_index)) {
        print "attr ${match_index}: ${attrs[${match_index}]}"
    }
    print "stdout: ${string_stdout}"
    print "stderr: ${string_stderr}"
    print "status: ${string_status}"
    for ((match_index=1; match_index <= ${#names}; ++match_index)) {
        print "name ${match_index}: ${names[${match_index}]}"
    }
    for ((match_index=1; match_index <= ${#args}; ++match_index)) {
        print "arg ${match_index}: ${args[${match_index}]}"
    }
    for ((match_index=1; match_index <= ${#stdin}; ++match_index)) {
        print "stdin ${match_index}: ${stdin[${match_index}]}"
    }
    for ((match_index=1; match_index <= ${#asciidoc}; ++match_index)) {
        print "asciidoc ${match_index}: ${asciidoc[${match_index}]}"
    }
}

# Maximum line length.
integer width=80

# Output string in AsciiDoc format.
local output

# Current substring to be suffixed to the output string in AsciiDoc format.
local output_suffix

# Current line of the output string in plaintext format.
local line

# Current substring to be suffixed to the current line of the output string in
# plaintext format.
local line_suffix

#FIXME: Rather than excessively repeating ourselves, the following code should
#also apply to the list of function names. We should probably encapsulate this
#code... or perhaps not? Can we really guarantee that *NOTHING* in such code
#changes between attributes and names? Probably easier for now just to repeat
#ourselves. *sigh*

output+='{'
line+='{'
integer attrs_size=${#attrs}

for ((attrs_index=1; attrs_index <= attrs_size; ++attrs_index)) {
    # Current element in both AsciiDoc and plaintext format.
    output_suffix="${attrs[attrs_index]}"
    line_suffix="${attrs[attrs_index]}"

    # If such element is not the last element of its list, suffix such element
    # with a comma.
    (( attrs_index < attrs_size )) && {
        output_suffix+=', '
        line_suffix+=', '
    }

    # If such element fits on the current line, suffix such line with such
    # element.
#   print "line length: ${#:-${line}${line_suffix}}"
    if (( ${#:-${line}${line_suffix}} <= width )) {
        output+="${output_suffix}"
        line+="${line_suffix}"
    # Else, begin a new line with such element.
    } else {
#       local digits="0123456789"
#       print "line:\n\n${digits}${digits}${digits}${digits}${digits}${digits}${digits}${digits}\n${line}"
        output+="\n ${output_suffix}"
        line="${line_suffix}"
    }
}

# Closing list delimiter in both AsciiDoc and plaintext format.
output_suffix='}'
line_suffix='}'

# If such delimiter fits on the current line, suffix such line with such
# delimiter.
if (( ${#:-${line}${line_suffix}} <= width )) {
    output+="${output_suffix}"
    line+="${line_suffix}"
# Else, begin a new line with such delimiter.
} else {
    output+="\n ${output_suffix}"
    line="${line_suffix}"
}

# Embed the AsciiDoc function prototype in a listing block to avoid treating
# prototype characters as AsciiDoc.
output="
-----------------------------------------
${output}
-----------------------------------------

${asciidoc[*]}"

print "prettified:${output}"

print "=================================="

if [[ "${documentation}" =~ ${~ZESHY_DOCUMENTATION_PCRE_ATTRIBUTES_AND_NAMES} ]] {
    for ((match_index=1; match_index <= ${#match}; ++match_index)) {
        print "match ${match_index}: ${match[${match_index}]}"
    }

    # If such function has attributes, match such attributes.
    if [[ -n "${match[1]}" ]] {
        # Split such attributes on commas after eliminating:
        #
        # * Optional whitespace surrounding commas (e.g., from " , " to ",").
        # * Optional trailing commas and/or whitespace.
        attrs=(
            "${(s:,:)${match[1]//[[:space:]]#,[[:space:]]#/,}%%[[:space:]]#,#[[:space:]]#}"
        )
    }

    # If such function has only a single name, match such name.
    if [[ -n    "${match[2]}" ]] {
        names=( "${match[2]}" )
    # Else, such function has multiple names. Since single- and double-quoted
    # function names may contain commas, such names cannot be split on commas as
    # with function attributes above. Rather, match such names with iteration.
    } else {
        # Clear such list.
        names=()

        # Get such names as a string. Since iteration overwrites list global
        # ${match}, copy such string before overwriting it below.
        string_names="${match[3]}"

        # Prepare to iteratively match each such name.
        pcre_compile -- ${regex_name_grouped}'(?:'${regex_comma}')?'
        pcre_study

        # Iteratively match. For efficiency, use hard-coded indices.
        ZPCRE_OP='0 0'
        while { pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${string_names}" } {
            names+="${match[1]}"
        }
    }

    for ((match_index=1; match_index <= ${#attrs}; ++match_index)) {
        print "attr ${match_index}: ${attrs[${match_index}]}"
    }
    for ((match_index=1; match_index <= ${#names}; ++match_index)) {
        print "name ${match_index}: ${names[${match_index}]}"
    }
#   print "attrs: ${attrs[@]}"
#   print "names: ${names[@]}"
} else {
    #FIXME: Actually, only print the first line of such documentation. Also, use
    #a different color for such line; say, regular red or cyan?
    #FIXME: Actually, print as follows:
    #
    #* If such prototype contains a blank line (i.e., "\n\n\n"), print from the
    #  first line of such prototype up to the next line that comes first of
    #  either such blank line or 5. (This avoids inevitable problems with
    #  pathological documentation.)
    #* Else, print only the first line of such documentation. This is only an
    #  unlikely edge case, so it needn't be too fancy; pretty much everyone will
    #  follow zeshy precedent of a blank line, I reckon.
    print "function prototype invalid (see \"print_help declare_function\" for details):\n\t${documentation}" 1>&2
}

# List of all documentation matches, copied from list global ${match} to prevent
# overwriting when matching 
#local -a doc_match

        # Split such attributes on commas after eliminating optional whitespace
        # surrounding commas (e.g., from " , " to ","). Note that such PCRE
        # necessarily avoids matching optional trailing commas and/or
        # whitespace, unlike function attributes above.
#       names=(
#           "${(s:,:)match[3]//[[:space:]]#,[[:space:]]#/,}"
#           "${(s:,:)${match[3]//[[:space:]]#,[[:space:]]#/,}%%[[:space:]]#,#[[:space:]]#}"
#       )

# For efficiency, inline such implementation rather than call a function.
        #FUXME: Slightly out-of-date. See implementation below.
        # Eliminate optional whitespace surrounding commas (e.g., reducing all
        # substrings " , " to ",").
#       string_names="${match_name_to_match[names]//[[:space:]]#,[[:space:]]#/,}"
#       print -r "string_names: ${string_names}"

        # Split such string on commas.
#       names=( "${(s:,:)string_names}" )

        #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        #Copy all changes to such code to the similar block below.
        #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        # See the above block.

        #FUXME: This is useful enough to generalize into a function. I know, I
        #know: function overhead. But aliases really aren't powerful enough,
        #here. Note also that such function should be called below, and that the
        #implementation below appears to be insufficient. (Again, all the more
        #reason for a function.) Such function is unlikely to be generally
        #applicable. Or, perhaps it is? How about:
        #    void set_list_to_string_split_on_commas_sans_comma_spaces_or_suffix(
        #        string list_name, string text)
        #Verbose name, but it's the only thing that accurately describes what it
        #does. Again, it's generally useful enough to warrant such treatment.
        #Note that such function's implementation should inline all operations
        #for efficiency, as here.

#FUXME: Regex variables are really named the inverse of what we want; by
#default, regexes *SHOULD* capture groups. That's what regexes do, really. If
#you want the version of such regex *NOT* capturing groups, you should exert
#the effort of explicitly specifying that. In other words, suffix regex
#variables with "_ungrouped" rather than "_grouped".
# Output string in plaintext format.
#local plaintext

#arg_match_index_to_name=(
#    'type'
#    'name'
#    'value'
#    'placeholder'
#)

# Non-empty if the current element is not the first element of its list and
# thus will be prefixed with a comma.
#local is_prefixing_comma
#is_prefixing_comma=

#   for return_channel_name (${(k)return_channel}) {
#       print "return ${return_channel_name}: ${return_channel[${return_channel_name}]}"
#   }
    # Initialize each return channel with return type "void".
#   return_channel=(
#       'stdout' ''
#       'stderr' ''
#       'status' ''
#   )

    # If such function returns only a single type, record such type under the
    # default return channel "stdout".
#   string_return_type="${match_name_to_match[return_type]}"
#   if [[ -n "${string_return_type}" ]] {
#       return_channel[stdout]="${string_return_type}"
    # Else, such function returns multiple types. Split such string on commas and
    # record the resulting types.
#   } else {
#       string_return_channels="${match_name_to_match[return_channels]}"

        # Prepare to iteratively match each return channel.
#       pcre_compile -- ${regex_return_channel_grouped}'(?:'${regex_comma}')?'
#       pcre_study

        # Iteratively match each return channel name and list. For efficiency,
        # index matches with hardcoded indices.
#       ZPCRE_OP='0 0'
#       while { pcre_match -b -n ${ZPCRE_OP[(w)2]} -- "${string_return_channels}" } {
#           print "arg channel name: ${match[1]}\narg channel arg: ${match[2]}\narg channel args: ${match[3]}\nzpcre op: ${ZPCRE_OP}"
            # Identify the map key to copy the current return channel into. If no
            # such key exists, throw an exception.
#           string_return_channel_name="${match[1]}"
#           [[ -n "${return_channel[(ie)${string_return_channel_name}]-}" ]] ||
#               die "return channel \"${string_return_channel_name}\" unrecognized"

            # Record such type.
#           return_channel[${string_return_channel_name}]="${match[2]}"
#       }
#   }

    # Record the strings of arguments and standard input before argument channel
    # handling performed below overwrites such strings.
#   for ((match_index=1; match_index <= ${#match}; ++match_index)) {
#       print "match ${match_index}: ${match[${match_index}]}"
#   }

#function set_map_to_list_inverted() {
#    # Validate passed arguments.
#    (( # == 2 )) || die 'expected one map name and one list name'
#    local map_name__smtli="${1}"
#    local list_name__smtli="${2}"
#
#    # Set such map to such list inverted.
#    for ((list_index__smtli = 1;
#          list_index__smtli <= ${#${(@P)list_name__smtli}};
#          list_index__smtli++)) {
#        eval "${map_name__smtli}[\${${list_name__smtli}[${list_index__smtli}]}]=${list_index__smtli}"
#    }
#}

# Map from human-readable match name to machine-readable match index,
# programmatically constructed by inverting the prior map.
#local -A match_name_to_index
#set_map_to_list_inverted match_name_to_index match_index_to_name

#set_map_to_list_inverted arg_match_name_to_index arg_match_index_to_name
#for match_name (${(k)match_name_to_index}) {
#    print "match ${match_name}: ${match_name_to_index[${match_name}]}"
#}
        #FUXME: Actually, we probably want to do incremental matching here, as below.
        # Eliminate optional whitespace and trailing commas, as above.
#       string_attrs="${${string_attrs//[[:space:]]#,[[:space:]]#/,}%%[[:space:]]#,#[[:space:]]#}"

        # Split such string on commas.
#       attrs=( "${(s:,:)string_attrs}" )
# Function return types from standard output, standard error, and exit status.
#local string_stdout string_stderr string_status

    # Else, no argument channels are accepted. Clear the list of arguments and
    # standard input.
#   } else {
#       args=()
#       stdin=()
#   }

    # If accepting at least one argument, defer to argument channel logic below
    # by converting such match into a match of the argument channel "args:".
#   if [[ -n "${string_args}" ]] {
#       match[${match_name_to_index[arg_channels]}]="args: ${string_args}"
#   }

    #   local args_sans_last="${match[1]}"
    #   integer match_set_index=0

    #       print "match set ${match_set_index}:"
#           for ((match_index=1; match_index <= ${#match}; ++match_index)) {
    #           print "match ${match_index}: ${match[${match_index}]}"
#           }
    #       ((++match_set_index))

# String of argument channel-specific previously matched indices, required for
# iterating argument channel matches.
#local arg_channels_zpcre_op='0 0'

# String of argument list-specific previously matched indices, required for
# iterating argument list matches.
#local args_zpcre_op='0 0'

#for ((match_index = 1; match_index <= ${#match_index_to_name}; match_index++)) {
#    match_name_to_index[${match_index_to_name[${match_index}]}]=${match_index}
#}

        # Append this argument's type, name, and optional default value. Since
        # at most one of ${match[3,5]} contain such value, concatenating such
        # matches together provides such value regardless of which matched.
        # For efficiency, reference such matches with hard-coded indices.
#       args+=( "${match[1]}" "${match[2]}" "${match[3]}${match[4]}${match[5]}" )

# List of the last parsed argument.
#local -a args_last
#   [[ "${string_args}" =~ ${~regex_args} ]] && {
    # Record the last parsed argument before overwriting ${match} below.
#   args_last=( "${match[-4]}" "${match[-3]}" "${match[-2]}" )
#   print "match: ${match[1]}"

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
kththnth
``yum''
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

local -a tyme; tyme=( 888o mmm hhh 33 333 )
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

