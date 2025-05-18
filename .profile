# shellcheck shell=bash
# shellcheck disable=SC1091

# region: Path
export PATH="${PATH}":"${HOME}"/.local/bin
# regionend

# region: Environment variables
SUDO_PROMPT="$(tput setab 1 setaf 7 bold)[sudo]$(tput sgr0) $(tput setaf 6)password for$(tput sgr0) $(tput setaf 5)%p$(tput sgr0): "
export SUDO_PROMPT
export ROC_ENABLE_PRE_VEGA=1

export LESSHISTFILE="${XDG_CONFIG_HOME}"/less/lesshst
export WGETRC="${XDG_CONFIG_HOME}"/wget/wgetrc
export INPUTRC="${XDG_CONFIG_HOME}"/readline/inputrc
export GNUPGHOME="${XDG_DATA_HOME}"/gnupg
# regionend

# region: Languages

# Java
export PATH="${PATH}":/usr/local/lib/java/jdk1.8.0_202/bin/
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}"/java

# Rust
export CARGO_HOME="${XDG_DATA_HOME}"/cargo

# GO
export GOBIN="${GOPATH}/bin"
export GOPATH="${HOME}/.local/share/go"

# JS/TS
if command -v ng &> /dev/null; then
  source <(ng completion script)
fi
# regionend

# region: Editors
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/nvim/init.lua" | source $MYVIMRC'
# regionend

# #region: NVM
export NVM_DIR="$HOME/.config/nvm"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}"/npm/npmrc
[ -s "${NVM_DIR}"/nvm.sh ] && \. "${NVM_DIR}"/nvm.sh
# #regionend

# region: BASHRC
source "${XDG_CONFIG_HOME}"/bash/bashrc
# regionend

# region: SESSION
de="hyprland" # Desktop Environment
if [[ "$(tty)" = "/dev/tty1" ]] && ! pgrep "${de}" > /dev/null; then
  case "${de,,}" in
    'qtile')
      "${XDG_CONFIG_HOME}"/qtile/init.sh
      ;;
    'hyprland')
      Hyprland
      ;;
    *)
      printf "\nSession '%s' not found!" "${de}"
      ;;
  esac
fi
# regionend

unset -v de
