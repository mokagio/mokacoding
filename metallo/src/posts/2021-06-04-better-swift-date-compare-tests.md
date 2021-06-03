---
title: How to write better tests for Swift date comparisons
description: "Testing Swift date comparison code with XCTest can result in indeterministic tests because of the passage of time. To make tests robust and deterministic, decouple them from the system clock by injecting the reference date."
twitter_title: "Don't use `Date()` in your Swift tests"
og_description: Inject dates to decouple your tests from the passage of time.
tags:
- Testing
- Swift
- XCTest
og_image: https://s3.amazonaws.com/mokacoding/2021-06-04-alarm-clock.jpg
---

Dates are deceptive.
They seem simple at first, then you hit on edge-cases such as leap years, daylight saving, and the dreaded time zones, and your head starts spinning.
On top of that, there is the unstoppable passage of time, which can result in code that works in the present not working in the future.

![xkcd reference: Supervillain Plan](https://imgs.xkcd.com/comics/supervillain_plan.png
)

<p style="text-align: center; font-size: smaller">
_Source: [xkcd – Supervillain Plan](https://xkcd.com/1883/)._
</p>

Here's a simplified version of code I've seen out in the wild more than once:

```swift
// PromoCode.swift
struct PromoCode {
    let createdAt: Date
    // Expire after one year (without accounting for leap year)
    private let expiry: TimeInterval = 365 * 24 * 60 * 60

    func isExpired() -> Bool {
        return Date().timeIntervalSince(createdAt) > expiry
    }
}

// PromoCodeTests.swift
func testIsExpiredFalseBeforeOneYear() {
    let promoCode = PromoCode(createdAt: Date.with(year: 2020, month: 6, day: 7))
    XCTAssertFalse(promoCode.isExpired())
}
```

_Note: `Date.with(year:, month:, day:)` is a syntax sugar method, not part of the standard library. You can find its source [here](https://gist.github.com/mokagio/c1cb4fbdca1605b7659e0a0dcb62d08e)._

If you are reading this post after June 7th, 2021, you probably spotted the issue.
When the author wrote the test, it passed, but they didn't realize it would start failing once the clock reached June 7th, 2021.

A test failure like that will likely manifest out of the blue to the first developer who happens to run the test after the clock has passed over the expiration threshold.
If they're in a rush, they may be tempted to bump the date a few years, which is the equivalent of throwing the hot potato to our future selves.

When testing Swift code that compares dates, it's essential to remove the influence of the passage of time to avoid unexpected failures in the future.

There is a simple refactor we can make to avoid this issue once and for all.
We can decouple the test from the system clock by **injecting the reference date for the comparison operation**.

```swift
// PromoCode.swift
func isExpired(at referenceDate: Date = Date()) -> Bool {
    return referenceDate.timeIntervalSince(createdAt) > expiry
}

// PromoCodeTests.swift
func testIsExpiredFalseBeforeOneYear() {
    let promoCode = PromoCode(createdAt: Date.with(year: 2020, month: 6, day: 3))
    XCTAssertFalse(promoCode.isExpired(at: Date.with(year: 2021, month: 6, day: 3)))
}
```

Relying on `Date()` makes your non-deterministic because it produces a different value literally every time you run the tests.
Non-deterministic tests, that is, tests that don't behave in the same way every time you run them, cannot be trusted.
They may fail at any time and distract developers who experience them while working on unrelated parts of the codebase.

The best way to avoid the non-deterministic effect of time in your tests is to **avoid using `Date()`**.
On the other hand, `Date()` is the correct value to use in the production code.
We can use it outside the tests by defining it as the default value for the reference date parameter.
The default value makes the method simpler to test without compromising the ergonomics of how it's used in the production codebase.

Making dates injectable and decoupled from the current time results in robust tests and carries more information about the SUT behavior.
Moreover, having explicit date parameters is a way to make our code [honest](https://mokacoding.com/blog/honesty-oriented-programming/), revealing to the reader all the entry points that affect its behavior.

What other techniques do you use to write reliable tests for code interacting with dates and times?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

_If you want to learn more about writing good tests for your Swift applications, check out my book [Test-Driven Development in Swift with SwiftUI and Combine](https://tddinswift.com/)._

<p><em>Open Graph cover image by <a href="https://unsplash.com/@goumbik?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Lukas Blazek</a> on <a href="https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a></em></p>
