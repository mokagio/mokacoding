---
title: How to rename a file in Vim
description: "There are many ways to rename a file in Vim. Here's three."
tags:
- Espresso
- Vim
---

There are many ways to rename a file in Vim. Here's three:

## Using vim-eunuch

[vim-eunuch](https://github.com/tpope/vim-eunuch) is an oddly named plugin by _Vim plugin artist_ [Tim Pope](https://tpo.pe/).
It adds a few commands for common file tasks like renaming, `:Move`, deleting, `:Delete`, and creating directories, `:Mkdir`.

This is my favorite way of renaming files.
Before discovering the eunuch plugin, I used NERDTree to rename files.

## Via NERDTree

The [NERDTree](https://github.com/preservim/nerdtree) plugin is not only useful as a file system explorer, you can use it to manipulate files, too.

My rename workflow is this:

- `:NERDTreeFind` to jump to the node for the current file in the NERDTree navigator
- `m` to open the NERDTree menu
- `m` to move the node

## Vanilla Vim: shell out to `mv`

If you are not keep on plugin, you can still trust vanilla Vim to get the job done for you.

In Vim, you can execute commands in your shell without opening a new terminal with [`:!cmd`](http://vimdoc.sourceforge.net/htmldoc/various.html#:!cmd).
To rename a file, you'll want to execute `mv`:

```
:!mv source target
```

The caveat with this approach that if you rename the file in the current buffer, it won't be available anymore and Vim will give you an error.
You'll have to reload it from its new location to keep working on it.

---

Which approach do you prefer?
Are there any other worth mentioning?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter [@mokagio](https://twitter.com/mokagio).
