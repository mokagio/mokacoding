---
title: How to make Swift methods unavailable
description: "A quick post showing how to use the Swift availability attribute to mark objects and functions as unavailable."
tags:
- Swift
- Espresso
date: 2016-06-07
---

It is sometimes handy to make a piece of code unavailable without actually deleting it. Two use cases come to mind:

- A subclass making methods of the superclass unavailable.
- Legacy code that we need to keep in the source to keep supporting old versions or documentation.

In such cases we can use Swift's `available` declaration attribute to tell the compiler that code using the marked object or function should not compile.

```swift
// Swift 2.2
@available(<platform>, unavailable=<version>, message=<message>)

// Swift 3
@available(<platform>, unavailable: <version>, message: <message>)
```

For example, if you have to subclass `NSObject` into something that has a stored constant which needs to be passed at initialization, and don't want to allow consumers to call `init` because it doesn't make sense to set a default value for the constant, you can make `init` unavailable to its consumers:

```swift
class Dummy: NSObject {

  let foo: String

  init(foo: String) {
    self.foo = foo
  }

	@available(*, unavailable)
	override init() {
    fatalError()
  }
}
```

Note how the `platform` parameter has `*` value, which means _any platform_, and `unavailable` has no version value, which means that the methods is unavailable regardless of the current version.

Unfortunately, as of 2.2, this kind of availability declaration is not converted into an Objective-C attribute, so Objective-C consumers will still see the methods and classes as available.

If you are reading this and know a way to make Swift code unavailable to both Swift and Objective-C callers, please let me know by leaving a comment below, or getting in touch on Twitter [@mokagio](https://twitter.com/mokagio). Thanks.

More on Swift's declaration attributes can be found [on the Apple's documentation page](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Attributes.html#//apple_ref/doc/uid/TP40014097-CH35-ID347).

_Leave the codebase better than you found it._
