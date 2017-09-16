---
layout: post
title: Symbolic links in Git
description: "Here's how to track symbolic liks in a Git repository, in a way suitable for teams."
tags:
- Espresso
- Git
---

_**Note:** all this has been tried and tested on macOS only, but it should work seamlessly on Linux as well._

Symbolic links are a great way to simplify mundane tasks such as having the same configuration file in different folders.

If you are not familiar with symbolic links, symlinks for short, I recommend reading the manpage for the `ln` command, or [this post](https://kb.iu.edu/d/abbe).

Git can track symlinks as well as any other text files. After all, as the documentation says, a symbolic link is nothing but a file with special mode containing the path to the referenced file. Knowing how to handle links is the OS job.

There is an important caveat when creating symlinks that are meant to be tracked under Git. **The reference path of the source file should be relative to the repository**, not absolute to the machine.

```
# Not good for Git repositories
ln -s /Users/gio/repo/foo.md ./bar/foo.md

# Good for Git repositories
cd ./bar && ln -s ../foo.md foo.md
```

The reason for this is that given that a symlink contains the path to the referenced file, if the path is relative to a specific machine the link won't work on others. If it's relative to the repository itself on the other hand, the OS will always be able to find the source.

Have a look at [this example repo](https://github.com/mokacoding/symlinks) to play around with these ideas.

_Leave the codebase better than you found it._
