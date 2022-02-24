---
title: What to do when XCTNSPredicateExpectation are slowing down your tests
description: "Each XCTNSPredicateExpectation requires a timeout of at least 1.1 seconds. That's too slow. Use Nimble's toEventually instead."
twitter_title: "PSA: XCTNSPredicateExpectation is too slow"
og_description: Use Nimble's toEventually instead to keep your tests snappy
og_image: https://mokacoding.s3.amazonaws.com/2022-02-25-xctnspredicateexpectation-tortoise.jpg
tags:
  - Nimble
  - XCTest
  - Swift
  - Testing
---

**TL;DR** `XCTNSPredicateExpectation` requires a timeout of at least 1.1 seconds or it will fail regardless of whether the behavior under test occurred.
To avoid slowing down your tests, use [Nimble](https://github.com/Quick/Nimble)'s `toEventually` instead.

---

Asynchronous code comes in various forms.
Callbacks, notifications, delegate calls, and most recently [async/await](https://mokacoding.com/blog/how-to-test-async-await-code-in-swift/).
Worry not, there's a way to test each of those.

When the asynchronous behavior you want to test changes the state of the system as a result of a method call that doesn't come with a callback to hook into, XCTest offers the [`XCTNSPredicateExpectation`](https://developer.apple.com/documentation/xctest/xctnspredicateexpectation) to [test it](https://mokacoding.com/blog/xctest-closure-based-expectation/).

```swift
// Arrange
// ...
let predicate = NSPredicate { _, _ in
  // some logic returning true if the expectation is met
}
let expectation = XCTNSPredicateExpectation(predicate: predicate, object: .none)

// Act
//
// call method on System Under Test that result in async behavior

// Assert
wait(for: [expectation], timeout: <# a timeout #>)
```

This approach comes in handy to verify how a `@Published` property changing as a result of a remote API call, like we see in Chapter 8 of [_Test-Driven Development In Swift_](https://tddinswift.com).

Let's put the pattern into practice with a "concrete" example.

Say we have an `AsyncWorkPerformer` object with a `toggleAsynchronously(after:)` method which changes the value of its `flag` property from `false` to `true`.
We can test it using `XCTNSPredicateExpectation` like this:

```swift
// Arrange
let sut = AsyncWorkPerformer()
let expectation = XCTNSPredicateExpectation(
    predicate: NSPredicate { _, _ in sut.flag },
    object: .none
)

// Act
sut.toggleAsynchronously(after: 0.1)

// Assert
wait(for: [expectation], timeout: 2)
```

In [the book](https://tddinswift.com), I recommended using 2 seconds for the timeout because, in my experience, waiting for 1 second or less with `XCTNSPredicateExpecation` can sometimes result in unexpected timeouts.

I decided to dig deeper and built a [benchmark test](https://github.com/mokagio/SlowPredicateExpectationExample) to discover exactly where the timeout safety threshold is.

With asynchronous code executing after a 0.1s delay:

- Waiting for 0.9 seconds or less always results in a timeout
- Waiting for 1 second can sometime result in a timeout
- Waiting for 1.1 seconds and above always succeeds

Details on the approach I used are at the end of the post.

## Why is `XCTNSPredicateExpectation` slow?

Apple engineer [Stuart Montgomery](https://twitter.com/throwspace) explains why this API is less performant than others in the 2018 WWDC talk [_Testing Tips & Tricks_](https://developer.apple.com/videos/play/wwdc2018/417/?time=2073).

![Images from the 2018 WWDC talk Testing Tips and Tricks](https://mokacoding.s3.amazonaws.com/2022-02-25-wwdc.jpg)

Simply put, `XCTNSPredicateExpectation` is slower because it uses [polling](https://en.wikipedia.org/wiki/Polling_(computer_science)) as opposed to more direct callback mechanisms—_and with a long sampling interval, too._

## What to do when `XCTNSPredicateExpectation` slowing your tests

Sometimes the best way to avoid a problem is not to have a problem in the first place.
To address the `XCTNSPredicateExpectation` performance overhead, _don't use `XCTNSPredicateExpectation`_.

**Use [Nimble](https://github.com/Quick/Nimble) instead.**

I've talked about Nimble [already](https://mokacoding.com/blog/waituntil-vs-toeventually/).
I love it.
It's an xSpec-style matcher library that provides a much more refined API than XCTest and also makes your suite read more like English.

You can [install Nimble via your favorite dependency management system](https://github.com/Quick/Nimble/tree/0bf627cd68085345ac52c165ba02d1f73c584eed#installing-nimble) and start using it straightaway.

Nimble comes with a `toEventually` API that allows waiting for a matcher to succeed.
Let's use it to make our test from above faster and clearer.

```swift
// Arrange
let sut = AsyncWorkPerformer()

// Act
sut.toggleAsynchronously(after: 0.1)

// Assert
expect(sut.flag).toEventually(beTrue())
```

Using Nimble, your tests won't have to wait for 1+ seconds because `toEventually` checks its condition every [10 milliseconds](https://github.com/Quick/Nimble/blob/c69d8cb2b1cffde9b18f62c4c4e846051e511c19/Sources/Nimble/Matchers/Async.swift#L10) [by default](https://github.com/Quick/Nimble/blob/c69d8cb2b1cffde9b18f62c4c4e846051e511c19/Sources/Nimble/Matchers/Async.swift#L86).

---

**Do yourself, your team, and your CI a favor and rewrite all your tests using `XCTNSPredicateExpectation` with Nimble's `toEventually`.**

Adding this extra dependency is a well worth cost to pay for the improve in test performance, even if you don't plan to use Nimble's APIs anywhere else in your suite.

## Appendix: Method used

To test how `XCTNSPredicateExpectation` performs, I built a dummy object performing an asynchronous property toggle:

```swift
class AsyncWorkPerformer {

    private(set) var flag = false

    func toggleAsynchronously(after interval: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.flag.toggle()
        }
    }
}
```

I then wrote tests for this behavior like the one shown at the start of the post using different timeout values.

I used the `XCTExpectFailure` API to mark all the failures in tests with short wait times as expected.
This achieves two goals: Keeps the test report neat without a barrage of red crosses and, if Apple will improved `XCTNSPredicateExpectation` in the future making those examples pass, the test suite will alert me of it.

To make the benchmark more thorough, I used the "Up Until Maximum Repetitions" Test Repetition mode [introduced in Xcode 13](https://mokacoding.com/blog/wwdc21-whats-new-in-testing/) to repeat each test three time, regardless of their result.

Here's a sample of the inconsistent results one gets when using a 1 second interval:

Example 1: Fail. Success. Success.

![1 second test failed, succeeded, succeeded](https://mokacoding.s3.amazonaws.com/2022-02-25-example-1.jpg)

Example 2: Success. Fail. Fail.

![1 second test succeeded, failed, failed](https://mokacoding.s3.amazonaws.com/2022-02-25-example-2.jpg)

Example 3: Success. Fail. Success.

![1 second test succeeded, failed, succeeded](https://mokacoding.s3.amazonaws.com/2022-02-25-example-1.jpg)

I run the benchmark on my late 2019 16" MacBook Pro as well as on the GitHub Actions CI.
The results were the same, which is unsurprising because the `XCTNSPredicateExpectation` performance limitations are due to its design not to how resource intensive it is.

<p><em>Open Graph Image by Photo by <a href="https://unsplash.com/@veverkolog?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Dušan veverkolog</a> on <a href="https://unsplash.com/s/photos/tortoise?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></em></p>
