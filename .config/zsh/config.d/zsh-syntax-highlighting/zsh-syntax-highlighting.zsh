# Cyberpunk Theme (for zsh-syntax-highlighting)
# Load before zsh-syntax-highlighting is activated.

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Comments / dim text
ZSH_HIGHLIGHT_STYLES[comment]='fg=#3b405c'

# Commands / executable names
ZSH_HIGHLIGHT_STYLES[alias]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[function]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[command]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#00ff9f,italic'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#00ff9f'

# Paths / options / substitutions
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#ff9f1c,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ff9f1c'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ff9f1c'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#ff2bd6'
ZSH_HIGHLIGHT_STYLES[path]='fg=#00f5ff,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#ff3b6b,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#00f5ff,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#ff3b6b,underline'

# Punctuation / delimiters
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ff3b6b'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#ff3b6b'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#ff3b6b'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#ff3b6b'

# Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#fcee09'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#fcee09'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#fcee09'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#ff5c8a'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#fcee09'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#ff5c8a'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#fcee09'

# Variables / generic args
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#ff5c8a'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#ff2bd6'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[default]='fg=#e6f7ff'
ZSH_HIGHLIGHT_STYLES[cursor]='fg=#e6f7ff'

# Errors
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff5c8a'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#ff5c8a'
