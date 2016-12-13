---
layout: post
title: Your Git Log Should Tell A Story
description: 'A look at the practical benefits of writing descriptive commits'
tags:
  - Git
---

Have you ever been debugging an annoying new bug and realised that the simplest
way to track it down would be to look at what changed in the code since the
previous release, where the bug wasn't there?

There are different ways to do this, a quick one is to run `git log` and to
skim through the commit messages looking for something suspicious. That is, if
the commit messages tell something useful.

We software developer take a lot of care in crafting readable and efficient
code, but too often not enough in writing informative commits. Is not uncommon
to see logs like this (ficticious) one:

```
$ git log --format=oneline --abbrev-commit

5ab4e81 Cleanup
66105f6 Updated based on PR comments
aecb4de Forgot to add a file
63194e8 Tweaked custom pop animation parms
344eafd Implement new navigation style
43e06b3 Actually make status bar white
2e01356 Needs beer
aca1ff6 Not working
17107ab Fix status bar not being white
9c7f5d1 Make status bar white
```

While it might be funny to read that the committer felt like beer at the time
they were writing the code, that is not very useful for someone looking at it.

What could a commit titled "Not working" have introduced in the codebase? No
idea. The only way to know is to look at the commit changes.

And what about "Updated based on PR comments"? Which PR? Which comments in that
PRs? In this case reading at what that commit introduced will not be enough,
one would need a link to the pull request to understand the full picture.

What I would like to see would be something more like this:

```
$ git log --format=oneline --abbrev-commit

a6104f6 Extract custom durations in constants
63194e8 Tweak custom pop animation params
344eafd Implement new navigation style
ac5f5d3 Make status bar white
```

This log **tells a story** which is straightforward and easy to follow. Any
reader of this log, which includes future-you which will have forgotten the
details of that code, will get the idea of what happened there just by reading
it.

If you and your team develop the habit of writing descriptive commits, then you
will increase the information throughput of the history, which will make
understanding the history and finding what you are looking for easier.

When committing code ask yourself "what are the changes I introduced in these
files?", more often then not the answer will be something like "add method x to
class y", "remove behaviour x from component y", "update x to do y", "exctract
code doing x for reuse". These are all great commit titles, and you can provide
more information about why the change you introduced was necessary in the rest
of the commit message.

---

Writing informative commits goes hand in hand with making your commits small
and atomic, and knowing how to perform an interactive rebase can help a lot to
keep the history tidy. We will look at these topics in the upcoming posts, so
stay tuned.

If you have questions, comments, or want to discuss this idea get in touch on
Twitter [@mokagio](https://twitter.com/mokagio) or leave a comment below.

_Leave the codebase better than you found it._
