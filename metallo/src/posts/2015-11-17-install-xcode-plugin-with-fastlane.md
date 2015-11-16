---
layout: post
title: Installing Xcode plugins from the terminal with Fastlane
description: "How to install Xcode plugins from the terminal using Fastlane, and persist them across machines."
tags:
  - Xcode
  - Fastlane
---

If you are in the market for an Xcode plugin then [Alcatraz](http://alcatraz.io/) is the place to go. Alcatraz, an Xcode plugin itself, makes it easy to discover and install new plugins to enhance your development experience.

The only two features that Alcatraz doesn't provide are a CLI and an rc file. I value such features because they would allow to store my Xcode plugins list in [my dotfiles](https://github.com/mokagio/dotfiles) which are stored on [GitHub](https://github.com), allowing me to port them between machines by simply running one shell command.

CLI and rc [are planned](https://github.com/alcatraz/Alcatraz/issues/201) for Alcatraz's version 2 release, but in the meantime here's an alternative way.

## Fastlane to the rescue

I'm a big fan and user of [Fastlane](https://fastlane.tools/), an ever growing collection of tools that reduce friction in iOS and OS X development by automating mundane and error prone tasks, such as managing Provisioning Profiles, or taking screenshots for every device size.

At its core Fastlane has a `Fastfile`, a `Rakefile`-like file written in a Ruby DSL, where you can define _lanes_, which are the equivalent of Rake's tasks, and in each lane you can perform _actions_, such as running the test for the app, taking screenshot, distributing a beta version, and much more.

One of the available actions is `install_xcode_plygin`, which takes the URL of a zip file containing an Xcode plugin and downloads then install it for you.

By leveraging this action we can write a sort of `rc` file with the list of our favourite plugins, and automatically install them on new machines.

Here's how [mine](https://github.com/mokagio/dotfiles/blob/master/Fastlane/Fastfile) looks like:

```ruby
lane :install_xcode_plugins do
  [
    # The Xcode plugins manager
    'https://github.com/alcatraz/Alcatraz/archive/1.1.12.zip',

    # Plugins
    # Vim keybindings for Xcode
    'https://github.com/XVimProject/XVim/archive/v1.0-beta.zip',
    # Better fuzzy autocompletion
    'https://github.com/FuzzyAutocomplete/FuzzyAutocompletePlugin/releases/download/v2.1.1/FuzzyAutocomplete-2.1.1.zip',
    # Generate documentation stubs
    'https://github.com/onevcat/VVDocumenter-Xcode/archive/0.6.zip',
    # Show a color annotation on the gutter matching the code status in git
    'https://github.com/johnno1962/GitDiff/archive/v2.2.zip',
    # Show the color of a `UIColor` when the cursor is on it
    'https://github.com/NorthernRealities/ColorSenseRainbow/archive/v1.1.0.zip',

    # Themes
    'https://github.com/bojan/xcode-one-dark/archive/v2.zip',
    'https://github.com/ArtSabintsev/Solarized-Dark-for-Xcode/archive/2.0.0.zip',
  ]
  .each do |plugin_url|
    install_xcode_plugin(url: plugin_url)
  end
end
```

## Gotchas

There are two things to keep in mind when using this workflow. The first is that not all plugins unfortunately have a downloadable zip archive. The second is that there is no version update happening here, the same version is downloaded every time.

My recommendation is to use this method of installing plugins as the starting point for getting your favourites and Alcatraz itself, then manage them with it.

---

What do you think of this workflow? Do you need help with your Xcode plugins? Get in touch on Twitter [@mokagio](https://twitter.com/mokagio) or leave a comment below.

If you found this post useful please consider sharing it on your favourite social network 😉.

_Happy coding, and leave the codebase better than you found it._
