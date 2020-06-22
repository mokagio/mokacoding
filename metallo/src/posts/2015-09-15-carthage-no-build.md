---
layout: post
title: An even lighter way to use Carthage
description: "Among the options Carthage, an iOS and OS X dependency manager, provides there is the --no-build one. Using this we can integrate dependencies in the form of Xcode projects rather than frameworks, keeping the repository slimmer and the CI time low. This approach is lighter than than the usual way to work with Carthage, but comes with some disadvantages too."
tags:
- Carthage
- Xcode
---

[Carthage](https://github.com/Carthage/Carthage) is an iOS and OS X dependency manager that aims to be simple to use and "out of your way". In this post we will look into a different way to integrate dependencies using Carthage than the standard one, an why you might want to use it.

As usual there is a [sample project](https://github.com/mokacoding/Quick-Nimble-Carthage-Setup/tree/no-build), which is the same used when we looked at [How to add testing dependencies using Carthage](https://www.mokacoding.com/blog/setting-up-testing-libraries-with-carthage-xcode7), but on a different branch.

The standard way to use Carthage is by having a `Cartfile` listing the dependencies, and then running `carthage update` to download them in the `Cathage/Checkouts` folder, and build each of those into frameworks located in the `Carthage/Build` folder, and finally the developer has to manually integrate in the project.

Looking at `gitignore`s around the web, for example [Carthage's own `gitignore`](https://github.com/Carthage/Carthage/blob/master/.gitignore), it seems recommended to ignore the `Carthage/Build` folder. This has the result that each new checkout of a project using Carthage has to run `carthage update` before being able to build, or the frameworks referenced in the project won't be found.

There are a lot of opinions among developers on whether to track dependencies into a project's SCM, and the truth is that each team should make a choice based on their specific requirements. When choosing not to track dependencies though two things have to be kept in mind:

* If the referenced dependency version disappears from the internet the project won't build ever again.
* CI boxes will have to install the dependencies at every run which takes more time, or have caching systems which increases complexity.

I tweeted in this regard, and [Tony Arnold](https://twitter.com/tonyarnold) replied to me suggesting a different approach than usual:

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/mokagio">@mokagio</a> <a href="https://twitter.com/jspahrsummers">@jspahrsummers</a> <a href="https://twitter.com/rob_rix">@rob_rix</a> personally, I use carthage with the `—no-build` option and just integrate the projects directly.</p>&mdash; Tony Arnold (@tonyarnold) <a href="https://twitter.com/tonyarnold/status/637118291585056768">August 28, 2015</a></blockquote>
 <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

## --no-build

The description of the `--no-build` option for the `update` command says, very straightforwardly: skip the building of dependencies after updating. This means that after running `carthage update --no-build` we won't have any `Carthage/Build` folder.

How to integrate the dependencies then?

The answer is in Tony's tweet: just integrate the projects directly 😎. To recap:

1. Define dependencies in the `Cartfile`.
2. Run `carthage update --no-build`.
3. Create a workspace for the project if you don't have one already.
4. Add all the dependencies' projects from the `Carthage/Checkouts` folder to the workspace.
5. 🎉Stuff works🎉

## Tradeoffs

Some advantages of this method are:

* No need to run any dependency update command on checkout, the project will build out of the box. This is great if you need to speed up your CI builds.
* No need to add the `copy-frameworks` Build Phase workaround for iOS projects.
* The dependencies source is available to the developers. This is great if you need to look into the source or modify it.

There are some disadvantages too:

* This is not the standard usage of Carthage, so you will need to document the `carthage update --no-build` invocation, or better script it.
* Each dependency is added to the workspace as a project, if you have more than a handful of dependencies the workspace navigator might become cluttered.
* Having the dependencies source available might tempt daredevil developers to modify it without realising that the change will be lost when the dependency is updated to a newer version.

As expected there are a number of pros and cons, and no solution comes out as the silver bullet. It is up to you and your team to take an informed decision, measure the outcome, and review it to decide if it is actually the best approach for you or not. The good news is that switching between one or the other is not hard at all, only a mundane add/remove of references in Xcode.

If you are using Carthage to manage your dependencies, with or without the `--no-build` option, I'd love to hear about it, leave a comment below or hit me up on Twitter [@mokagio](https://twitter.com/mokagio).

A big thanks again to [Tony Arnold](https://twitter.com/tonyarnold) for suggesting the workflow, and reviewing this post 👏.

_Happy coding, and leave the codebase better than you found it._

Ps. On the 17th and 18th of September I will be speaking at [YOW! Connected](http://connected.yowconference.com.au) in Melbourne, Australia, if you are there come around and say hi 😊.
