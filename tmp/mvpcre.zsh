#!/usr/bin/env zsh
zmodload zsh/pcre
zmodload -F zsh/stat b:zstat
setopt extended_glob no_unset rc_quotes rematch_pcre
autoload throw catch

function die() {
    print "${*}" 1>&2
    throw zeshy_exception
}

mv-pcre -cr '________________<heredoc\?>________________' '-\\-' src
