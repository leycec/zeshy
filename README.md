zeshy
===========

_Zeshy_ :: high-level shell scripting lingua franca implemented in pure `zsh`

## Installation

### Gentoo

Gentoo effectively supports Zeshy out of the box. (Probably due to Zeshy's implementation by a Gentoo contributor. _Probably_.)

#### Install `layman`, the Gentoo overlay manager.

    emerge layman
    echo 'source /var/lib/layman/make.conf' >> /etc/make.conf

#### Add the `raiagent` overlay.

    layman -a raiagent
    layman -S

#### Unmask `zeshy`.

    echo ">=dev-zsh/zeshy-0.01" >> /etc/portage/package.accept_keywords

#### Install `zeshy`.

    emerge -av zeshy

### Non-Gentoo

For all other distributions, please consult your distribution's package manager.

## Synopsis

Zeshy is a high-level `zsh` framework packaging commonly useful aliases, functions, and variables into first-class components reusable for both interactive command-line sessions and programmatic third-party scripts.

`zsh` is arguably the most feature-rich of platform-portable, dynamically-typed, interpreted shell scripting languages. Unfortunately, such richness comes at profound cost: legibility. `zsh` trades syntactic conciseness for legibility, admitting such infamously illegible one-liners as:

    # List all subdirectories with at least two files prefixed by "index.".
    ls **/*(D/e:'l=($REPLY/index.*(N)); (( $#l >= 2 ))':)

Zeshy renders `zsh` accessible to lay users by wrapping inscrutable syntactic shell sugar with simplistic interfaces leveraging only common programming language idioms and syntax. Inspired by such industry-standard scripting languages as Python and Ruby, Zeshy hopes to demonstrate `zsh`'s broad applicability, extensibility, and usability.

`zsh` is more than merely impressive syntactic antics and flamboyantly obfuscatory jargon.

`zsh` is command-line expressivity. `zsh` is shell-scripting explosivity. `zsh` is blossoming into the mainstream. Join us and Zeshy as we zest the streaming script of shell software with festive newness. (Phew!)

## Dependencies

Zeshy depends only on `zsh` -- but dynamically detects and supports a variety of popular applications (e.g., `git`, `rsync`, `screen`, `tex`) and distributions (e.g., Gentoo) with runtime components.

## License

Zeshy adheres to a conventional GPLv3 license. See COPYING for details.
