# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/david/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# >>> aniadir cosas a path >>>

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# >>> init de cosas varias >>>
eval "$(zoxide init zsh)"
eval "$(oh-my-posh init zsh --config ~/.myterminaltheme.omp.json)"
source <(fzf --zsh) # Set up fzf key bindings and fuzzy completion

# >>> aliases y preferencias varias >>>
alias reload='source ~/.zshrc'
alias editrc='nvim ~/.zshrc && source ~/.zshrc'
alias cd='z'
alias tns='tmux new-session -s'
alias tls='tmux ls'
alias tqa='tmux a'
alias tta='tmux a -t'
# alias view='qlmanage -p'
alias ls='lsd' # lsd stuff
alias l='ls -l' # lsd stuff
alias la='ls -a' # lsd stuff
alias lla='ls -la' # lsd stuff
alias lt='ls --tree' # lsd stuff
alias fzf="fzf --preview 'bat --style=numbers --color=always {}'" 
alias compressImg="magick input.jpg -strip -interlace Plane -gaussian-blur 0.05 -quality 50% output.jpg"
alias sideBySideVid="ffmpeg -i left.mp4 -i right.mp4 -filter_complex hstack output.mp4"
alias findProcess="ps -ef | fzf"
alias db="dropbox-cli"
alias python='python3'
alias pyglobal="source ~/.virtualenvs/pyglobal/bin/activate"

# private stuff
if [ -f "$HOME/.zshrc.private" ]; then
  source "$HOME/.zshrc.private"
else
  echo -e "[\033[33mWARNING:\033[0m] ~/.zshrc.private not found!"
fi

# set -o vi
export EDITOR='nvim'
alias leovim='NVIM_APPNAME="leovim" nvim'

PATH="$HOME/.myScripts:$PATH"
export PATH

# cosas para que los colores funcionen
# export TERM=xterm-256color

export JULIA_NUM_THREADS=$(nproc) # by default julia will use all threads

# landing shell
if [[ -n "$PS1" && -z "$TMUX" ]]; then # if not in tmux
  if [[ -n "$SSH_CONNECTION" ]]; then # if connected through ssh
    $HOME/.myScripts/gentmux
  else
    clear && fastfetch
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
