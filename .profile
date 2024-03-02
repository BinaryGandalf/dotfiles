#!/usr/bin/sh

append_path() {
  case ":$PATH:" in
    *:"$1":*) ;;
    *) PATH="${PATH:+$PATH:}$1"
  esac
}

append_path $HOME/.local/bin

export TERMINAL=alacritty
export EDITOR=vim
export PAGER=less
export BROWSER=chromium

export HISTIGNORE="*sudo -S*:$HISTIGNORE"

alias ll="ls -lah --color=auto"
alias fd="fd -H"
alias rg="rg --hidden -L -S -g '!.git/'"

display() {
  case "$XDG_VTNR" in
  1) session=i3 ;;
  2) session=awesome ;;
  3) session=dwm ;;
  *) return ;;
  esac
  
  exec xinit $session
}

[[ -z "$DISPLAY" ]] && display
