---
title: Keeping Sanity with Multiple Versions of Xcode
description: Working with Xcode and Xcode-beta on the same machine can sometimes be confusing, this post shares some tools to help make it less so.
tags:
- Xcode
- Productivity
date: 2016-06-20
---

Last week was WWDC week, which as usually brings a lot of new goodness to our
day to day work, and most importantly *betas*.

Oh betas... Nothing excites us developer more than being able to try the shiny
new things before they get released to the public, and then share outraged
tweets on how none of them work.

For the next three months or so many of us will constantly have two versions
of Xcode in our dock, and that can sometimes be confusing.

The two things that usually slow me down are not knowing if the Xcode I'm
running is the latest or the beta, as my dock is always hidden, and CLI builds
failing because they've been run with the wrong version of `xcodebuild`.

In this post I've listed some tools to help make it less so.

### [xcode-toggle](https://github.com/schwa/xcode-toggle)

[`xcode-toggle`](https://github.com/schwa/xcode-toggle) by [Jonathan Wight
(@schwa)](https://twitter.com/schwa) is smart wrapper around `xcode-select
--switch` that simplifies switching between toolchain versions.

```
$ xcode-toggle -t
Switching to: /Applications/Xcode-beta.app
/Applications/Xcode-beta.app [Current]
/Applications/Xcode.app

$ xcode-toggle -t
Switching to: /Applications/Xcode.app
/Applications/Xcode-beta.app
/Applications/Xcode.app [Current]
```

It's called _toggle_ but it works with more than two versions of Xcode as well.

### [BetaWarpaint Xcode plugin](https://github.com/zats/BetaWarpaint)

This simple yet brilliant plugin by [Sash Zats
](https://twitter.com/zats) changes the style of the Xcode-beta toolbars
and alerts making it striped.

![](https://raw.githubusercontent.com/zats/BetaWarpaint/master/ScreenShot.png)

You're probably screaming "Xcode 8" doesn't support plug-ins! I know, and that
is very sad 😭, but I'm hopeful by the time you're reading this the Xcode team
will have realised what gigantic mistake it would be to prevent us from using
the great plugins that great developers have developed completely for free to
enhance the IDE. And by the way [there is a
workaround](https://github.com/alcatraz/Alcatraz/issues/475#issuecomment-225868817),
if you feel brave.

### swiftenv

Another tool that deserves being mentioned here is [`swiftenv`](https://github.com/kylef/swiftenv), written by [Kyle Fuller
](https://twitter.com/kylefuller), is a full-fledged Swift version manager.

Using `swiftenv` you can download stable and development snapshot versions of Swift and switch between them. And if you add a `.swift-version` file in any directory `swiftenv` will automatically switch to the version reported on that file when you `cd` into the directory.

You can read more about these and the other features of `swiftenv` on its [documentation website](https://swiftenv.fuller.li/en/latest/).

---

I'd really like all of us to always download and try each new beta version of
Xcode. We all know how useful it is to share beta of the apps we made with
users or clients to receive feedback. The same stand true for the Apple
developers in the Xcode team, our feedback is very valuable for them, and it
is in our best interest to let them know which kind of feature we need, and
what doesn't work.

On top of that starting to work now on the toolchain you'll need in 3 months
will make sure that when the time comes everything is ready, and you won't
have to stress and rush into moving from one version to the other.

If you know of another tool or trick to make working with Xcode-beta easier
please share it in the comments below, or get in touch with me on Twitter
[@mokagio](https://twitter.com/mokagio).

_Keep the codebase better than you found it._
