---
layout: post
title: How to display relative line numbers in NERDTree
description: "Vim's relative line numbers are great for jumpin around files, and once you get used to them you want to enable them everywhere. Here's how to have NERDTree use relative line numbers"
tags:
  - Vim
  - Espresso
---

Vim's relative line numbers are great for jumpin around files, and once you get used to them you want to enable them everywhere. Here's how to have NERDTree use relative line numbers.

```vim
" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber
```

There you go 😎.
