---
date: 2013-09-23
title: Setting a Mac for Development
description: A simple checklist of the basic tools to setup a Mac for development.
keyword: setup mac development
tags:
- Mac OSX
- Be smart, or at least try
- Reminders
slug: setup-a-mac-for-development
---

Last week I setup our new office Mac Mini, that we will use as CI server for our iOS apps (finally!), and for other tasks, such as a constant view on our products analytics.

Our machine is the workshop where we create awesomeness (or bugs). I really love setting up a machine for development, but I've always ended up mad at something, or spending ages looking how to install this or that. So this time, once and for all, I took note of every step, and here's my little checklist on how to set up a Mac for development.

_Note: the original version of this post was long and basically just me blabbering about the usual suspects, Ruby, Node, Xcode… I refactored it in a condesed version. No need to thank me._

###Setup OS X for Development: the checklist

####[Homebrew](http://brew.sh/)

Save time, and your sanity, use homebrew!

	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

homebrew saves stuff in `/usr/local/bin`, so make sure it comes **before** the default `/bin` in the `$PATH`.

	export PATH=/usr/local/bin/:$PATH

####[zsh](http://www.zsh.org/)

	brew install zsh

Zsh is cool, and with [prezto](https://github.com/sorin-ionescu/prezto) we can make it super shiny. 
<br/>
_Note:_ the following instructions are from the prezto README, [check it out](https://github.com/sorin-ionescu/prezto#installation) just to be sure they are up to date.

	zsh
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
	  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	done

Finally, set zsh as the default shell

	chsh -s /usr/local/bin/zsh

####[Ruby](https://www.ruby-lang.org/en/), of course via [rvm](https://rvm.io/)

	\curl -L https://get.rvm.io | bash -s stable
	rvm install 2.0.0

####[Python](http://www.python.org/), a proper one

	brew install python

####[Node.js](http://nodejs.org/)

Just head to the [home page](http://nodejs.org/) and hit the green "Install" button, it's the [reccomened way](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#osx)! _Or use homebrew again:_

	brew install node
	
####Xcode and the Command Line Tools

Get it from [Apple's Developer page](https://developer.apple.com/xcode/), and then search for "Command Line Tools" in the "Downloads" tab of the "Preferences".

There's also an [open source way](http://kennethreitz.org/xcode-gcc-and-homebrew/), but I haven't tried it.
	
####[Java](http://www.java.com/en/)

Apparently OS X doesn't come with Java ready for us, but at least installing it is easy, just try to use it in the terminal, and the installation wizard will start.

	java

####Some useful extra stuff

* [Chrome](http://www.google.com/chrome)
* [Alfred](http://www.alfredapp.com/)
* [BetterTouchTool](http://www.boastr.net/)
* [Caffeine](http://lightheadsw.com/caffeine/)
* [Sublime Text](http://www.sublimetext.com/)