---
title: How to write code faster using snippets
description: 'Leveraging "snippets" is a way to get faster at writing code and free mental resources for problem solving. Most IDEs and text editor offer this feature, where you can write code scaffolding with a keyboard shortcut.'
tags:
  - Productivity
  - Xcode
  - Automation
date: 2018-10-16
og_image: "https://s3.amazonaws.com/mokacoding/2018-10-16-xcode-10-snippets-og-image.png"
---

Earlier this year I was humbled by the change of writing guest post 2 challenges in [Ben Orenstein](https://twitter.com/r00k)'s [Code Quality Challenge](https://www.codequalitychallenge.com/). One lesson was on the value of using **snippets**.

As software developers we are paid to solve problems, writing code is the mean to which we do it. If we can spend less time in the act of _writing_ and more in the act of _solving_ we'll deliver more value to our users, clients, or employer.

Snippets are a way to have your text editor or IDE do the typing for you. Using a predefined key phrase you can print the scaffold for functions or entire classes, then fill it up with your content.

Here's how snippets work in Xcode:

![Animated GIF showing snippets in action in Xcode 10.0](https://s3.amazonaws.com/mokacoding/2018-10-16-xcode-10-snippets.gif)

And here's how the [UtilSnip Vim plugin](https://github.com/sirver/UltiSnips) provides snippets:

![Example of how the UtilSnip plugin provides snippets for Vim](https://camo.githubusercontent.com/296aecf30e1607233814196db6bd3f5f47e70c73/68747470733a2f2f7261772e6769746875622e636f6d2f5369725665722f756c7469736e6970732f6d61737465722f646f632f64656d6f2e676966)

Like [investing in your terminal setup](https://www.mokacoding.com/blog/invest-in-your-terminal-to-become-a-better-developer/) configuring things such as aliases and scripts, having a wide array of snippets at your disposals is a great way to improve your productivity as a software developer.

A single snippet might not save you much typing, but as you add more and more their contribution becomes relevant. All these micro optimization **compound over time**.

Snippets, aliases, automation, touch typing, these are all productivity tactics aimed at **removing friction** between your mind thinking something and materializing it.

Once you become aware of the value of snippets you'll start seeing many occasions to create them.

- Language constructs like `if ... else ...` or `guard let ... else ...`
- Mundane setup code specific to a framework or library
- Test scaffolds

Today when writing code keep an eye out for things you find yourself writing over and over again. Try make a snippet for them and see the difference.

This [article from NSHipster](https://nshipster.com/xcode-snippets/) shows how to use snippets in Xcode. If alongside Xcode you also use a text editor here's how to configure snippets in:

- [Atom](https://flight-manual.atom.io/using-atom/sections/snippets/)
- [Sublime Text](http://docs.sublimetext.info/en/latest/extensibility/snippets.html)
- [Vim (via UtilSnip)](https://github.com/sirver/UltiSnips)
- [VSCode](https://code.visualstudio.com/docs/editor/userdefinedsnippets)

If your development environment doesn't support snippets you can use a third party tool. On macOS I'd recommend [Alfred](https://www.alfredapp.com/) or [Dash](https://kapeli.com/dash).

Online you can find snippets library, like [this one for Swift](https://github.com/burczyk/XcodeSwiftSnippets). They are great to take inspiration from, but I would recommend you configure your own snippets one at a time.

By working on setting up your own development environment you'll master it faster and really customize it to your very own needs, something copying someone else's configuration will never do.

Try spending a few days configuring and using your snippets and you'll see what a difference they make by removing the tedious task of writing scaffolding code.

If this post helped you getting started with snippets I'd love to hear about your experience. Or maybe you already use snippets? Then, what are your favourites? What do you use to store them?

Get in touch on Twitter at [@mokagio](https://twitter.com/mokagio) or leave a comment below.
