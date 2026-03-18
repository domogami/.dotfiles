
# Starship is the active prompt. Keep prompt initialization to one system.

# Old Brew x86
alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'
# Homebrew on Apple Silicon
path=('/opt/homebrew/bin' $path)
typeset -U path
export PATH

# NOTE: Tmux iTerm2 integration
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  alias tmux='tmux -CC'
fi

# NOTE: Vim Shortcuts
# alias v="neovide --multigrid --frame none"
# alias vim="neovide --multigrid --frame none"

# alias v="neovide --frame=buttonless"
alias vim="neovide --frame=buttonless"
alias v="open -n -a neovide"
alias v.="open -n -a neovide --args --frame=buttonless $PWD"

alias y="yazi"
alias ycd='yazi; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias nf="neofetch"

# Use ~/.config/superfile as the default config/hotkey location for superfile.
spf() {
  command spf \
    -c "$HOME/.config/superfile/config.toml" \
    --hotkey-file "$HOME/.config/superfile/vimHotkey.toml" \
    "$@"
}

alias ls="eza -l --icons --git -a"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"

# NOTE: Dev shortcuts 
alias dev="cd ~/Documents/GitHub/ && ls"
alias gs="git status"
alias ghostscript="command gs"
alias o="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/"
alias oo="cd /Users/dom/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Dom\'s\ 2nd\ Brain/ && v /Users/dom/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Dom\'s\ 2nd\ Brain/🏠\ Home.md"
alias obsidian="cd ~/Documents/GitHub/obsidian-site/quartz/ && ls"

# NOTE: Web shortcuts 
alias web="cd ~/Documents/GitHub/dominicklee.net && v ."
alias webdev="cd ~/Documents/GitHub/dominicklee.net/ && npm run dev"
alias webdevcss="cd ~/Documents/GitHub/dominicklee.net/ && npm run dev:css"

# NOTE: File Navigation
# Yazi is better
# alias r=ranger
# alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# NOTE: Default editor
# export EDITOR=lvim-gui
# export VISUAL=lvim-gui

export EDITOR=nvim
export VISUAL=nvim

# NOTE: Switch to ARM Homebrew
alias armbrew='eval "$(/opt/homebrew/bin/brew shellenv)"'
# NOTE: Switch to x86_64 Homebrew
alias x86brew='eval "$(/usr/local/homebrew/bin/brew shellenv)"'

eval "$(starship init zsh)"

export PATH=$PATH:/Users/dom/.spicetify
export PATH=$PATH:/Users/dom/.cargo/bin
export PATH=$PATH:/Users/dom/go
export GOPATH=/Users/$USER/go 
export GOROOT="/opt/homebrew/opt/go/libexec"
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
# fpath+="$HOME/.zsh/zen"
# autoload -Uz promptinit
# promptinit
# prompt zen

setopt histignorespace

if [[ "$TERM_PROGRAM" == "iTerm.app" ]] && [[ -f ~/.iterm2_shell_integration.zsh ]]; then
  source ~/.iterm2_shell_integration.zsh
fi

# pnpm
export PNPM_HOME="/Users/dom/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
#export PATH="~/.local/bin"
export PATH=$PATH:/Users/dom/.local/share/lunarvim

# Easily Source
alias sc="source ~/.zshrc"
# Fun Spotify Terminal Visualizer
alias spt='spotatui'
alias sptl='cd /Users/dom/Documents/GitHub/spotatui && cargo run'

eval "$(zoxide init --cmd cd zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
lazy_load_nvm() {
  unset -f nvm node npm npx corepack yarn
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() { lazy_load_nvm; nvm "$@"; }
node() { lazy_load_nvm; node "$@"; }
npm() { lazy_load_nvm; npm "$@"; }
npx() { lazy_load_nvm; npx "$@"; }
corepack() { lazy_load_nvm; corepack "$@"; }
yarn() { lazy_load_nvm; yarn "$@"; }

export FPATH="~/Documents/GitHub/eza/completions/zsh:$FPATH"


eval "$(atuin init zsh)"

export SDKMAN_DIR="$HOME/.sdkman"

# Keep current SDKMAN-managed binaries available without paying init cost on every shell.
for sdk_candidate_bin in "$SDKMAN_DIR"/candidates/*/current/bin(N); do
  path=("$sdk_candidate_bin" $path)
done

lazy_load_sdkman() {
  unset -f sdk
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}

sdk() { lazy_load_sdkman; sdk "$@"; }

dom_refresh_neofetch_cache() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/neofetch"
  local cache_key="${DOM_NEOFETCH_CACHE_KEY:-startup-v4}"
  local cache_file="$cache_dir/${cache_key}.txt"
  local lock_dir="$cache_dir/.${cache_key}.refresh.lock"
  local tmp_file="$cache_dir/${cache_key}.$$"

  mkdir -p "$cache_dir"

  if ! mkdir "$lock_dir" 2>/dev/null; then
    return
  fi

  {
    if neofetch >| "$tmp_file" 2>/dev/null; then
      mv -f "$tmp_file" "$cache_file"
    else
      rm -f "$tmp_file"
    fi

    rmdir "$lock_dir" 2>/dev/null
  } >/dev/null 2>&1 &!
}

dom_print_neofetch_cached() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/neofetch"
  local cache_key="${DOM_NEOFETCH_CACHE_KEY:-startup-v4}"
  local cache_file="$cache_dir/${cache_key}.txt"
  local ttl="${DOM_NEOFETCH_TTL:-300}"
  local -a cache_stat
  local cache_fresh=0

  mkdir -p "$cache_dir"

  if [[ -f "$cache_file" ]] && zmodload -F zsh/stat b:zstat 2>/dev/null; then
    zstat -A cache_stat +mtime -- "$cache_file" 2>/dev/null

    if (( ${#cache_stat[@]} && EPOCHSECONDS - cache_stat[1] < ttl )); then
      cache_fresh=1
    fi
  fi

  if [[ -f "$cache_file" ]]; then
    command cat "$cache_file"

    if (( ! cache_fresh )); then
      dom_refresh_neofetch_cache
    fi

    return
  fi

  if neofetch >| "$cache_file" 2>/dev/null; then
    command cat "$cache_file"
  else
    neofetch
  fi
}

if [[ -o interactive ]] && [[ -t 1 ]] && [[ -z "${DOM_NEOFETCH_SHOWN:-}" ]] && command -v neofetch >/dev/null 2>&1; then
  export DOM_NEOFETCH_SHOWN=1
  dom_print_neofetch_cached
fi
