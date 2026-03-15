# zmodload zsh/zprof # to debug loading time

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install

# Fast compinit setup
autoload -Uz compinit

if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m+24) ]]; then
  compinit
else
  compinit -C  # Skip compaudit completely if recent cache exists
fi

# # ensure proper Wayland socket setup
# if [ -z "$WAYLAND_DISPLAY" ] || [ ! -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ]; then
#   export WAYLAND_DISPLAY=$(basename "$(ls -t $XDG_RUNTIME_DIR/wayland-* | head -n1)")
# fi


# >>> aniadir cosas a path >>>
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

PATH="$HOME/.myScripts:$PATH"

export PATH

# >>> init de cosas varias >>>
eval "$(zoxide init zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/theme.omp.json)"
source <(fzf --zsh) # Set up fzf key bindings and fuzzy completion

# >>> aliases y preferencias varias >>>
alias reload='source ~/.zshrc'
alias editrc='nvim ~/.zshrc && source ~/.zshrc'
alias editniri='nvim ~/.dotfiles/nix/home/config/niri/config.kdl'
alias cd='z'
# alias rm='trash'
alias ls='lsd' # lsd stuff
alias l='ls -l' # lsd stuff
alias la='ls -a' # lsd stuff
alias lla='ls -la' # lsd stuff
alias lt='ls --tree' # lsd stuff
alias fzf="fzf --preview 'bat --style=numbers --color=always {}'" 
alias compressImg="magick input.jpg -strip -interlace Plane -gaussian-blur 0.05 -quality 50% output.jpg"
alias sideBySideVid="ffmpeg -i left.mp4 -i right.mp4 -filter_complex hstack output.mp4"
alias open="xdg-open"
# alias db="dropbox-cli"
alias db="maestral"
alias python='python3'
alias pyglobal="source ~/.virtualenvs/pyglobal/bin/activate"
alias tks="tmux kill-server"
alias tat="tmux a -t"
alias fillbat="sudo tlp fullcharge BAT0"
alias pingArch="ping archlinux.org"

# private stuff
if [ -f "$HOME/.zshrc.private" ]; then
  source "$HOME/.zshrc.private"
else
  echo -e "[\033[33mWARNING:\033[0m] ~/.zshrc.private not found!"
fi

# set -o vi
export EDITOR='nvim'
alias leovim='NVIM_APPNAME="leovim" nvim'

# cosas para que los colores funcionen
# export TERM=xterm-256color

export JULIA_NUM_THREADS=$(nproc) # by default julia will use all threads

# landing shell
if [[ -n "$PS1" && -z "$TMUX" ]]; then # if not in tmux
  if [[ -n "$SSH_CONNECTION" ]]; then # if connected through ssh
    $HOME/.myScripts/gentmux
  else
    fastfetch
  fi
fi

# to make yazi exit at cwd
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# my NixOS utilities

function nixos-edit(){
  # first we edit flake.nix
	local OG_PWD="$(pwd)"
  cd ~/.dotfiles # (we move to ~/.dotfiles to ensure git status works within nvim)
  nvim ~/.dotfiles/flake.nix

  # flags are dealt with
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --reload|-r) nixos-reload ;;
      *) echo "Unknown option: $1; Ignoring..." >&2 ;;
    esac
    shift
  done

  cd $OG_PWD >/dev/null || return # (we move back to the original working directory)
}

function nixos-commit(){
  cd /home/david/.dotfiles
  git add flake* nix
  if git diff --cached --quiet; then
    echo "Nothing to commit."
  else
    local currentGen=$(readlink /nix/var/nix/profiles/system | grep -o '[0-9]\+')
    git commit -m "nixos-generation $currentGen - $(date +"%Y.%m.%d %H:%M:%S")"
  fi
  cd - >/dev/null || return
}

function nixos-reload(){
  # flags are dealt with
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --update-unstable) sudo nix flake update nixpkgs-unstable --flake /home/david/.dotfiles ;;
      --update|-Syu) sudo nix flake update --flake /home/david/.dotfiles ;;
      *) echo "Unknown option: $1; Ignoring..." >&2 ;;
    esac
    shift
  done

  sudo nixos-rebuild switch --flake /home/david/.dotfiles#bjork 
  nixos-commit || return
}

# zprof # to debug loading time
