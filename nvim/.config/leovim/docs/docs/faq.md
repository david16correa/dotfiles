---
title: FAQ
nav_order: 7
toc: true
---

# Frequently Asked Questions


Here is a list of common questions, and their quick answers.

- TOC
{:toc}

## How do I keep leovim alongside my own configuration?

Neovim lets you lauch it with a different configuration file by using the [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME) environmental variable when launching it with the command.

```bash
NVIM_APPNAME="leovim" nvim
```
This will look for a configuration file under `~/.config/leovim` . Using this, you can clone
```bash
git clone https://github.com/leogabac/leovim.git ~/.config/leovim
```
and make the alias 
```bash
alias leovim='NVIM_APPNAME="leovim" nvim'
```
Then `leovim` will launch this confguration while `nvim` will keep your default.

## Why does yanking not sync with my system's clipboard?

To yank to your system's clipboard you need to yank it to the `+` or `*` register. This can be done with the motion
```
"+y
```
If it does not work, make sure to have a clipboard manager like `xclip` (For X11) or `wl-copy` (For Wayland) installed.

## How do I see which plugins are installed?

Leovim uses `lazy.nvim` as its plugin manager. To see which packages are installed, run
```
:Lazy
```

## How do I compile a LaTeX document?

Leovim uses [vimtex](https://github.com/lervag/vimtex) for LaTeX support. The default command for compilation is
```
:VimtexCompile
```
This will compile the document, references and all of the necessary dependencies. Then it will launch the default PDF viewer. This command is also mapped to
```
<leader>ll
```

## Why is my latex document not compiling?

Make sure to have a LaTeX distribution installed, I recommend `texlive`. Additionally, make sure to have the package `latexmk` installed as it is the default recipe for continuous compilation.

## Why can't I see my LaTeX document rendered?

By default, leovim uses `zathura`, a PDF viewer meant to work with LaTeX documents. Make sure to have it installed and in your PATH with some optional dependencies like `zathura-pdf-mupdf`

## Why do you use X plugin and not Y plugin I prefer?

Because people can actually have different opinions.




