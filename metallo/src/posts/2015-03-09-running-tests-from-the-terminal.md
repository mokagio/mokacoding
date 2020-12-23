---
layout: post
title: How to run Xcode tests from the terminal
description: How to invoke xcodebuild to run the tests from the command line and how to format its output using xcbeautify or xcpretty
updated_at: "2021-01-08T13:49:47+1100"
tags:
- Testing
- Xcode
- Terminal
- Automation
---

This post shows how to run Xcode unit tests and UI tests from your terminal and how to format the output for readability with [`xcbeautify`](https://github.com/thii/xcbeautify) and [`xcpretty`](https://github.com/xcpretty/xcpretty).

Running the tests from the command line is a necessary step for [Continuous Integration](https://mokacoding.com/tag/CI/index.html) and can come in handy when working solo, too.
For example, you might want to run a script to automate publishing a build to TestFlight and run the unit and UI test suites as a pre-check.

## Running tests with `xcodebuild`

When you need to interact with an Xcode project from the terminal, `xcodebuild` is the first place to look in.
This command-line tool allows you to perform different _actions_ on an Xcode project or workspace, such as building, archiving, querying information, and of course, testing.

The `test` action is what you use to run tests from a certain scheme in an Xcode project:

```
xcodebuild \
  -project MyAwesomeApp.xcodeproj \
  -scheme MyAwesomeApp \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=14.3' \
  test
```

If your app uses a workspace, perhaps because of [CocoaPods](https://cocoapods.org/), you'll need to pass the `-workspace` option instead of `-project`: `-workspace MyAwesomeApp.xcworkspace`.

You can [run `instruments -s devices` to see a list of know devices](http://mokagio.github.io/tech-journal/2015/03/12/xcode-list-available-devices.html) to use as the `-destination` option.
Checkout my [`xcodebuild` destination cheatsheet](https://mokacoding.com/blog/xcodebuild-destination-options/) for more `-destination` tips & tricks.

`xcodebuild` produces a _dense_ output:

<!-- ![xcodebuild test output](https://s3.amazonaws.com/mokacoding/xcodebuild-vanilla.gif) -->

While it's great to have all of the build information at hand, most of it is irrelevant for the tests.
And all of that text will make it impossible to scroll back in your terminal window and take up unnecessary space in your CI logs.

Luckily, there are tools to format the raw `xcodebuild` input into something concise and informative.
I have two to recommend: the Swift-based `xcbeautify` and the Ruby-based `xcpretty`.

## Running tests with `xcodebuild` and `xcbeautify`

`xcbeautify` is a little Swift package that makes the `xcodebuild` output human-readable.

There are multiple ways to [install `xcbeautify`](https://github.com/thii/xcbeautify/tree/d2d1d466f72170c45554ad218e4421dd04706e4e#installation), the most straightforward being with [Homebrew](https://brew.sh/): `brew install xcbeautify`.

Once installed, using `xcbeautify` is simply a matter of piping the `xcodebuild` output through it:

```
xcodebuild \
  -workspace MyAwesomeApp.xcworkspace \
  -scheme MyAwesomeApp \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=14.3' \
  test \
  | xcbeautify
```

<!-- ![Screenshot with the xcbeautify output]() -->

You can use `xcbeautify` the Swift Package Manager and the [Bazel](https://bazel.build/) build system output, too.

If you are working on a project that doesn't rely on CocoaPods or [Fastlane](https://fastlane.tools/), then `xcbeautify` is an excellent and lightweight tool to use.

If, on the other hand, you already have [Ruby tooling](https://mokacoding.com/blog/ruby-for-ios-developers-bundler/) in your project setup, then it might be simpler to use `xcpretty`.
Fastlane [ships with `xcpretty`](https://github.com/fastlane/fastlane/blob/e2ff4990a44f28fa7b25d745666007dc8e315577/fastlane.gemspec#L61) so you don't have to add an extra step in your CI to install it.

Another scenario in which you might want to use `xcpretty` is if you want a different output format as it offers more formatters.

## Running tests with `xcodebuild` and `xcpretty`

To install `xcpretty`, add it to your `Gemfile` then run `bundle install`:

```ruby
# Gemfile
gem "xcpretty"
```

You can also install it globally via `gem install xcpretty`, but [using a `Gemfile` to manage your Ruby tools](https://mokacoding.com/blog/ruby-for-ios-developers-bundler/) makes it easier for a team and CI to always run on the same versions, avoiding "it works on my machine" issues.

Once you're setup, you can format the `xcodebuild` output by piping it through `xcpretty`:

```
xcodebuild \
  -workspace MyAwesomeApp.xcworkspace \
  -scheme MyAwesomeApp \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=14.3' \
  test \
  | bundle exec xcpretty
```

<!-- ![xcodebuild test with xcpretty output](https://s3.amazonaws.com/mokacoding/xcodebuild-xcpretty.gif) -->

_If you set up `xcpretty` via `gem install`, you don't need to call it via `bundle exec`._

For a more concise output, `xcpretty` can use the same formatting style as [RSpec](http://rspec.info/), which shows a dot for each test.
Optionally, you can also color the dot green if the test passed or red otherwise.

```
xcodebuild \
  -workspace MyAwesomeApp.xcworkspace \
  -scheme MyAwesomeApp \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 12,OS=14.3' \
  test \
  | bundle exec xcpretty --test --color
```

<!-- ![xcodebuild test with xcpretty RSpec style output](https://s3.amazonaws.com/mokacoding/xcodebuild-xcpretty-test.gif) -->

There are more formatters to choose from and other configuration options you can learn about [in the project's `README`](https://github.com/xcpretty/xcpretty).

---

Whether you decide to run your tests with vanilla `xcodebuild` or format their output with `xcbeautify` or `xcpretty`, I hope you found this tutorial useful.

If you have any questions regarding testing from the command line, leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

---

## Revision History

- [2015/03/09](https://web.archive.org/web/2015032304314.3/http://www.mokacoding.com/blog/running-tests-from-the-terminal/): First version
- [2021/01/08](#): Updated to include `xcbeautify` and streamlined rationale for why you'd want to run your tests from the terminal
