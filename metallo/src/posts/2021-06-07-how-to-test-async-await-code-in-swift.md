---
title: How to test Swift async/await code with XCTest
description: "Swift 5.5 and Xcode 13 introduce the async/await pattern for concurrent code. This tutorial post shows how to write unit tests for asynchronous code in Swift using the XCTest framework."
twitter_title: How to test Swift async/await
og_description: "Testing async/await code is straightforward. Let me show you how."
og_image: https://s3.amazonaws.com/mokacoding/2021-06-07-async-await-test.jpg
tags:
- Xcode
- XCTest
- Testing
- Swift
---

⚠️ – _This post refers to beta software._
_I'll try to keep it up to date, but it's possible some of the code samples won't work out of the box._
_All the code is available on [GitHub](https://github.com/mokagio/xcode-13-experiments/)._
_Latest update:  Xcode 13.0 beta 1 (13A5154h)_


Concurrency was one of the biggest and most welcome additions to Swift officially announced at WWDC 2021.
Swift now supports the async/await pattern, first introduced [in F# in the late 2000s](https://en.wikipedia.org/wiki/Async/await#History) and then adopted in other languages including [JavaScript](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous/Async_await), [TypeScript](https://www.typescriptlang.org/play#example/async-await), and [Rust](https://rust-lang.github.io/async-book/01_getting_started/04_async_await_primer.html).

This is a huge improvement for developers and it will help describe the code in a way that is easier to reason about and safer to update.

Let's look at how to write unit tests for code using `async await` in Xcode 13 with [XCTest](https://mokacoding.com/tag/xctest/).

## How to unit test async/await code

I'm a sucker for culinary examples, my book [_Test-Driven Development in Swift_](https://tddinswift.com) uses a restaurant menu ordering app to teach TDD, and I was delighted to see Apple introduce async/await in the [Xcode 13.0 beta 1 release notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-13-beta-release-notes) using asynchronous functions to prepare dinner.
Let's stick with Apple's examples and write a test for the asynchronous `chopVegetables` method to ensure the vegetables are properly chopped by checking that the returning array has more than one element.

Because async/await is a feature at the Swift language level, to test an `async` function we can use the same approach we'd use to consume that code in production: call it with `await`.

```swift
func chopVegetables() async throws -> [Vegetable]

func testChoppingVegetablesReturnsManyVegetables() async throws {
    let vegetables = try await chopVegetables()
    XCTAssertGreaterThan(vegetables.count, 1)
}
```

That's it.

To appreciate how neater this is than the approach we used before the introduction of `async await`, let me show you the same test but for a `chopVegetables` version using callbacks and `Result`.

```swift
func chopVegetables(completion: @escaping (Result<[Vegetable], CookingError>) -> Void) { ... }

func testChoppingVegetablesReturnsManyVegetables() {
    let expectation = XCTestExpectation(description: "Chops the vegetables")

    chopVegetables { result in
        guard case .success(let vegetables) = result else { return }
        XCTAssertGreaterThan(vegetables.count, 1)
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1)
}
```

The contrast is striking.
asycn/await is certainly a welcome change on the testing side of the codebase, too!

## How do async/await tests fail?

If the code we're `await`ing throws, the test will fail like any other test that throws.

![screenshot of test failure](https://s3.amazonaws.com/mokacoding/2021-06-07-async-await-failure.jpg)

If you want to have more refined error handling, you can wrap the `try await` call in a `do catch`.

```swift
func testChoppingVegetablesReturnsManyVegetables() async {
    do {
        let vegetables = try await chopVegetables(using: Knife(sharpness: .low))
        XCTAssertGreaterThan(vegetables.count, 1)
    } catch {
        XCTFail("Expected chopped vegetables, but failed \(error).")
    }
}
```

Using `do catch`, you can generate more informative failures messages, which will help you triage and fix failed tests in the future.

## How to test the failure path in async/await code

You can use the `do catch` approach to verify how async/await code fails.

Let's extend the Apple examples by adding a `Knife` parameter to the chopping function and expecting an error to be thrown if the knife is blunt.

```swift
func testChoppingVegetablesThrowsWhenKnifeBlunt() {
    do {
        _ = try await chopVegetables(using: Knife(sharpness: .low))
        XCTFail("Expected to throw while awaiting, but succeeded")
    } catch {
        XCTAssertEqual(error as? CookingError, .knifeTooBlunt)
    }
}
```

Unfortunately the `XCTAssertThorwsError` and the other assertion APIs don't support concurrency yet, so `do catch` is the only option to test the error path of `async` code.

![screenshot of unsupported concurrency error](https://s3.amazonaws.com/mokacoding/2021-06-07-xctassertthrowserror.jpg)

---

The introduction of async/await in Swift is a fantastic improvement and the teams behind XCTest and Xcode 13 have done a great job enabling developers to write tests for this new breed of asynchronous code out of the box.
Not only it doesn't require learning new APIs, but also greatly improves conciseness and understandability in the test code.

What do you think of asycn/await?
Have you got any tips for testing asynchronous code?
Leave a comment below or reach out on Twitter at [@mokagio](https://twitter.com/mokagio).
