---
layout: post
title: How to add testing dependencies using Carthage, with Swift 2 and Xcode 7
description: "In this little tutorial we will see how to use Cathage, an OS X and iOS depencendy manager, to install libraries written in Swift 2 and Xcode 7, with a focus on the process to get testing dependencies."
tags:
- Xcode
- Carthage
- Tooling
date: 2015-07-21
---

Productivity is all about knowing your tools, and knowing which tool to use for the job. But do to so we need to _invest time into experimenting with other tools_ other than the one we are comfortable with. Even if the experiment turns out to be unsuccessful, by _going outside our comfort zone_ we learn to learn, which is probably the single most important thing that a software developer can do.

For what seems like a long time, but is actually just a couple of years, [CocoaPods](https://cocoapods.org) has been the tool that I and many other developers have used to manage dependencies in iOS and OS X projects. Recently, with the advent of Swift an new tool has entered the scene: [Carthage](https://github.com/Carthage/Carthage).

In this post we will look at how to use Carthage to install testing dependencies on an Xcode 7 + Swift 2 project. The testing framework of choice is [Quick](https://github.com/Quick/Quick), together with [Nimble](https://github.com/Quick/Nimble) to write cleaner assertions. You can find the code for this example [on GitHub](https://github.com/mokacoding/Quick-Nimble-Carthage-Setup), as usual.

## Carthage

Carthage is a very interesting dependency manager. It is written in Swift and does massive use of [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa), and its approach is focused on **simplicity**. Where CocoaPods does everything for us, Carthage only resolves, downloads, and -when necessary- builds dependencies, leaving us the responsibility of adding them to the project, using the methods and settings we find more appropriate.

You can install Carthage using [Homebrew](http://brew.sh/):

```bash
brew install carthage
```

## The Cartfile

The way to specify the dependencies in Carthage is with a `Cartfile`. This is how our looks like:

```
github "Quick/Quick" "v0.5.0"
github "Quick/Nimble" "v2.0.0-rc.1"
```

Note how we are specifying exact version numbers. This is because Swift 2 support has been added only in those version, and being all a work in progress we want to make sure we use a _stable_ version.

The Cartfile supports the usual operators for version requirements such as `~>`, `>=`, etc. You can read more about all the valid options [here](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile)

## Getting the frameworks

Resolving the dependencies, download the right versions, and finally build them is as easy as running a single command:

```bash
carthage update
```

But since we are installing frameworks using Swift 2, we need to switch the sdk used by `xcodebuild`, which is call by `carthage update` under the hood, to the Xcode 7 one, like this:

```bash
sudo xcode-select --switch /Applications/Xcode-beta.app/Contents/Developer
carthage update
```

Once `carthage update` has finished you will notice a `Carthage` folder, and a `Cathage.resolved` file. Remember to check-in to version control at least the `Carthage.resolved` file.

It's now time to import the frameworks into Xcode. Because we are only setting *testing depencendcies* we should add the to the test target only. To do that need to follow a different approach than the usual one. Quoting from Carthage's README:

> Because non-application targets are missing the “Embedded Binaries” section in their build settings, you must instead drag the built frameworks to the “Link Binaries With Libraries” build phase.

![Link Binaries animated screenshot](https://s3.amazonaws.com/mokacoding/2015-07-21-carthage-link-binaries-small.gif)

## Just another bit of setup

When building for iOS, due to an App Store bug we need to add a "Run Script" Build Phase, that will execute a script to work around the issue. This is the Run Script's content:

```
/usr/local/bin/carthage copy-frameworks
```

And these are the paths to our frameworks:

```
$(SRCROOT)/Carthage/Build/iOS/Quick.framework
$(SRCROOT)/Carthage/Build/iOS/Nimble.framework
```

![Run script animated screenshot](https://s3.amazonaws.com/mokacoding/2015-07-21-carthage-run-script-small.gif)

You can read more about the process [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios).

After that, we need to add the Carthage's build folder (`$(SRCROOT)/Carthage/Build/iOS`) to Framework Search Path, in recursive mode. This is apparently due to a regression (or is it a feature?) introduced by Xcode 7, more [here](https://github.com/Quick/Quick/issues/347).

![Framework Search Path screenshot](https://s3.amazonaws.com/mokacoding/2015-07-21-carthage-search-path-small.png)
Once that is done we can happily import our testing frameworks in the test target:

```swift
import Quick
import Nimble

class QuickNimbleCarthageSpec: QuickSpec {
  override func spec() {
    describe("Setting up Quick and Nimble for testing using Carthage") {
      it("is not very hard") {
        expect(true).to(beTruthy())
      }

      it("works very well") {
        expect(20 * 2 + 3 - 1).to(equal(42))
      }
    }
  }
}
```

![Test succeded screenshot](https://s3.amazonaws.com/mokacoding/2015-07-21-test-succeeded.png)

## Protip: Make them private

Since the frameworks used in the testing target do not concern the main one there is no reason to make their dependencies known to the parent project. To do this we simply have to declare those dependencies in the `Cartfile.private` file. Quoting from Carthage's docs:

```bash
mv Cartfile Cartfile.private
```

> Frameworks that want to include dependencies via Carthage, but do not want to force those dependencies on parent projects, can list them in the optional Cartfile.private file, identically to how they would be specified in the main Cartfile.

> Anything listed in the private Cartfile will not be seen by dependent (parent) projects, which is useful for dependencies that may be important during development, but not when building releases—for example, test frameworks.

---

I hope you found this post useful, and that you will consider trying [Carthage](c) in your next project. As always we should try to be pragmatic with our tools and always look for the best fit for the job. But to be able to take and informed decision there is only one way, getting exposure to as many different solutions as possible.

Remember to checkout the [example project on GitHub](https://github.com/mokacoding/Quick-Nimble-Carthage-Setup).

If you have feedbacks, suggestions, or want to report a mistake leave a comment below, or tweet me [@mokagio](https://twitter.com/mokagio).

_Happy coding, and leave the codebase better than you found it._
