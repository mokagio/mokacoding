---
layout: post
title: "Automation with pre-commit hooks"
description: "Git provides a mechanism to run one or more scripts before a commit is actually added to the history called pre-commit hook. We can use this hook to run scripts that validate or sanitise the changes to be committed automatically, saving time and brain power, and assuring the quality of the codbase and git log."
tags:
- Git
- Automation
---

In the previous post we saw how iOS and Mac developers can [reduce the chances of merge conflicts on the project file using `xUnique`](https://mokacoding.com/blog/xunique/), a command line tool that makes the identifiers used in the `project.pbxproj` unique.

The main gotcha of this process is that _someone has to run the command_.

In the post we saw how a way to run xUnique automatically after every build, but what about those rare cases where the project is modified without then building? When this happens we'd risk to commit a _dirty_ `project.pbxproj`, and we'd like to avoid that and keep our Git log clean and tidy, right?

## The pre-commit hook

One of the many features that make [Git](http://git-scm.com/) awesome are the [Git Hooks](http://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks), custom scripts that run when certain important actions occur.

One of these _important actions_ is of course the commit, and Git has a hook that can be run before a commit, the `pre-commit` hook.

Simply write some code in an executable file named `pre-commit` in the `.git/hooks` folder, and the code will run before every commit.

The main use case for this hook is doing some validation of the changes to be committed, and failing the commit if something is not acceptable. We can fail the commit by making `pre-commit` return a non zero value.

### Running xUnique as a pre-commit hook

As we just said, running code before a commit is as easy as writing the command in the `pre-commit` hook file.

```bash
#!/bin/sh

# uniquify and sort the Xcode projct files
python -mxUnique -u -s "MyAwesomeApp.xcodeproj/project.pbxproj" &> /dev/null
```

_As usual you can follow along using the [example project](https://github.com/mokacoding/xUnique-Example) on GitHub._

If you try that you'll notice that the `project.pbxproj` that is committed is not uniquified. That is because even if `xUnique` runs, the changes are not automatically added to the commit. And that's a good thing! Since Git allows users to [commit only a subset of the changes made to a file](https://git-scm.com/book/en/v2/Git-Tools-Interactive-Staging) is better to always let the user decide what they want to commit. At least that's my opinion in most of the scenarios I've seen.

Lucky for us `xUnique` has an option to return 1 if the project needed to be uniquified, and therefore fail the commit.

```bash
#!/bin/sh

# uniquify and sort the Xcode projct files
python -mxUnique -u -s -c "xUnique.xcodeproj/project.pbxproj" &> /dev/null

if [ $? -ne 0 ]; then
  cat <<EOF
This commit has been aborted because the project file needed to be uniquified.
You can add those changes and commit again.
EOF
  exit 1
fi
```

The `<<EOF` is called [here document](http://tldp.org/LDP/abs/html/here-docs.html) and it's a good way to keep shell scripts that need to output a lot of text clean.

## Running multiple scripts in a hook

Once you'll get into pre-commit hooks you'll want to use more, you are going to want to run multiple scripts before your commits. A naive way to do this is to write all the scripts one after the other in the `pre-commit`, but we can do better than that, right?

We could for example have a single file for each script, and have the hook file simply run them in sequence.

```bash
#!/bin/sh

for hook in "uniquify-hook.sh" "trailing-whitespace-hook.sh";
do
  sh "$(pwd)/git-hooks/$hook"
  if [ $? -ne 0 ]; then
    exit 1
  fi
done
```

## Bootstrap script

What's the point of this setup if we are the only one that use it? In the case of running commands like xUnique or [clang-format](http://clang.llvm.org/docs/ClangFormat.html) in our pre-commit hook if we are the only ones that does that in the team the result would be counter productive. We want to share the hooks, and to be sure that all the team sets them up.

A way to achieve this is of course to simplify the setup process down to a single command, running a bootstrap script for example.

```bash
#!/bin/sh

echo "Configuring pre-commit hook..."

# make a symbolic link with the pre-commit hook
if [ ! -f ./git/hooks/pre-commit ]; then
  ln git-hooks/pre-commit.sh .git/hooks/pre-commit
  echo "Done"
else
  cat <<EOF
A pre-commit hook exists already.
EOF
fi
```

The code above expects us to have a `git-hooks` folder tracked in the repo, and creates a [symbolic link](http://en.wikipedia.org/wiki/Symbolic_link) between the `pre-commit` file in there and the one in `.git/hooks`. Please remember to make your `pre-commit` script executable, `chmod u+x git-hooks/pre-commit`.

## Bonus: a touch of color

We are all set now with our script or scripts running before every commit, keeping the codebase and the Git log cleaner and our productivity high. But there a final touch that can help us achieve an even better result, color.

Communicating visually with the users of our software is important, and color is a very good way to add extra meaning to the messages that the `pre-commit` hook will log to the terminal.

Color is so important that some TDD practitioners believe that the "red-green-refactor" mantra should reflect in the color of the test runner output. When a test fails the output should be red, to keep the developer under pressure, and when the tests are all successful the output should be green, to relax and reward the developer. Seeing the red in the terminal, they say, makes them a little bit uncomfortable, and it works as a push to develop the implementation faster, to get back to the green relaxing state.

The way is color our shell scripts is using the ANSII colors, see [this](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors) and [this](http://misc.flogisoft.com/bash/tip_colors_and_formatting).

I would usually use the red color. `\e[31m`.

```bash
red="\033[31m"
reset="\033[m"

printf "$red"
cat <<EOF
This commit has been aborted because the project file needed to be uniquified.
You can add those changes and commit again.
EOF
printf "$reset"
```

Notice the final usage of `\e[39m`, that resets the foreground color to the default one, and the ... echo option which simply makes is not print the trailing newline.

You can find a complete example of this multiple and colored pre-commit setup in the [companion project](https://github.com/mokacoding/xUnique-Example) on GitHub.

## A word of caution

The use of pre-commit hooks is very powerful and can help a team automate some mundane tasks and increase their productivity, but is recommended only for _mature teams_. First of all the team members need to understand and appreciate the value they would get out of things like uniquifing the Xcode project file, or alphabetically sorting the imports, or again forcing a style guide. Then the team member need to be able to setup all the tools need by the scripts to run, and more importantly don't panic when the commit is failed by the hook. But maybe the most important thing is that they need to **read the README** where you'll have written that before doing anything they need to run the bootstrap script. And trust me that's not something that can be given for granted 😳.

---

I hope this post will inspire you to think of new ways with which you could automate some of the boring or important tasks in the development process, and run them in a `pre-commit` hook.

I you have some hooks that you use and you like to share, want more information, or have a feedback please use the comments below or tweet me [@mokagio](https://twitter.com/mokagio)

_Happy coding, and leave the codebase better than you found it._
