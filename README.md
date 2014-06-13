zeshy
===========

`zeshy` is a **dynamic high-level shell scripting language** both implemented *and* interpreted in pure `zsh`.

## An Open Letter (to an Unlikely Readership)

**`zeshy` is currently in a non-compiling state** -- which is to say, broken.

Recent feature improvements to the core language (e.g., function prototype-driven programmatic code generation) have proven slippier to implement than initially surmised. Much, *much* slippier. (Think 80's-era ["Slippery When Wet"](https://www.youtube.com/watch?v=CXvN82-qSAc) slippier.)

Until such issues, regressions, unintended consequences, and code calamities have been resolved and the codebase concretely solidified, we *strongly* discourage installing, using, or otherwise mandhandling `zeshy`. It's simply unready.

Over three years, 600 commits, and endless all-nighters later, a first-draft implementation remains the loftiest, hallucinatorily inconceivablest ideal it ever was: pleasant enough in principle, but unabashedly, brashly buggered in practice.

Yet, for all its doleful inadequacies, `zeshy` *has* begun receiving attention. A smattering of stars here; a flurry of forks there. For these and every major and minor blessing by the open-source community, I ([leycec](https://github.com/leycec)) remain gratefully humbled.

Thank you.

  And may this journey's end arrive.

## Synopsis

`zeshy` is a:

* **Dynamically recompiled shell scripting language** both implemented *and* interpreted in pure `zsh`.
* Drop-in replacement for `zsh` with out-of-the-box support for:
  * First- and third-party shell, prompt, and function themes and plugins.
  * Genuine exception handling.
  * Extensive runtime help.
  * Cross-platform portable API.

## Installation

### Gentoo

Gentoo effectively supports `zeshy` out of the box. (Probably due to `zeshy`\'s implementation by a Gentoo contributor. _Probably_.)

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

`zeshy` is a high-level `zsh` framework packaging commonly useful aliases, functions, and variables into first-class components reusable for both interactive command-line sessions and programmatic third-party scripts.

`zsh` is arguably the most feature-rich of platform-portable, dynamically-typed, interpreted shell scripting languages. Unfortunately, such richness comes at profound cost: legibility. `zsh` trades syntactic conciseness for legibility, admitting such infamously illegible one-liners as:

    # List all subdirectories with at least two files prefixed by "index.".
    ls **/*(D/e:'l=($REPLY/index.*(N)); (( $#l >= 2 ))':)

`zeshy` renders `zsh` accessible to lay users by wrapping inscrutable syntactic shell sugar with simplistic interfaces leveraging only common programming language idioms and syntax. Inspired by such industry-standard scripting languages as Python and Ruby, `zeshy` hopes to demonstrate `zsh`'s broad applicability, extensibility, and usability.

`zsh` is more than merely impressive syntactic antics and flamboyantly obfuscatory jargon.

`zsh` is command-line expressivity. `zsh` is shell-scripting explosivity. `zsh` is blossoming into the mainstream. Join us and `zeshy` as we zest the streaming script of shell software with festive newness. (Phew!)

## Dependencies

`zeshy` requires only `zsh` as a runtime dependency -- but dynamically detects and supports a variety of optional popular applications (e.g., `git`, `rsync`, `screen`, `tex`) and distributions (e.g., Gentoo) during runtime execution.

## License

`zeshy` adheres to a conventional [GPLv3 license](http://gplv3.fsf.org). See COPYING for details.
