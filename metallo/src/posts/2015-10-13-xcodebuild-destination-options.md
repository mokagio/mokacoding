---
layout: post
title: Xcodebuild Destination Cheatsheet
description: "A collection of tips on how to configure the -destination option for the xcodebuild tool."
tags:
  - Xcode
---

When using `xcodebuild` there are cases in which you want to use the `-destination` option to configure which device or Simulator will be used by the tool, for example when doing `xcodebuild test`.

If you are like me your brain cannot retain the syntax and options for `-destination`, so here's a cheatsheet.

## Destination Specifier

The argument for `-destination` is called destination specifier, and its syntax is a list of comma separated `key=value` pairs.

The specifier `platform` key can be used to target one of the supported platforms. Each platform comes with its set of keys.

The supported platforms are:

* `OS X`, your Mac
* `iOS`, a connected iOS device
* `iOS Simulator`
* `watchOS`
* `watchOS Simulator`
* `tvOS`
* `tvOS Simulator`

### OS X

The Mac OS X platform accepts an `arch` keyword, which can be either `x86_64` or `i386`. `x86_64` is the default.

```
xcodebuild \
  -workspace MyMacApp.xcworkspace \
  -scheme MyMacApp \
  -destination 'platform=OS X,arch=x86_64' \
  clean test
```

### iOS

The `iOS` platform should be used when you want to run tests on a connected device.  It supports two keys, `id` and `name`. Either one of the two must be provided, but not both.

Use `name` to target a device using it's name, `id` to use its UUID.

```
xcodebuild \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination "platform=iOS,name=Gio's iPhone" \
  clean test
```

```
xcodebuild \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS,id=YOUR_PHONE_UUID' \
  clean test
```

### iOS Simulator

`iOS Simulator` is the platform I use more often. It supports the same `id` and `name` mutually exclusive keys as `iOS`, plus an `OS` key. `OS` expects a target version number, like `9.1`, or [`latest`](https://mokacoding.com/blog/how-to-always-run-latest-simulator-cli/), which is the default.

```
xcodebuild \
  -workspace MyApp.xcworkspace \
  -scheme MyApp \
  -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.1' \
  clean test
```

### tvOS and tvOS Simulator

The `tvOS` and `tvOS Simulator` platforms expect the same parameters as their iOS counter parts.

### watchOS and watchOS Simulator

`watchOS` and `watchOS Simulator` have a slightly different behaviour. Since a watchOS app is always build and deployed nested inside of an iOS app to use such a destination you will need to specify a scheme which is configured to run a WatchKit app, and specify the platform destination that is paired with the watchOS device you want to use.

```
xcodebuild \
  -workspace MyApp.xcworkspace \
  -scheme MyWatchKitApp
  -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.1' \
  build
```

### Unable to find destination

When in doubt with the destination parameter a good trick is to write some nonsense in as the destination specifier. `xcodebuild` will fail and then list all the available destinations for the given scheme:

```
xcodebuild: error: Unable to find a destination matching the provided destination specifier:
		{ platform:jibberish }

	The requested device could not be found because no available devices matched the request.

	Available destinations for the "MyApp" scheme:
		{ platform:iOS Simulator, id:5BBA1401-0C74-47A7-8709-9F6C1D9C9CBB, OS:9.1, name:iPhone 6s }
		{ platform:iOS Simulator, id:28FF0903-97D6-459B-8F34-D9436AEA3B87, OS:9.1, name:iPhone 6s Plus }
```

## Generic Platform

There are some `xcodebuild` actions, like `build`, that may be performed without an actual device. To target a platform generically prefix the destination specifier with `generic/`.

```
-destination generic/platform=iOS
```

## Multiple Destinations

You can specify multiple `-destination` options to make `xcodebuild` perform the action on multiple destinations.

## Timeout

The `-destination-timeout` option specifies the amount of time in seconds to wait before considering the specified destination unavailable. The default timeout is 30 seconds.

## Default Destination

If `-destination` is omitted, `xcodebuild` defaults to a destination compatible with the selected scheme. But, do you really trust Xcode to do the right thing for you? 😕

## List All Available Destinations

To list all the known destination you can use `instruments -s devices`. The output is a list in the format `name (OS) [UUID]`.

```
Giovanni’s Retina MacBook Pro [37B86DB5-FB69-56F7-A023-ECC6B90C3486]
Apple TV 1080p (9.0) [BCFBA897-9E8D-43BA-9EE0-A93B39615ECA]
Apple Watch - 38mm (2.0) [9366B46E-EB1D-4CF3-B7EE-6E1BCEE0F89E]
...
iPhone 6s (9.1) [5BBA1401-0C74-47A7-8709-9F6C1D9C9CBB]
iPhone 6s (9.1) + Apple Watch - 38mm (2.0) [303CB525-E04F-463D-B0E5-22E19278E88C]
...
```

---

You can find more information about the `-destination` option and `xcodebuild` itself by reading the [tool's manpage](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html): `man xcodebuild`.

I hope you will find these tip useful. Have you got something else to add, or a correction? What's you favourite `xcodebuild` combo? Leave a comment below or hit me up on Twitter [@mokagio](https://twitter.com/mokagio).

_Happy coding, and leave the codebase better than you found it._
