---
layout: post
title: How to use dependency injection for classes in Swift
description: In Swift it is possible to pass a reference to a type itself, not just to an instance of it. This post shows how to use this capability to test legacy code.
tags:
- Swift
- Testing
---

When working with legacy code, or rather code that has not been designed for testability, we often encounter components that provide static methods. Things like:

```swift
Helper.converValue(foo)

GlobalCounter.increase()

CustomLogger.logError(error)
```

These tools might seem advantageous because they can be easily used without the need for initialization, or for the consumer to retain them. On the other hand they are hard to test. The classic dependency injection pattern that we normally use doesn't apply here, we can't inject classes, or can we?

In Swift it is actually possible to define a reference to an actual type, rather than to an instance.

```swift
//...
class Foo {
  static func bar()
}

func f(fooClass: Foo.Type = Foo.self) {
  fooClass.bar()
}
```

This technique doesn't only work with classes. For Swift a type is a type, doesn't matter if `class`, `struct`, `enum` or `protocol`. You can use [this example Playground](https://github.com/mokacoding/swift-type-as-argument.playground) to verify it.

Once we know how to refer to actual types, we can apply the same "protocol-inject-mock" pattern that we're already familiar with to add test coverage to legacy code that we're not able to restructure at this point.

```swift
// GlobalHelper.swift
protocol GlobalHelper {
    static func someSideEffect()
}

// LegacyGlobalHelper.swift
class LegacyGlobalHelper: GlobalHelper {
    static func someSideEffect() { }
}

// MyService.swift
class MyService {
    func doStuffWithSideEffect(globalHelper: GlobalHelper.Type = LegacyGlobalHelper.self) {
        // ...
        globalHelper.someSideEffect()
        // ...
    }
}

// MyServiceSpec.swift
class GlobalHelperMock: GlobalHelper {
    static var someSideEffectCalled = false

    static func someSideEffect() {
        someSideEffectCalled = true
    }
}

// ...
describe("MyService") {
  context("when doing stuff") {
    it("performs a side effect") {
      let service = MyService()
      let mockHelper = GlobalHelperMock.self

      service.doStuffWithSideEffect(globalHelper: mockHelper)

      expect(mockHelper.someSideEffectCalled) == true
    }
  }
}
```

Note, testing for methods to have been called is not a good way to write tests. We should always try to assert behaviour rather than implementation details. Having tests that focus on behaviour rather than implementation enables us to change the inner workings of our software and still be confident that it performs as expected, that's what refactoring is all about.

The technique shown in this post is more of a workaround that you can use while dealing with legacy code that you can't easily refactor, but for which you need to have more confidence.

If you have any questions on injecting classes for the purpose of testing legacy code, or anything else testing related leave a comment below or get in touch on Twitter [@mokagio](https://twitter.com/mokagio).

_Leave the codebase better than you found it._
