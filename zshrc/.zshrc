# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  fzf
  zsh-vi-mode
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-interactive-cd
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Load Zsh Aliases
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

export EDITOR='nvim'

# Starship init command
eval "$(starship init zsh)"

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# # Colorls
# source $(dirname $(gem which colorls))/tab_complete.sh

# ZSH Syntax Highlighting
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,bold
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green,bold

# Less Syntax Highlighting
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R'

# Direnv
eval "$(direnv hook zsh)"

# Use nala instead of apt
sudo() {
  if [ "$1" = "apt" ]; then
    shift
    command sudo nala "$@"
  else
    command sudo "$@"
  fi
}

if [ -e /home/yannick/.nix-profile/etc/profile.d/nix.sh ]; then . /home/yannick/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
function zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

# The plugin will auto execute this zvm_after_lazy_keybindings function
function zvm_after_lazy_keybindings() {
  # In normal mode, press Ctrl-E to invoke this widget
  zvm_bindkey vicmd '^p' history-search-backward
  zvm_bindkey vicmd '^n' history-search-forward
}

if [[ $(xmodmap -pm | grep 'Caps_Lock') ]]; then
  [ -f ~/.xmodmap ] && xmodmap ~/.Xmodmap
fi

# Create a Neovim Config Switcher
function nvims() {
  items=("default" "LazyVim" "NvChad")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# Create a VPN switcher
function vpn() {
  items=$(nmcli -f NAME,TYPE con show | grep --color=never -i "vpn" | awk '{print $1}')
  vpn_id=$(printf "${items[@]}" | fzf --prompt="  VPN Switcher  " --height=~50% --layout=reverse --border --exit-0)
  active_vpn=$(nmcli -f NAME,TYPE con show --active | grep --color=never -E "vpn" | awk '{print $1}')
  vpn_off=false
  if [[ -z $vpn_id ]]; then
    echo "No VPN selected"
    return 0
  fi
  if [[ -z $active_vpn ]]; then
    nmcli con up id $vpn_id >/dev/null
  elif [[ $active_vpn == $vpn_id ]]; then
    nmcli con down $vpn_id >/dev/null
    vpn_off=true
  else
    nmcli con down $active_vpn >/dev/null
    nmcli con up $vpn_id >/dev/null
  fi
  if [[ $? -eq 0 ]]; then
    if $vpn_off; then
      echo "Turned $vpn_id off"
      return 0
    fi
    echo "Switched to $vpn_id"
  else 
    echo "Couldn't switch to $vpn_id"
  fi
}

function dockersize() {
  docker manifest inspect -v "$1" | jq -c 'if type == "array" then .[] else . end' |  jq -r '[ ( .Descriptor.platform | [ .os, .architecture, .variant, ."os.version" ] | del(..|nulls) | join("/") ), ( [ .SchemaV2Manifest.layers[].size ] | add ) ] | join(" ")' | numfmt --to iec --format '%.2f' --field 2 | column -t ;
}

# Configuration editor
function config() {
	items=("Neovim" "Wezterm" "Tmux")
	to_edit=$(printf "%s\n" "${items[@]}" | fzf --prompt="  Configuration to edit " --height=~50% --layout=reverse --border --exit-0)
	if [[ -z $to_edit ]]; then
		echo "Nothing selected. Aborting."
		return 0
	elif [[ $to_edit == "Neovim" ]]; then
		nvim "$HOME/dotfiles/neovims/LazyVim/lua/plugins/"
	elif [[ $to_edit == "Wezterm" ]]; then
		nvim "$HOME/dotfiles/wezterm/wezterm.lua"
	elif [[ $to_edit == "Tmux" ]]; then
		nvim "$HOME/dotfiles/tmux/tmux.conf"
	fi
}

# git - Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done

  # If no main branch was found, fall back to master but return error
  echo master
  return 1
}

# Zoxide
eval "$(zoxide init --cmd cd zsh)"
# Making sure Zoxide adds symlink to database and not target dir
export _ZO_FOLLOW_SYMLINKS=0

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# Pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"

# Thefuck
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# Make ripgrep use delta by default
rg() {
  command rg --json "$@" | delta
}

# Pager
export LESSCHARSET=utf-8
export PAGER="less -RF"
# Bat Pager
export BAT_PAGER="less -RF"
# Delta Pager
export DELTA_PAGER="less -RF"

# Load asdf script
source "$HOME/.asdf/asdf.sh"

# PATHS
# Add Go to path
# export PATH="$PATH:/usr/local/go/bin" # Before asdf
source "$HOME/.asdf/plugins/golang/set-env.zsh"
# Add Cargo binaries to path
# export PATH="$PATH:/home/yannick/.cargo/bin"
# Add Deno to PATH
# export DENO_INSTALL="/home/yannick/.deno"
# export PATH="$DENO_INSTALL/bin:$PATH"
# Add bob to path
# export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# Add Go binaries to path
export PATH="$(go env GOPATH)/bin:$PATH"
# Add nix to path
export PATH="/etc/nix:$PATH"

# Load ~/Code/zshrc
source ~/Code/zshrc

# Load autocompletion system
fpath+=~/.zfunc
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add xterm-kitty info file
install_xterm_kitty_terminfo() {
  # Attempt to get terminfo for xterm-kitty
  if ! infocmp xterm-kitty &>/dev/null; then
    echo "xterm-kitty terminfo not found. Installing..."
    # Create a temp file
    tempfile=$(mktemp)
    # Download the kitty.terminfo file
    # https://github.com/kovidgoyal/kitty/blob/master/terminfo/kitty.terminfo
    if curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo; then
      echo "Downloaded kitty.terminfo successfully."
      # Compile and install the terminfo entry for my current user
      if tic -x -o ~/.terminfo "$tempfile"; then
        echo "xterm-kitty terminfo installed successfully."
      else
        echo "Failed to compile and install xterm-kitty terminfo."
      fi
    else
      echo "Failed to download kitty.terminfo."
    fi
    # Remove the temporary file
    rm "$tempfile"
  fi
}
install_xterm_kitty_terminfo

# Create keybinding for sesh
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
autoload bashcompinit
bashcompinit
source "/home/yannick/.local/share/bash-completion/completions/am"
