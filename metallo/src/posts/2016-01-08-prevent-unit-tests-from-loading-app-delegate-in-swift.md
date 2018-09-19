---
layout: post
title: Prevent Unit Tests from Loading AppDelegate in Swift
description: "How to prevent the unit test target from loading the AppDelegate and have faster tests execution."
tags:
- Espresso
- Xcode
- Swift
- Testing
---

_Credits to [Witold Skibniewski](http://mr-v.github.io/about/) and [Paul Boot](http://qualitycoding.org/app-delegate-for-tests/#comment-61735) who shared the Swift 2.0 implementation in [Jon Reid](http://qualitycoding.org/)'s post ["How to Easily Switch Your App Delegate for Testing"](http://qualitycoding.org/app-delegate-for-tests/), and to Jon for wirting the post that started the conversation._

**Update 2018/09/19:** The code has been updated to work with Swift 4.2. You can find the previous implementations looking at the history of the [demo project](https://github.com/mokacoding/TestAppDelegateExample) on GitHub.

Here's how to have a dedicated `AppDelegate` for the unit test target in Swift:

```swift
//
// main.swift
//
import UIKit

private func delegateClassName() -> String? {
  return NSClassFromString("XCTestCase") == nil ? NSStringFromClass(AppDelegate.self) : nil
}

_ = UIApplicationMain(
  CommandLine.argc,
  CommandLine.unsafeArgv,
  nil,
  delegateClassName()
)

//
// AppDelegate.swift
//
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  // ...
}
```

Note how we have removed the `@UIApplicationMain` annotation from the app delegate class definition that Xcode generates for us, as that is now implemented by `main.swift`.

You can [checkout this example](https://github.com/mokacoding/TestAppDelegateExample) for a full project using this approach.

I really like how leaner and faster the test target is without having to perform all the initialization code that is done in the normal `AppDelegate`. I encourage you to adopt this simple approach.

On top of that, less things happening on the Simulator while testing == more confidence in the results 🎉.

_Leave the codebase better than you found it._
