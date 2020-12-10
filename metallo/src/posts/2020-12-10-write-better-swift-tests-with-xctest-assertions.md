---
title: Write better Swift unit tests with custom XCTest assertions
description: "The XCTest Swift testing framework has a limited offer of assertions. There's only so much you can do with XCTAssertTrue and XCTAssertEqual. This XCTest tutorial shows how to create custom assertions to make your unit tests and UI tests shorter and clearer."
og_description: "How to DRY your tests and clarify their intent with custom assertions"
og_image: https://s3.amazonaws.com/mokacoding/2020-12-10-assert-empty.jpg
tags:
- XCTest
- Xcode
- Swift
- Testing
---

Apple's Swift testing framework XCTest is a wonderful tool to write unit and UI tests, but the set of assertions it offers is not that rich.

Luckily, you can augment XCTest with your own set of assertions.
In this tutorial, we'll see how to write custom assertions for your unit tests in Xcode.

Custom assertions are great to DRY your code and they also help clarify your intent, making your tests clearer.

For example, say we want to check whether an array value is empty.

We could use `XCTAssertEquals(array.count, 0)`, so that if the test fails we'd get an error pointing out we expected it to be empty, but using `count` to check if an array is empty should be avoided because `isEmpty` is more performant.

We could then use `XCTAssertTrue(array.isEmpty)`, but this assertion fails with an unhelpful "XCTAssertTrue failed".

Wouldn't it be great if there was an assertion just to check if an array is empty?
Let's write our own!

## How to write a custom XCTest assertion

If you look under the hood of any XCTest assertion, you'll see that they are simple functions.
For example, here's the signature of [`XCTAssertTrue`](https://developer.apple.com/documentation/xctest/1500984-xctasserttrue):

```swift
func XCTAssertTrue(
    _ expression: @autoclosure () throws -> Bool,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
)
```

Notice the `file` and `line` parameters:
with their default parameters, they track the assertion call site, so Xcode can add the failure indicator and message in its UI if the test fails.

Writing a custom assertion means building a function similar to the `XCTAssert-` ones:
a function that performs your desired check on its input and reports failures inline using the `#filePath` and `#line` parameters.

Here's how to build a custom assertion to verify if a `Collection` type (like `Array`) is empty.

```swift
func assertEmpty<T>(
    _ collection: T,
    message: (T) -> String = { "Collection with \($0.count) elements is not empty" },
    file: StaticString = #filePath,
    line: UInt = #line
) where T: Collection {
    guard collection.isEmpty == false else { return }

    XCTFail(message(collection), file: file, line: line)
}
```

Let's unpack what the code does.

`func assertEmpty<T>(...) where T: Collection` uses a [generic type constraint](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID186) to tell the compiler it expects a `Collection` type.

In the body, we check whether the collection is empty, and if it isn't, we call the [`XCTFail`](https://developer.apple.com/documentation/xctest/1500970-xctfail) XCTest method to make the test fail.

To `XCTFail`, we pass the result of calling the `message` closure and the `file` and `line` input parameters.
All parameters have default values so that consumers can call the custom assertion by passing only the collection value to check.

Now we can express clearer intention in our tests when we check if a collection is empty:

```swift
let array = []
assertEmpty(array)
```

With this custom assertion, we also get a more explicit failure message:

![Screenshot of the test failure reported by Xcode: "failed - Collection with 3 elements is not empty"](https://s3.amazonaws.com/mokacoding/2020-12-09-xctfail.jpg)

Alternatively, we could have called [`XCTAssert`](https://developer.apple.com/documentation/xctest/1500669-xctassert) which "asserts that an expression is true," making the method a one-liner.

```swift
XCTAssert(collection.isEmpty, message(collection), file: file, line: line)
```

I prefer calling `XCTFail` because, with `XCTAssert`, the failure message would be "`XCTAssertTrue` failed - ..." which would be confusing to see inline in Xcode as there is no clear relationship between `assertEmpty` and `XCTAssertTrue`.

![Screenshot of the test failure message when using XCTAssert](https://s3.amazonaws.com/mokacoding/2020-12-09-xctassert.jpg)

Custom assertions can also help you to DRY your unit tests by extracting verbose checks.
For example by hiding away the clatter of a `switch` with [these assertions for `Result` types](https://mokacoding.com/blog/how-to-write-tests-for-swift-result#generic-result-test-helpers).

Writing custom assertions might seem daunting, but it takes only a few lines of code to get started.
Remember to pass the call site file and line through so that Xcode can report the failure where it occurred in the test and to use a custom message to make it easy to understand the failure.

---

**You spend as much time in the source code as you do in the test suite.**
**Investing a bit of time making your test code [clearer](https://mokacoding.com/blog/pipe-wrench/) will pay off dividends because it makes it easier to reason about it.**
Extracting common groups of assertions into a custom one or providing a dedicated method for a certain kind of check is an excellent way to make your tests more readable.

I hope you found this post useful.
If you want to share your custom assertions, leave a comment below, or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

If you found this post useful and want to learn more about unit testing in Swift, check out my book [_TDD in Swift, with SwiftUI and Combine_](https://bit.ly/tdd-in-swift).
