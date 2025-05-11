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
alias tmux='tmux -u'
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

# cosas para que los colores funcionen
# export TERM=xterm-256color

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/Users/davidcorrea/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
export JULIA_NUM_THREADS=$(nproc) # by default julia will use all threads

# uncomment for automatic tmux login :D
if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
  # tmux new-session -A -s main

  # Create a new session named "main" and run a command inside the session
  tmux new-session -d -s main
  tmux send-keys -t main 'clear && fastfetch' Enter
  # Attach to session named "main"
  tmux attach -t main
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
