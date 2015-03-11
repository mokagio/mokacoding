---
layout: post
title: Running Xcode tests from the terminal
description: In this post we take a look at how to run Xcode tests suites from the terminal with xcodbuild and xcpretty, and why you should do it
tags:
- Testing
---

In this post we'll see how to run Xcode tests from the terminal, and why you might want to do it.

If you've installed the [Command Line Tools](http://railsapps.github.io/xcode-command-line-tools.html) you'll see that from your terminal you can call `xcodebuild`.

Reading through the output of `man xcodebuild`, available online [here](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html), we find that:

> xcodebuild builds one or more targets contained in an Xcode project, or builds a scheme contained in an Xcode workspace or Xcode project.

So the first impression, as the name suggests by the way, is that `xcodebuild`'s purpose is to build Xcode projects. Not really what we're looking for since we want to run tests. But if we keep reading `XCODEBUILD(1)` we'll find a section listing the possible build actions, and test is one of them.

> Test a scheme from the build root (SYMROOT).  This requires specifying a scheme and optionally a destination.

After a bit more reading through `xcodebuild` man page and Apple's [Command-Line Testing resource](https://developer.apple.com/library/prerelease/ios/documentation/DeveloperTools/Conceptual/testing_with_xcode/A2-command_line_testing/A2-command_line_testing.html) we can write the minimum viable command to run our tests:

```
xcodebuild \
  -workspace MyAwesomeApp.xcworkspace \
  -scheme MyAwesomeApp \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.1' \
  test
```

Note that we're assuming that MyAwesomeApp uses CocoaPods, therefore we're using the `-workspace` option, which then requires to use `-scheme`.

You can use `instruments -s devices` to see a list of know devices to use in the `-destination` option, [more here](http://mokagio.github.io/tech-journal/2015/03/12/xcode-list-available-devices.html).
If you try to do this you'll see something like this:

![xcodebuild test output](https://s3.amazonaws.com/mokacoding/xcodebuild-vanilla.gif)

Not a very pleasant output is it?

This is where [`xcpretty`](https://github.com/supermarin/xcpretty) comes to the rescue. `xcpretty` is a tool designed to format `xcodebuild`'s output, and make it human readable.

Using `xcpretty` is very simple:

```
xcodebuild \
  -workspace MyAwesomeApp.xcworkspace \
  -scheme MyAwesomeApp \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.1' \
  test | xcpretty
```

![xcodebuild test with xcpretty output](https://s3.amazonaws.com/mokacoding/xcodebuild-xcpretty.gif)

If you're an [RSpec](http://rspec.info/) fan like me, that you'll want _the green dots_ in your tests output:

```
xcodebuild \
  -workspace MyAwesomeApp.xcworkspace \
  -scheme MyAwesomeApp \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.1' \
  test | xcpretty --test --color
```

![xcodebuild test with xcpretty RSpec style output](https://s3.amazonaws.com/mokacoding/xcodebuild-xcpretty-test.gif)

You might now ask _"This is all interesting and colorful, but why should I use it?"_. Here's some reasons why I like running tests from the terminal, and why you might like it too:

#### That's what the CI is doing

When running tests from CI you'll need to run tests from the terminal. It is very wise to test the behaviour of the CI scripts on your local machine. If something breaks in the pipeline you'll notice before pushing to master and breaking the build.

#### Better output

The visual feedback that the dots in the terminal give me is much more powerful that the view in Xcode.

#### Do you really trust Xcode?

<blockquote class="twitter-tweet" data-cards="hidden" lang="en"><p>Here&#39;s one of the reasons I run tests from the terminal! <a href="http://t.co/38V7sUmLEY">pic.twitter.com/38V7sUmLEY</a></p>&mdash; Giovanni Lodi (@mokagio) <a href="https://twitter.com/mokagio/status/565703081237970944">February 12, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

I'm a big fan of the terminal and of doing things through CLIs, so for me having to move to it to run the test instead of hitting `⌘U` is not a big deal. Regardless of your workflow preferences though, there are cases when automation is needed, and that's when knowing how to run tests form the terminal will come handy.

Note: another tool you might want to try is [xctool](https://github.com/facebook/xctool). I prefer the xcodebuild | xcpretty combo because it adds less overhead. If you're interested have a look at this [NSHipster post](http://nshipster.com/xctool/).

_Happy coding, and keep the codebase better than you found it_.

