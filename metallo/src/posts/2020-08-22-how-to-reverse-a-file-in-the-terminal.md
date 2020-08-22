---
title: How to reverse a file in the terminal
tags:
- Espresso
---

Today, I used `grep` to filter the `git log` output to only get the changes made on a certain value holding the version number for an app.

The `git log` output is sorted newest to oldest, but I was interested in how the changes progressed, that is, oldest to newest.

**You can use [`tac`](https://www.gnu.org/software/coreutils/manual/coreutils.html#tac-invocation) to reverse a file or the standard input.**

```
$ cat file.txt
a
b
c

$ tac file.txt
b
c
a
```

Here's how it works when used with a pipe.

```
echo "a\nb\nc" | tac
c
b
a
```
