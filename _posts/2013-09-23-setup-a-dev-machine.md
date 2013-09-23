---
title: Setting a Mac for Development
published: true

---

Last week I setup our new office Mac Mini, that we will use as CI server for our iOS apps (finally!), and for other tasks, such as a constant view on our products analytics.

Our machine is the workshop where we create awesomeness (or bugs). I always enjoy setting up a machine for development, but I've always ended up mad at something, or spending ages looking how to install this or that. So this time, once and for all, I took note of every step, and here's my little checklist/guide on how to set up a Mac for development.

###The foundations: brew and zsh

We're gonna need [Homebrew](http://brew.sh/). Once, back in my Linux days, I was one of those guys that loved downloading the sources of every new tool or library needed, compiling them and… lose hours in the process of fixing dependencies, setting up paths, and so on. Seriously, we are developers, we want to ship fast, and we want our packages to be installed fast and without problems. **Save time, and your sanity, use homebrew!**

	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

* zsh + pretzo _watchout for the version, make sure BREW path (/usr/local/bin/) is before the defautl one and see [this](http://stackoverflow.com/questions/12032583/what-is-the-definitive-way-to-install-upgrade-set-the-default-version-of-zsh)_ + _for the path:_ `export PATH=/usr/local/bin/:$PATH`

####Note Xcode + Command Line Tools

* Xcode with Command Line Tools _it's needed by homebrew to work properly_

###The walls of the workshop

####Ruby

[Ruby](https://www.ruby-lang.org/en/) comes out of the box with OS X, but it's not how you should use it. [Rvm](https://rvm.io/) is a tool that let us have multiple versions of Ruby on the same machine and switch bewteen them when it's needed, safely. It's a great way to try the edge version without being worried of messing things up. Install it like this:

	\curl -L https://get.rvm.io | bash -s stable

And then get the lates version of Ruby, 2.0.0 at the time of writing:

	rvm install 2.0.0

####Python

Some of the developers I met are see the world black or white, or in this case green or red. It's either [Python](http://www.python.org/) or Ruby. But why don't use both, choosing based on the necessities? They're both screwdrivers, on has a flat blade, the other a Philips, the one to choose depends on the screw!

Like Ruby, Python comes out of the box with OS X, but we need a power version, because we're power developers. It's time to use homebrew!

	brew install python
	
If you want to know more read [here](https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python).

####Node

Incredebly fast, powerful, and simple. Here it is: [Node.js](http://nodejs.org/). To install it just head to the home page and hit the green "Install" button, it's the [reccomened way](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#osx)!

_Or you can use homebrew again:_

	brew install node
	
####Java

I'm a bit of a nostalgic so I would install it anyway, but Java is not only the first OO language I worked on, but also used under the hood by some of the tools you'll add to your shelf.

Apparently OS X doesn't come with Java ready for us, but at least installing it is easy, just try to use it in the terminal, and the installation wizard will start.

	java

###Time to fill the shelves with tools

* Open Safari and download [Chrome](http://www.google.com/chrome).
* Looking for a light and super configurable text editor? [Sublime Text](http://www.sublimetext.com/) is what you're looking for.
* Or perhaps you need more of an IDE? [JetBrains](http://www.jetbrains.com/) has a set of IDEs that are worth the price!
* Get [Alfred](http://www.alfredapp.com/) to never use the mouse again to open an app.
* [BetterTouchTool] is a free app to setup custom keyboard shorcut, globally or specific to an app.
* With [Caffeine](http://lightheadsw.com/caffeine/) you don't have to worry about the screensave starting when givin a talk.