---
title: Setting a Mac for Development
published: true

---

Last week I setup our new office Mac Mini, that we will use as CI server for our iOS apps (finally!), and for other tasks, such as a constant view on our products analytics.

I always enjoy setting up a machine for development, but I've always ended up mad at something, or spending ages looking how to install this or that. So this time, once and for all, I took note of every step, and here's my little checklist/guide on how to set up a Mac for development.

###The foundations: brew and zsh

We're gonna need [Homebrew](http://brew.sh/). Once, back in my Linux days, I was one of those guys that loved downloading the sources of every new tool or library needed, compiling them and… lose hours in the process of fixing dependencies, setting up paths, and so on. Seriously, we are developers, we want to ship fast, and we want our packages to be installed fast and without problems. **Save time, and your sanity, use homebrew!**

	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

* zsh + pretzo _watchout for the version, make sure BREW path (/usr/local/bin/) is before the defautl one and see [this](http://stackoverflow.com/questions/12032583/what-is-the-definitive-way-to-install-upgrade-set-the-default-version-of-zsh)_ + _for the path:_ `export PATH=/usr/local/bin/:$PATH`

####Note Xcode + Command Line Tools

* Xcode with Command Line Tools _it's needed by homebrew to work properly_

###The walls of the warehouse

* Java (_missing link_)
* rvm and ruby 2 (rvm install 2.0.0)
* Proper python
* node

###The tools

Open Safari and download [Chrome](http://www.google.com/chrome).

* Alfred
* Caffeine