---
title: Setting a Mac for Development
published: true

---

Last week I setup our new office Mac Mini, that we will use as CI server for our iOS apps (finally!), and for other tasks, such as a constant view on our products analytics.

Our machine is the workshop where we create awesomeness (or bugs). I always enjoy setting up a machine for development, but I've always ended up mad at something, or spending ages looking how to install this or that. So this time, once and for all, I took note of every step, and here's my little checklist on how to set up a Mac for development.

_Note: the original version of this post was long and basically just me blabbering about the usual suspects, Ruby, Node, Xcode… I refactored it in a condesed version. No need to thank me._

###The foundations: brew and zsh

#####[Homebrew](http://brew.sh/)

Save time, and your sanity, use homebrew!

	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

homebrew saves stuff in `/usr/local/bin`, so make sure it comes **before** the default `/bin` in the `$PATH`.

	export PATH=/usr/local/bin/:$PATH

####[zsh](http://www.zsh.org/)

	brew install zsh

Zsh is cool, and with [pretzo](https://github.com/sorin-ionescu/prezto) we can make it super shiny. Note that the following instructions are from the prezto README, [check it out](https://github.com/sorin-ionescu/prezto#installation) just to be sure they are up to date.

	zsh
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	setopt EXTENDED_GLOB
	for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
	  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
	done

Finally, set zsh as the default shell

	chsh -s /usr/local/bin/zsh

Open a new terminal window and enjoy.

###The basic tools for the workshop

####Ruby

Via [rvm](https://rvm.io/), of course!

	\curl -L https://get.rvm.io | bash -s stable
	rvm install 2.0.0

####Python

We want a proper version of [Python](http://www.python.org/), more info [here](https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python).

	brew install python

####Node

To get [Node.js](http://nodejs.org/) just head to the home page and hit the green "Install" button, it's the [reccomened way](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#osx)!

_Or use homebrew again:_

	brew install node
	
####Xcode and the Command Line Tools

Being an iOS developer there's not really a choice on this one…

Just [Xcode](https://developer.apple.com/xcode/), and then search for "Command Line Tools" in the "Downloads" tab of the "Preferences"
	
####Java

Apparently OS X doesn't come with Java ready for us, but at least installing it is easy, just try to use it in the terminal, and the installation wizard will start.

	java

###Time to fill the shelves with tools

* Open Safari and download [Chrome](http://www.google.com/chrome).
* Get [Alfred](http://www.alfredapp.com/) to never use the mouse again to open an app.
* [BetterTouchTool] is a free app to setup custom keyboard shorcut, globally or specific to an app.
* With [Caffeine](http://lightheadsw.com/caffeine/) you don't have to worry about the screensave starting when givin a talk.
* Looking for a light and super configurable text editor? [Sublime Text](http://www.sublimetext.com/) is what you're looking for.