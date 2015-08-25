---
layout: post
title: Enhancing XCTest test cases with Nimble matchers
description: "Nimble is a matchers framework built for Swift that provides powerful and versatile expectations. Writing test within the standard XCTest harness but using Nimble assertions is easier and productive, and a good combination of tools to introduce testing and TDD to colleagues and teams in a frictionless way."
tags:
  - Swift
  - TDD
  - Nimble
---

Here on mokacoding we've talked a number of times about the benefits of the [xSpec style](http://www.mokacoding.com/blog/better-tests-with-specta/) when writing unit tests.

There is a catch though. Because XCTest does not provide a DSL for xSpec style testing we need to use a third party library to write in this wonderful style. The best xSpec frameworks for Objective-C are, in alphabetical order, [Cedar](https://github.com/pivotal/cedar), [Kiwi](https://github.com/kiwi-bdd/Kiwi), and [Specta](https://github.com/specta/specta), while on Swift [Quick](https://github.com/Quick/Quick) is the one with the biggest traction.

Unfortunately the iOS world [doesn't have a strong testing culture](http://www.mokacoding.com/blog/ios-testing-in-2015/), **yet**, and is not uncommon to join a team where unit testing had to be introduced _from scratch_.

In such case dropping a framework combo like Specta + Expecta + [OCMock](http://ocmock.org/) might be too much for the team to handle in one go. It might be better to stick with XCTest and work on the team testing workflow instead.

If you decide to go with this approach you'll soon discover two things:

- The xUnit style is not as bad as you remembered.
- Everybody only uses `XCTAssert` and `XCTAssertEquals`.

That's the thing, the assertion provided by `XCTest` are not powerful enough, and way to verbose.

Let me introduce you to [Nimble](https://github.com/Quick/Nimble) a matcher framework for Swift (_and Objective-C_) that you can easily integrate in your `XCTestCase`s to have a way nicer and easy to write syntax.

This is how some usual assertion look when written using Nimble

```swift
XCTAssertEqual(anInt, 42)

expect(anInt) == 42
```

```swift
XCTAssert(aBool)

expect(aBool).to(beTrue())
```

```swift
XCTAssertFalse(anotherBool)

expect(anotherBool).to(beFalsy())
```

```swift
XCTAssertEqual(aString, "expected value")

expect(aString) == "expected value"
```

They read quite better, and in particular the relationship between actual and expected value is explicit. Plus, how neat is it to use `==` to test for equality? 😎

And it doesn't end here, Nimble provide syntactic candies like:

**Negative forms**

```swift
expect(batman.name).toNot(equal("Peter Parker"))
expect(ironman.name).notTo(equal("Barry Allen"))
expect(greenArrow.name) != "Matt Murdok"
```

**Math comparisons**

```swift
expect(actual).to(beLessThan(expected))
expect(actual) < expected

expect(actual).to(beLessThanOrEqualTo(expected))
expect(actual) <= expected

expect(actual).to(beGreaterThan(expected))
expect(actual) > expected

expect(actual).to(beGreaterThanOrEqualTo(expected))
expect(actual) >= expected
```

**Range comparisons**

```swift
expect(10.01).to(beCloseTo(10, within: 0.1))
expect(actual) ≈ (expected, delta)
expect(actual) == expected ± delta
```

**Async expectations**

```swift
expect(systemUnderTest.someState).toEventually(beTruthy(), timeout: 3)
```

**Swift 2 error handling**

```swift
expect{ try somethingThatThrows()  }.to(throwError())
```

You can learn about all the awesome matchers that Nimble provides out of the box in the [README](https://github.com/Quick/Nimble#built-in-matcher-functions), and if you need more expressive power you can even [write your own](https://github.com/Quick/Nimble#writing-your-own-matchers).

## Conclusion

[Nimble](https://github.com/Quick/Nimble) is a great Swift matcher framework. Integrating it with vanilla `XCTest` suites is easy and frictionless.

By providing an easy to use and powerful syntax for expectations you can help your team adopt unit testing and be productive, with a very smooth learning curve.

If you want some alternatives, have a look to [Expecta](https://github.com/specta/expecta) and [OCHamcrest](https://github.com/hamcrest/OCHamcrest).

Want to share your experience with Nimble or with introducing testing and TDD is your workspace? Tweet me [@mokagio](https://twitter.com/mokagio), or leave a comment below.

_Leave the codebase better than you found it._
