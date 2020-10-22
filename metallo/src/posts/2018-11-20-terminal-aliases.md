---
title: "How to become drastically faster at using the terminal"
description: "Using the terminal might seem slow and cumbersome because every command needs to be typed. Learn how to drastically reduce the amount of typing you have to do by configuring aliases for your most used commands, making them only a few keystrokes long."
tags:
  - Productivity
  - Terminal
---

One of the best things you could do to improve as a software developer is constantly [investing in your terminal setup and skills](https://mokacoding.com/blog/invest-in-your-terminal-to-become-a-better-developer/).

You might be taken aback by the command line because there is a lot of typing to do. It can seem slower than using a GUI. It doesn't have to be that way.

You can create aliases for the commands that you use most often, resulting in little typing left to do. **Aliases are like keyboard shortcuts but for the terminal and supercharged**.

For example you might use `git commit -m` a lot. You can alias it to `gc` which is much faster to type.

## Getting started with aliases

To create an alias:

1. Find out which shell you are running with `echo $SHELL`. On macOS the default is Bash.
2. Open the profile file of your shell, or create one if there isn't one yet. For Bash that's located at `~/.bash_profile`<sup>[1](#fn1)</sup>.
3. Define your aliases adding `alias <your alias> = <aliased command>` to the profile file.

As I'm writing this my most used aliases are:

- `alias v vim`
- `alias gc git commit`
- `alias gl git pull`
- `alias gp git push`
- `alias gri git rebase --interactive`
- `alias pb pbcopy`

Notice how they are all just a few letters long. That's the power of aliases, they make running long commands a matter of typing a few keystrokes.

My longest alias is `glg`. It prints the Git log formatted in a compact way which also shows branches relationship.

```
alias glg="git log \
  --graph \
  --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue) %an%Creset' \
  --abbrev-commit"
```

Imaging having to write all that instead!

If you're looking for inspiration to create aliases you can find all mine [here](https://github.com/mokagio/dotfiles/blob/master/aliases).

While working be mindful of the commands you used the most. Once you find yourself using a command a few times during the day create an alias for it. After a week or two you'll have aliases for 80% of what you do in the terminal and you'll be very drastically faster and more productive.

Creating aliases for commands is just the beginning. You can also define [custom functions](https://ryanstutorials.net/bash-scripting-tutorial/bash-functions.php) for combination of commands.

There is no limit to how much you can do and the typing you can save in the terminal.

## Why aliases matter

Having to type less **removes the friction** from getting stuff done. Your brain won't have to expend energy for the spelling and typing of the commands you want to run.

Because you've created aliases that are only a few keystrokes long they'll soon become **muscle memory**. At that point your brain won't even have to think about them. Your fingers will do all the work.

There's also an health byproduct of doing less typing<sup>[2](#fn2)</sup>. Less typing means less work for your fingers. [Repetitive strain injuries](https://en.wikipedia.org/wiki/Repetitive_strain_injury), or RSI, are something every software developer should be careful of. If you can get the same amount of work done with less typing your risk of developing RSI decreases.

---

When preaching the value of using and customizing the terminal and Vim I often get push back like "I'm not paid to type, I'm paid to think. That's where I add value". Of course you are. **That's exactly why you should invest time to reduce the amount of typing you do. So that you can spend more time thinking and creating value.**

Having aliases and keyboard shortcuts tuned to your specific way of working is like taking notes by hand on blank paper. There is no friction, no boundaries, you can easily move from writing to drawing. **Less friction means more bandwidth for your mind to do what it needs to do.**

Don't take my word for it. Try it out for yourself. No one has ever come back to me saying "Gio why did you make setup aliases, I'm saving too much time now."

What aliases are you going to create? Let me know [on Twitter @mokagio](https://twitter.com/mokagio) or by leaving a comment below.

<p style="font-size: smaller"><a id="fn1">1</a>: Bash and other shells also support using an `rc` file. <a href="http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html">This post</a> has a good explanation of the difference between the two, and when to use one rather than the other.</p>
<p style="font-size: smaller"><a id="fn2">2</a>: If like me you like to play devil's advocate you could argue using the mouse reduces the amount of typing even more. True, but doing so moves most the stress to the two fingers for left and right click of the hand you use the mouse with. That's even worse. That's the reason software like Blender 3D don't rely only on the left clicking. As <a href="https://www.amazon.com/Blender-Dummies-Jason-van-Gumster/dp/1119039533">Blender for Dummies</a> explains: "<em>The more you can spread the work across the hand, the lower the chance of RSI. By making it so that you're not doing every single operation with the left mouse button, Blender helps in this regard.</em>"</p>
