---
layout: post
title: "How to reuse the last parameter in a terminal command"
description: "When typing a shell command it is possible to reuse the last argument of the previous call without having to type it. Let's see how."
date: 2015-08-05
tags:
- Shell
- Espresso
---

Say that you want to delete a branch both locally and remotely, the commands for that are:

```bash
git branch -d branch-name
git push --delete remote-name branch-name
```

But why do all that typing? It would be nice to be able to say to the second command: "use the parameter from the previous one".

Well, Bash got you covered 😎. The `$_` symbol (variable?) is substituted by the shell with the parameter from the last command.

We can then write:

```bash
git branch -d branch-name
git push --delete remote-name $_
```

You might not be impressed by that in this scenario, but think how you could leverage this in a script or in combo with [`xargs`](http://www.cyberciti.biz/faq/linux-unix-bsd-xargs-construct-argument-lists-utility/).

---

Another useful trick when it comes to reusing the last parameter is `!$`. When hitting enter on a command with `!$` the shell will not execute it, but prompt the command again, with the last parameter used in place of `!$`. Example:

```bash
$ ls ~/Desktop
$ ls -a !$
$ ls -a ~/Desktop
```

The simplest way to understand the difference between the two is to **try them**.

_Leave the codebase better than you found it._
