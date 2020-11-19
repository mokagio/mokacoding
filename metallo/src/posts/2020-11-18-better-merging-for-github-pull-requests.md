---
title: These 10 seconds when merging will make your GitHub pull request better
description: When merging a pull request on GitHub, it helps to replace the default merge commit title with the PR title or an equally descriptive one. This will make your Git history more informative, and developers will understand the changes in the Git log faster.
tags:
- GitHub
- Git
---

When you "Squash and merge" a pull request on GitHub, the merge commit title defaults to the PR title.

Using the pull request title, or any descriptive title with the PR id, makes a massive difference in how readable your Git history is.

I wish GitHub had the same behavior for "Merge pull request" instead, it uses Git's default merge title "`Merge pull request #123 from username/branch-name`".

Luckily, it takes just a few seconds to copy the PR title into the merge commit field.

![GIF showing how to copy-paste the pull request title into the merge commit title field](https://s3.amazonaws.com/mokacoding/2020-11-19-github-merge-title.gif)

Is the effort worth it?
You bet!

Having a clear Git history is something worth investing in.

_Before we continue, an obvious solution to the problem would be to "Squash and merge" all PRs instead.
Obvious, yes, but sometimes not desirable and other times not possible because of established team conventions.
This post doesn't want to be an argument for merging vs. squashing.
The idea of keeping a clear and informative Git history is valid regardless of how we get our changes into it._

## Why does the merge commit title matter?

Imagine someone offered you a million dollars if you can guess what the latest commit on a repository does by only reading its title.
Would you rather the commit title was this:

```
Merge pull request #123 from add-author-label
```

or this:

```
Add author label to blogpost description view (#123)
```

Obviously, no one will ever ask you to guess what a commit does only by reading its title – let alone offer you a million dollars.
On top of that, the GitHub UI makes it easy to bring up extra information for a commit, as well as the PR it belongs to.

Still, even though the extra information is only one click away, the second commit is more explicit than the first.
There is less friction for the reader to understand what the commit does.

## Shorten the path to understanding

Software developers appreciate the value of clean, readable code.
Clean code is easy to follow, making it easy to understand and, in turn, easy to work with.

Clean code is what every programmer opening an unfamiliar codebase hopes to find.
The cleaner the code, the less time it will take to get up to speed and be productive.

The productivity advantages of clarity apply to Git commits as well as code.
If you can shorten the path to understanding your Git history, every developer who will read it will benefit from it – including your future self.

## Turn your Git log into a readable story

Consistently using descriptive titles for your merge commits will turn your Git log messages into a human-readable history of the changes that made it into the codebase.

The `git log` command has an option called `--first-parents` to follow only the first parent commit upon seeing a merge commit.
When applied to the log on the main branch of a repository, where all the PRs get merged, the result is a list of merge commits only.

Compare the output when using a descriptive title to the PR merge commit vs. the default one:

```
$ git log --pretty=oneline --abbrev-commit --first-parent

a2055b7 (HEAD -> trunk, origin/trunk) Merge pull request #4 from mokagio/feature-author-label
64344e0 Merge pull request #3 from mokagio/improve-mobile-layout
70ba8ac Merge pull request #2 from mokagio/feature-more-negative-space
7d5c9da Merge pull request #1 from mokagio/feature-dark-mode-css-support
```

```
git log --pretty=oneline --abbrev-commit --first-parent

a2055b7 (HEAD -> trunk, origin/trunk) Add author label to post metadata component (#4)
64344e0 Improve layout on mobile devices (#3)
70ba8ac Use more negative space (#2)
7d5c9da Support dark mode via CSS media query (#1)
```

The second log reads like a story.
The first has little information to offer other than the fact that stuff got merge in this branch.

When you pull the latest changes from your main branch, you can run this filtered `git log` to get an idea of the recent changes.
_Tip_: define [an alias for it](https://mokacoding.com/blog/terminal-aliases/) to make it easier to call it; mine is `glgf`.

---

Using a descriptive title when you merge your pull requests on GitHub is a process that adds friction in the short run to remove friction in the long run.

It takes longer to merge a PR when you need to copy its tile or come up with a succinct one for the commit.
Those extra seconds, a couple of minutes in the worse scenario, will pay off because every time a developer will look at the history, they'll benefit from its greater clarity.

The asymmetry between the one time cost of the merge and the many times people will read the history makes the tradeoff all the more worth it.

So, next time you're about to click that merge button, spend a few extra seconds to add a descriptive title.
Your team, the users of your open source software, your future self, they'll all thank you for it.

What do you think of this approach?
What are your best practices for effective GitHub pull requests and tidy Git history?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).
