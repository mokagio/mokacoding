---
title: How to write unit test assertions for Swift Result values
description: "Result is one of the most useful types in the Swift language. Learn how to write better unit tests using Result in this XCTest tutorial."
twitter_title: "The many ways of testing Result"
og_description: "Tips and tricks to improve unit tests for Result values."
og_image: "https://s3.amazonaws.com/mokacoding/2020-12-02-swift-result-tests.jpg"
tags:
- Swift
- Testing
- XCTest
---

[`Result`](https://developer.apple.com/documentation/swift/result) is one of my favorite things about the Swift standard library.

If you're not familiar with it, here's a quick overview.
`Result` is an `enum` defined as:

```swift
@frozen enum Result<Success, Failure> where Failure : Error
```

There are two cases in `Result`:

```swift
case success(Success)
case failure(Failure)
```

Because it uses [generics](https://docs.swift.org/swift-book/LanguageGuide/Generics.html), you can use it do describe any kind of operation that can succeed or fail.
On top of that, it simplifies manipulating the wrapped `Success` and `Failure` values thanks to its functional transformations methods like `.map` and `.flatMap`.

Being an `enum`, though, it can be cumbersome to assert `Result` values in the unit tests.
In this tutorial, we'll look at a few ways to test `Result` values in Xcode with XCTest.

All the code in this post is also available [in this example project on GitHub](https://github.com/mokagio/TestingSwiftResult).

## Asserting `Result` when `Equatable`

If both the `Success` and `Failure` types in your `Result` conform to `Equatable`, you can assert the value using `XCTAssertEqual`.

```swift
import XCTest

class EquatableResultTests: XCTestCase {

    struct Foo: Equatable { let id: Int }
    struct EquatableError: Equatable, Error { let message: String }

    func testSuccess() {
        let result: Result<Foo, EquatableError> = .success(Foo(id: 123))

        XCTAssertEqual(result, .success(Foo(id: 123)))
    }

    func testFailure() {
        let result: Result<Foo, EquatableError> = .failure(EquatableError(message: "abc"))

        XCTAssertEqual(result, .failure(EquatableError(message: "abc")))
    }
}
```

This is by far the simplest way to verify code using `Result` in your unit tests.
If you can make the `Success` and `Failure` types of your `Result` `Equatable`, even just in the test target, then I'd recommend using this concise approach.

If either one or both the types wrapped in the `Result` cannot be made `Equatable`, there are more verbose but equally effective ways write tests for `Result`.

## Asserting a `Result` value is successful when not `Equatable`

<!-- TODO check how to word this properly with the Swift's docs -->
The simplest way to check if a `Result` value is in the `success` case, is to use the handy [`get()` method](https://developer.apple.com/documentation/swift/result/3139397-get) which returns the associated value if the instance is a `success` and throws otherwise.

```swift
func testResultSuccessGet() throws {
    let result = Result<Int, Error>.success(42)

    let value = try result.get()

    XCTAssertEqual(value, 42)
}
```

If the instance is a `failure`, `get()` will throw and the test will fail with the associated `Failure` error value.

Sometimes, you can't use a throwing function in your tests, so `get()` is out of the picture.
This is the case for example when you are inside a non-throwing closure.

In those cases, you can either use `guard case` or a plain `switch`.

```swift
func testResultSuccessExampleGuard() throws {
    let result = Result<Int, Error>.success(42)

    guard case .success(let value) = result else {
        return XCTFail("Expected to be a success but got a failure with \(result)")
    }

    XCTAssertEqual(value, 42)
}

func testResultSuccessExampleSwitch() throws {
    let result = Result<Int, Error>.success(42)

    switch result {
    case .failure(let error):
        XCTFail("Expected to be a success but got a failure with \(error)")
    case .success(let value):
        XCTAssertEqual(value, 42)
    }
}
```

## Asserting a `Result` value is a failure when not `Equatable`

The same strategy for the `success` case applies for `failure`, with the difference that there is no `get()` equivalent, so we're left with only `guard case` or `switch`.

```swift
func testResultFailureExampleGuard() {
    let result = ...

    guard case .failure(let error) = result else {
        return XCTFail("Expected to be a failure but got a success with \(result)")
    }

    // Run your assertions on the expected value of error here
}

func testResultFailureExampleSwitch() {
    let result = ...

    switch result {
    case .success(let value):
        XCTFail("Expected to be a failure but got a success with \(value)")
    case .failure(let error):
        // Run your assertions on the expected value of error here
    }
}
```

Both `guard case` and `switch` add clutter to the tests with their syntax.
To make the code easier to read, there are some helpful test helpers you can build.

## `Result` test helpers when either `Success` or `Failure` are `Equatable`

If only one of the types making up the `Result` can be `Equatable`, then you can leverage `XCTAssertEqual` with a reusable test helper method.

```swift
import XCTest

extension XCTestCase {

    func assert<T, E>(
        _ result: Result<T, E>,
        isSuccessWith value: T
    ) where E: Error, T: Equatable {
        switch result {
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        case .success(let resultValue):
            XCTAssertEqual(resultValue, value)
        }
    }

    func assert<T, E>(
        _ result: Result<T, E>,
        isFailureWith error: E
    ) where E: Equatable & Error {
        switch result {
        case .failure(let resultError):
            XCTAssertEqual(resultError, error)
        case .success(let value):
            XCTFail("Expected to be a failure but got a success with \(value)")
        }
    }
}
```

You can use these assertions in you tests like you would any other:

```swift
let result: Result<Int, TestError> = .success(42)

assert(result, isSuccessWith: 42)
assert(result, isFailureWith: TestError(message: "abc"))
```

If one of those assertions fail, Xcode will report the failure using the backtrace UI introduced in version 12.
That's because the failure occurred in the assertion function, not in the test itself.

![Screenshot of how Xcode 12 reports a failure with backtrace](https://s3.amazonaws.com/mokacoding/2020-12-02-test-failure-backtrace.jpg)


If you prefer the standard way of seeing test failures, you can make the helpers report inline by forwarding the call site location to the `XCTFail` method.

```swift
import XCTest

extension XCTestCase {

    func assert<T, E>(
        _ result: Result<T, E>,
        isSuccessWith value: T,
        message: (E) -> String = { "Expected to be a success but got a failure with \($0) "},
        file: StaticString = #filePath,
        line: UInt = #line
    ) where E: Error, T: Equatable {
        switch result {
        case .failure(let error):
            XCTFail(message(error), file: file, line: line)
        case .success(let resultValue):
            XCTAssertEqual(resultValue, value)
        }
    }

    func assert<T, E>(
        _ result: Result<T, E>,
        isFailureWith error: E,
        message: (T) -> String = { "Expected to be a failure but got a success with \($0) "},
        file: StaticString = #filePath,
        line: UInt = #line
    ) where E: Equatable & Error {
        switch result {
        case .failure(let resultError):
            XCTAssertEqual(resultError, error)
        case .success(let value):
            XCTFail(message(value), file: file, line: line)
        }
    }
}
```

Because the `file` and `line` parameters are both set using the special `#filePath` and `#line` default values, you'll never need to define them explicitly.
That means you can call the assertions exactly as you did before, only this time the failure will be inline.

![Screenshot of how Xcode 12 reports a failure inline using the helpers above](https://s3.amazonaws.com/mokacoding/2020-12-02-test-failure-inline.jpg)

As a bonus, the helpers above also have a closure to generate a custom error message if you want even more fine grained reporting.

![Screenshot of how Xcode 12 reports a failure inline using the helpers above and a custom error message](https://s3.amazonaws.com/mokacoding/2020-12-02-test-failure-inline-custom.jpg)

## Generic `Result` test helpers

If you really like the one liner nature of the test helpers, you can use them for a generic `Result`.

```swift
func assertIsSuccess<T, E>(
    _ result: Result<T, E>,
    then assertions: (T) -> Void = { _ in },
    message: (E) -> String = { "Expected to be a success but got a failure with \($0) "},
    file: StaticString = #filePath,
    line: UInt = #line
) where E: Error {
    switch result {
    case .failure(let error):
        XCTFail(message(error), file: file, line: line)
    case .success(let value):
        assertions(value)
    }
}

func assertIsFailure<T, E>(
    _ result: Result<T, E>,
    then assertions: (E) -> Void = { _ in },
    message: (T) -> String = { "Expected to be a failure but got a success with \($0) "},
    file: StaticString = #filePath,
    line: UInt = #line
) where E: Equatable & Error {
    switch result {
    case .failure(let error):
        assertions(error)
    case .success(let value):
        XCTFail(message(value), file: file, line: line)
    }
}
```

You can then use these helpers like this:

```swift
assertIsSuccess(result)
assertIsSuccess(result) { XCTAssertEqual($0, 42) }

assertIsFailure(result)
assertIsFailure(result) { XCTAssertEqual($0.message, "abc") }
```

---

Investing in your tests' readability makes identifying failures simpler, so you'll be able to fix them sooner.

I hope you found the this overview of the different ways to work with `Result` in your XCTest unit tests useful.

Do you know other ways to use `Result` in the tests?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).
