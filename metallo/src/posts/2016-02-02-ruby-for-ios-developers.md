---
layout: post
title: "Ruby for iOS Developers - Managing Ruby Versions"
description: "Between CocoaPods and Fastlane, Ruby is an important part of the iOS developer toolchain. Managing versions and gems can be a challenge for developers outside of the Ruby community, but it doesn't have to be. In this two parts post we will see how to simply and reliably handle our Rubies."
tags:
- Ruby
- Automation
---

Like it or not [Ruby](https://www.ruby-lang.org/en/) plays a big part in most
iOS and Mac developers life. Tools we depend upon like [CocoaPods](https://cocoapods.org/),
[Fastlane](https://fastlane.tools/), and [XCPretty](https://github.com/supermarin/xcpretty)
are written in this language. With Swift going open source and getting more
mature we can expect this situation to change, but is not going to be any time
soon.

While being incredibly versatile, easy to pick up, and optimized for
developers' happiness, Ruby has some pitfalls when it comes to managing
versions and gems, Ruby's name for libraries.

How many time did you `sudo gem install`? Have you ever bumped into a gem that
wasn't behaving properly due to your Ruby setup? Or a `pod install` being
corrupted because your teammates were on a different version of CocoaPods? All
these problems are due to system Ruby.

Working with system Ruby is a problem for two reasons: you need root access to
install gems, and if you decide, or need, to upgrade Ruby all the other tools
will need to be upgraded as well, and might break.
[This article](https://robots.thoughtbot.com/psa-do-not-use-system-ruby)
by [Thoughtbot](https://thoughtbot.com/), one of the leading Ruby agencies with
a great list of open source libraries, explains the problem in more details.

Spending 5 minutes setting up your Ruby will save you hours of issues down the
track.

In this and the next post we'll take a look at how to install and manage
Ruby versions on your Mac, and how to make sure every team member is using the
same gem versions.

## Not all Rubies are made equal

Mac OS X Ruby set up requires you to use `sudo` for every gem install. This is
something that gets in your way. On top of that Macs ship with Ruby version
2.0.0, but the latest version of the programming language is 2.3.0. I don't
know about you, but this bothers me like me this bothers you.

To take back control of our Rubies we need a way to download new versions, and
optionally switch between them.

The developer community might not have reached an agreement on the best Rubies
version manager yet, but on thing is for sure, system Ruby isn't it.

Probably the most streamlined and less invasive way to manage your Rubies is
using [`chruby`](https://github.com/postmodern/chruby) and [`ruby-install`](https://github.com/postmodern/ruby-install).

These two tools follow the Unix philosophy of doing only one thing and being
composable. `ruby-install` allows you to download and install Ruby versions,
and `chruby` to switch between them.

Let's see how to set them up... At the end of this process you'll have a
development environment in which you can safely install gems without `sudo` or
permission issues, and where multiple versions of Ruby can live together in
harmony.

## ruby-install setup

Both `ruby-install` and `chruby` can be easily installed via [Homebrew](http://brew.sh).

```
brew install ruby-install
```

You can now easily install versions of Ruby system wise like this:

```
ruby-install --system ruby 2.3.0
```

You can leave the `--system` option out if want to install it only for your
local user.

**Pro-tip**: `ruby-install --system --latest ruby` will install the latest
version.

Installing Rubies is only half of our job, now we need to reliably set the
proper version and swap between them. This is `chruby`'s job.

## chruby setup

```
brew install chruby
```

Once brew has installed `chruby`, open your `.bashrc` or `.zshrc` and paste
these two lines at the bottom. If you don't know what those files are you
should read [this](http://superuser.com/questions/49289/what-is-the-bashrc-file)
first.

```
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
```

The first line will make sure that `chruby` is loaded in your shell. The
second makes `chruby` automatically switch Ruby version based on the content
of the `.ruby-version` file in the current directory. Automatically switching
is an optional feature that you might not need as an iOS developer, but I still
think it can be useful.

Since you just edited the configuration of your shell you will need to open a
new terminal window to load them. Alternatively you can `source ~/.bashrc`.

Congratulations, you can now set and change your Ruby version using:

```
chruby 2.3.0
```

That's it.

---

This post showed you how to gain control on your Ruby so that you can reliably
choose which version to use, and install gems without worry. In the next post
we'll look at how to manage the Ruby tools our projects depend upon, so that we
can rest assured that every team member and CI box will be using the same
version. [Signup to the newsletter](#subscribe) to be the first to now when its
published.

I hope you found this article useful. Feel free to get in touch on Twitter [@mokagio](https://twitter.com/mokagio)
if you have questions, suggestions, or need help with your Rubies, or leave a
comment below.

