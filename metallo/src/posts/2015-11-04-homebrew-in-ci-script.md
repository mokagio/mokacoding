---
layout: post
title: How to use Homebrew in CI
description: A quick guide on how to safely use Homebrew in CI.
tags:
  - Continuous Integration
  - Homebrew
  - Espresso
---

### TL;DR

If your CI has `<tool_name>` installed already:

```
brew update || brew update
brew outdated <tool_name> || brew upgrade <tool_name>
```

otherwise:

```
brew update || brew update
brew install <tool_name>
```

### TS;WR

Ideally you would have everything your scripts depend upon checked in with the repo, but let's be honest, this is sometimes not practical.

Some tools, for example `xctool`, can either be fetched as a git submodule, with all the problems coming with this approach, or via [Homebrew](http://brew.sh/) in a simpler way.

What the two lines at the start of the post do is downloading the latest version of `<tool_name>`. Let's look at them in more detail.

```
brew update
```

`brew update` will fetch the latest formulae, making sure that if you are running on the latest version of a tool, but your CI isn't, the latest version will be the one downloaded by the upgrade command later.

```
brew update || brew update
```

We are doing `brew update || brew update` because sometimes a formula might break the first run of the update command, but running it a second time will succeed. More on this issue [here](https://github.com/Homebrew/homebrew/issues/45616).

`||` is the logical OR that we use in everyday programming as well. Every command line operation has a return code of `0` if everything went fine, non `0` otherwise. This means that if your execute `command a || command b` and `command a` returns fails returning something that is not `0` then `command b` is executed. If instead `command a` succeeds then the OR is already true, and `command b` will not run. This is quite a neat trick.

Using `||` in the first line makes sure that if the first update fails, then a second attempt will be made.

```
brew install <tool_name>
```

The second line differs depending on whether your CI provider gives you a box with the tool you are after already installed. If that's not the case then you'll simply have to install it yourself with `brew install`, otherwise you will need to update it, or in Homebrew terminology `upgrade`.

```
brew outdated <tool_name> || brew upgrade <tool_name>
```

Since attempting to upgrade and up to date formula would result in a failure, you'll have to check if the local version is outdated. This can be done using the same `||` expedient. If `brew outdated` doesn't return `0` then it means that the tool is not up to date, and should be updates using `brew upgrade`.

That's all folks. If you have any questions please do leave a comment below, or even better, reach me out on Twitter [@mokagio](https://twitter.com/mokagio).

_Happy coding, and leave the codebase better than you found it._
