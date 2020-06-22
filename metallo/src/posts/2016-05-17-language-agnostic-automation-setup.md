---
layout: post
title: Language Agnostic Automation Setup
description: "Every project can benefit from having a set of scripts to automate tasks such as running tests or distributing to testers. When setting up automation for your projects you can use a language agnostic setup. This will make it easier for new team members to get started, and allow you to change the setup without having to change the way the scripts are invoked."
tags:
- Automation
- CI
- Productivity
---

A while ago a read a blog post by [Parker Moore](https://byparker.com/) titled
"[Language-Agnostic Interfaces for Software
Development](https://byparker.com/blog/2015/language-agnostic-interfaces-for-software-development/)".

> Don’t let the title fool you, the concept here is simple: provide simple
> scripts in your repositories so – no matter the language or tools used – a
> newcomer to the code base can get started quickly and easily.

I found the idea interesting at the time, but only recently I came to
appreciate it fully, and apply it on my personal and client projects.

The benefits of this approach are clearer when used on projects developed by a
team rather than an individual. Co-workers don't need to know about the setup
implementation details to use it, they just need to run a command from the
terminal.

Compare explaining to someone that to distribute the latest beta they need to
execute `bundle exec fastlane test` because we decided to use
[Fastlane](https://fastlane.tools/), which is distributed as a [Ruby
gem](https://rubygems.org/), and its [better to use Ruby tools via
Bundler](https://www.mokacoding.com/blog/ruby-for-ios-developers-bundler/), with
saying to them "run `bin/distribute_beta`".

Hiding these implementation and invocation details not only will simplify
usage, but also make sure they do it properly. It's easy to forget to call Ruby
tools via `bundle exec`, or miss some option when calling `carthage update`.

Another bonus of using a language agnostic setup is that if you change the
implementation of the automation scripts their interface will stay the same.
You'll be able to migrate from one tool to another, for example from barebones
`xcodebuild` invocations to a more advanced `Fastfile`, without your teammates
noticing.

Of all the teammates one in particular will be thankful for a language agnostic
setup, the CI. If the way to run the test and any other automated action
doesn't change, then neither will the CI setup.

## How does it look like

Enough talking, let's look at some code. You can find a sample project
configure with language agnostic automation scripts [on
GitHub](https://github.com/mokacoding/agnostic-automation-setup).

The project has a `bin` folder in its root, with a number of executable scripts
inside. [Parker's original
post](https://byparker.com/blog/2015/language-agnostic-interfaces-for-software-development/)
has a `scripts` folder instead, I prefer to use `bin`, you should use what
makes most sense for you.

Usually you would have scripts like:

- `bin/bootstrap`
- `bin/test`
- `bin/distribute_beta`

The name of each script is self explanatory, and that's all someone needs to
know to get started.

To prove my argument that having this kind of setup will save you time managing
your CI I changed the implementation of the test script a couple of times,
every time keeping the build green and with no change to the CI configuration.
See it for yourself by looking at [the
commits](https://github.com/mokacoding/agnostic-automation-setup/commits/master)
and [the
builds](https://travis-ci.org/mokacoding/agnostic-automation-setup/builds).

---

I hope with this post and the example repo to have made you curious about the
language agnostic automation setup and showed you how to get started.

Every project has its own story and automation requirements, there is no
one-size-fits-all, you will have to find out what works best for you and your
team.

I'd love to hear feedback on the idea, and if you're using it, how it's working
out for you. Hit me up on Twitter [@mokagio](https://twitter.com/mokagio) or
leave a comment below.

_Leave the codebase better than you found it._

### PS: A note on "having to explain things" to co-workers

> "Give a man a fish and you feed him for a day. Teach a man to fish and you feed him for a lifetime."
> Chinese proverb

I am a firm believer that understanding the internal of a system is the best
way to use it properly and be productive with it. When I'm suggesting to use a
language agnostic setup I'm not advocating for not having to explain how
automation works to them, I'm just arguing that **to get someone started** one
single command is better that a combination of commands. It is then up to you
to find the time to explain the implementation details, either in person, with
documentation, or why not with a blog post like this one. There's nothing
better than learning something and sharing it with others.
