
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
source /Users/dom/.zsh_themes/bubblified.zsh-theme
ZSH_THEME="bubblified"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Old Brew x86
alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'
# Homebrew on Apple Silicon
path=('/opt/homebrew/bin' $path)
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
# GOVERSION=$(brew list go | head -n 1 | cut -d '/' -f 6)
GOVERSION=1.20.3
export GOROOT=$(brew --prefix)/Cellar/go/$GOVERSION/libexec
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
# fpath+="$HOME/.zsh/zen"
# autoload -Uz promptinit
# promptinit
# prompt zen

setopt histignorespace

source ~/.iterm2_shell_integration.zsh

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

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init --cmd cd zsh)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export FPATH="~/Documents/GitHub/eza/completions/zsh:$FPATH"


eval "$(atuin init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"




# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
