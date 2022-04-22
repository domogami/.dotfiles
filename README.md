# Dom's .dotfiles
A OneDark inspired MacOS theme (rice)

![plot](./photos/photo1.png)
![plot](./photos/photo2.png)
![plot](./photos/photo3.png)

# Installation
---
## Chezmoi
I am using [Chezmoi](https://www.chezmoi.io/) to manage my dotfiles because it is free and cross platform. To get started install chezmoi using

```
$ sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply domogami
```
This command will establish symbolic links between your home directory and the chezmoi directory containing the dotfiles. Check to ensure that the dotfiles have been created successfully in your home directory.

# Software I Use
---
## iTerm2

## Alfred 4

## Fig

## Yabai + SKHD + Karabiner

## Simplebar

## LunarVim

## Spotify-tui
Spotify-tui is a 

## Htop / Neofetch / Pipes

## Zathura pdf Reader
After taking many mathematics courses in university I wrote quite a lot of LaTeX. Senior year, I switched to using vim with LaTeX snippets to save time which worked phenominally. However, having to compile latex myself instead of using a tool like [Overleaf](https://www.overleaf.com/) meant that I needed to use a pdf reader. On my search for finding the perfect pdf reader I found [Zathura](https://github.com/pwmt/zathura) which allows for custom colors and features vim shortcuts to scroll through the pdf.  

## Oh-My-Zsh + p10k
I love Oh-My-Zsh because of its incredible aesthtic and customizability. Combined with p10k and a font that supports nerd icons the command line looks stunning.

## Fonts
Originally I was using Hack Nerd Font and grew to really enjoy it, however I realized that it does not support ligatures which is something that I really enjoy having. Luckily, the user pyrho has added ligatures to [Hack Nerd Font w/ Ligatures](https://github.com/pyrho/hack-font-ligature-nerd-font)! This has become my go-to font of choice.
