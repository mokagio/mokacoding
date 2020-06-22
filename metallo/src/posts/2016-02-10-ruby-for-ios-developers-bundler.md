---
layout: post
title: "Ruby for iOS Developers - Managing Ruby Tools with Bundler"
description: "Between CocoaPods and Fastlane, Ruby is an important part of the iOS developer toolchain. How can we reliably control the versions of the tools our project's automation is using in Ruby? Bundler is a simple way to specify Ruby dependencies and automate their setup."
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

In the [previous post](https://www.mokacoding.com/blog/ruby-for-ios-developers/)
we saw how to depart from the default system Ruby and take control and manage
the Ruby versions on our machine.

Today we are going to see how to guarantee that everyone that is working on our
projects can get a hold of all the Ruby tools needed, and make sure they are at
the same version.

## Bundler

The way I usually introduce [Bundler](http://bundler.io/) to iOS developers is
"like CocoaPods, but for Ruby". This is correct but a bit unfair, as it is
actually CocoaPods which took inspiratino by Bundler, not vice versa.

Bundler lets you specify your dependencies into a `Gemfile`, it installs or
update them for you, and finally makes sure that the executables your are
calling are actually the ones specified for the project.

## Setting up Bundler for iOS projects

Let's say you have an iOS app project, and that you have integrated some third
party libraries using CocoaPods, and written a couple of Fastlane tasks to
automate the beta distribution.

Your boss lets you know that a new dev will jump on board to help you tomorrow.
"At last!" you think, "Finally someone to help...". You want the setup of your
new team member to be as smooth as possible, and you also don't want to waist
time going through every Ruby tool they need. You also realise that you've been
using version 1.0.0.beta.3 of CocoaPods, you like leaving on the edge, and want
to make sure they'll use it as well. It's time to setup Bundler!

Bundler is a Ruby tool itself, so you can install it like this:

```
gem install bundler
```

Once installed you can setup your project to use Bundler with this command from
the root of your project:

```
bundle init
```

Note how the executable is called `bundle` while the tool is call Bundler. If
you think about it it does make sense, as you us a bundler to bundle things,
but we can all agree that it is a confusing name choice.

This will generate a template `Gemfile`. Like a `Podfile`, a `Gemfile` is
actually a Ruby file in which you can use a special [DSL](https://en.wikipedia.org/wiki/Domain-specific_language)
to specify which dependencies you are using, and their version.

This is how a `Gemfile` for an iOS project might look like:

```ruby
source "https://rubygems.org"

gem 'cocoapods', '1.0.0.beta.3'
gem 'fastlane', '~> 1.57.0'
```

The string after the gem names informs Bundler on the version requirement. In
our case CocoaPods should be exactly at version 1.0.0.beta.3, while Fastlane
latest version that is greater or equal than 1.57.0, but less that 1.58.0.

_Fun fact:_ Bundler and CocoaPods share the same dependency resolution library,
[molinillo](https://github.com/CocoaPods/Molinillo).

To install your dependencies simply run:

```
bundle install
```

## Bundle Exec

Installing the right version of a given tool is only the start, actually using the tool is what matters.

I can sometimes happen to be working on different projects at the same time
which are using different versions of a tool. Sometimes is not wise to always
use the latest version on all the projects, for example and older project might
be structured in an incompatible way.

Rather than going down the rabbit hole of updating or downgrading everything,
you can rely on Bundler to make sure you are actually using your tools in the
version specified in the `Gemfile`. This can be done by calling them through
Bundler via `bundle exec`, for example:

```
bundle exec pod install
```

That's quite verbose, so I'd recommend to use an [alias](https://en.wikipedia.org/wiki/Alias_(command))
for that. Mine is `be`, I actually have two special aliases for CocoaPods and
Fastlane, `bp` and `bf`.

---

Congratulations, by following the tips in this post and the [previous one]() you made your system and projects 100% Ruby safe, so that you don't have to worry about it any longer and focus on actually develop your apps.

I would like to remark that these small tweaks to your workflow will save you time on every version update of any of your dependencies, which is like once a day if you're using Fastlane, and make sure all the team is on the same page. This little 5 minutes investement will pay off very quickly.

I hope you found these posts useful. Feel free to get in touch on Twitter [@mokagio](https://twitter.com/mokagio)
if you have questions, suggestions, or need help with your Rubies. You can also leave a
comment below, and [signup to the newsletter](#subscribe) to avoid missing out on any new article.

_Leave the codebase better than you found it._
