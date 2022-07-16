# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"
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
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias tmux=tmux -CC
alias v="neovide --multigrid --frame none"
alias vim="neovide --multigrid --frame none"
# Dev shortcuts 
alias dev="cd ~/Documents/GitHub/ && ls"
alias web="cd ~/Documents/GitHub/dominicklee.net && v ."
alias webdev="cd ~/Documents/GitHub/dominicklee.net/ && npm run dev"
alias webdevcss="cd ~/Documents/GitHub/dominicklee.net/ && npm run dev:css"

alias r=ranger
alias ls=exa
alias o="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/"
# export EDITOR=lvim
# export VISUAL=lvim
export EDITOR=nvim
export VISUAL=nvim

eval "$(starship init zsh)"

export PATH=$PATH:/Users/dom/.spicetify
export PATH=$PATH:/Users/dom/.cargo/bin
# fpath+="$HOME/.zsh/zen"
# autoload -Uz promptinit
# promptinit
# prompt zen

source ~/.iterm2_shell_integration.zsh

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"
