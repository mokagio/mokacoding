---
title: Unit Testing Combine Publisher Cheatsheet
description: Snippets to test the behavior of Combine Publishers in XCTest ready to copy and paste into Xcode
tags:
- Testing
- Combine
- Xcode
- XCTest
og_image: https://s3.amazonaws.com/mokacoding/2021-02-11-ogcover.jpg
---

Here's an easy to copy and paste reference on how to write common test assertions for Swift Combine `Publisher`s in XCTest in Xcode.

- [How to test `Publisher` publishes one value then finishes](#how-to-test-publisher-publishes-one-value-then-finishes)
- [How to test `Publisher` publishes one value then a failure](#how-to-test-publisher-publishes-one-value-then-a-failure)
- [How to test `Publisher` publishes many values then finishes](#how-to-test-publisher-publishes-many-values-then-finishes)
- [How to test `Publisher` publishes many values then a failure](#how-to-test-publisher-publishes-many-values-then-a-failure)
- [How to test `Publisher` publishes no values then finishes](#how-to-test-publisher-publishes-no-values-then-finishes)
- [How to test `Publisher` publishes no values then a failure](#how-to-test-publisher-publishes-no-values-then-a-failure)


You can see these snippets in action and experiment with the syntax by checking out the [example project](https://github.com/mokagio/TestingCombineExamples).

While researching this post, I found that there is too much boilerplate required to test a `Publisher`, resulting in code that is harder to read.
I started building a Swift Package to try addressing this problem: **[CombineTestHelpers](https://github.com/mokagio/CombineTestHelpers)** provides handy one liners for each scenario in this cheat sheet and more.

In the snippets below you'll see some code in the form `<# ... #>`.
That's the source code placeholder Xcode notation and makes it easier to adapt the code to your needs.
Xcode will let you jump to those placeholders with `Tab`.

All the examples in this cheat sheet follow the same pattern:
to test a Combine `Publisher`, define an `XCTestExpectation` and make the test subscribe to the publisher with `sink(receiveCompletion:, receiveValue)`.
Fulfill the expectation in either the value or completion closure, depending on the kind of behavior you want to verify.
If necessary, you can run one or more `XCTestAssert-` assertions on the value and completion you receive.

## How to test `Publisher` publishes one value then finishes

<!-- If you want to ensure your `Publisher` publishes only one value, fulfill the expectation in its `receiveCompletion` closure. -->

```swift
let expectation = XCTestExpectation(description: "Publishes one value then finishes")

var values: [<# Publisher Output type #>] = []

publisher
    .sink(
        receiveCompletion: { completion in
            guard case .finished = completion else { return }
            expectation.fulfill()
        },
        receiveValue: { value in
            guard values.isEmpty else {
                return XCTFail("Expected to receive only one value, got another: (\(value))")
            }
            XCTAssertEqual(value, <# expected value #>)
            values.append(value)
        }
    )
    .store(in: &cancellables)

wait(for: [expectation], timeout: 0.5)
```

### How to test `Publisher` publishes one value then a failure

<!-- In the previous example, we expected the stream to successfully complete. -->
<!-- If instead you're working with a publisher that sends one value then fails, you'll need to fulfill the expectation in the `receiveCompletion` closure but only if the value is a `.failure`. -->
<!-- Optionally, you may also assert the received error. -->

```swift
let expectation = XCTestExpectation(description: "Publishes one value then fails")

var values: [<# Publisher Output type #>] = []

publisher
    .sink(
        receiveCompletion: { completion in
            guard case .failure(let error) = completion else { return }
            XCTAssertEqual(error, <# expected error #>)
            expectation.fulfill()
        },
        receiveValue: { value in
            guard values.isEmpty else {
                return XCTFail("Expected to receive only one value, got another (\(value))")
            }
            XCTAssertEqual(value, <# expected value #>)
            values.append(value)
        }
    )
    .store(in: &cancellables)

wait(for: [expectation], timeout: 0.5)
```

### How to test `Publisher` publishes many values then finishes

```swift
let expectation = XCTestExpectation(description: "Publishes values then finishes")

var values: [<# Publisher Output type #>] = []

publisher
    .sink(
        receiveCompletion: { completion in
            guard case .finished = completion else { return }
            expectation.fulfill()
        },
        receiveValue: {
            values.append($0)
        }
    )
    .store(in: &cancellables)

wait(for: [expectation], timeout: 0.5)

XCTAssertEqual(values, <# expected values #>)
```

### How to test `Publisher` publishes many values then a failure

```swift
let expectation = XCTestExpectation(description: "Publishes many values then a failure")

var values: [<# Publisher Output type #>] = []

publisher
    .sink(
        receiveCompletion: { completion in
            guard case .failure(let error) = completion else { return }
            XCTAssertEqual(error, <# expected error #>)
            expectation.fulfill()
        },
        receiveValue: {
            values.append($0)
        }
    )
    .store(in: &cancellables)

wait(for: [expectation], timeout: 0.5)

XCTAssertEqual(values, <# expected values #>)
```

### How to test `Publisher` publishes no values then finishes

```swift
let expectation = XCTestExpectation(description: "Finishes without publishing values")

publisher
    .sink(
        receiveCompletion: { completion in
            guard case .finished = completion else { return }
            expectation.fulfill()
        },
        receiveValue: {
            XCTFail("Expected to finish without receiving any value, got \($0)")
        }
    )
    .store(in: &cancellables)

wait(for: [expectation], timeout: 0.5)
```

### How to test `Publisher` publishes no values then a failure

<!-- To test that a `Publisher` sends a failure and no value at all, it's not enough to fulfill the expectation if the `receiveCompletion` value is a `.failure`, we also need to ensure the test fails if `receiveValue` is called. -->

```swift
let expectation = XCTestExpectation(description: "Fails without publishing values")

publisher
    .sink(
        receiveCompletion: { completion in
            guard case .failure(let error) = completion else { return }
            XCTAssertEqual(error, <# expected error #>)
            expectation.fulfill()
        },
        receiveValue: {
            XCTFail("Expected to fail without receiving any value, got \($0)")
        }
    )
    .store(in: &cancellables)

wait(for: [expectation], timeout: 0.5)
```

---

For more insights on how to write tests for code using Combine, checkout my upcoming book [Test-Driven Development in Swift with SwiftUI and Combine](https://bit.ly/tdd-in-swift).

What are the most common `Publisher` behavior you test?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

<i><span>OpenGraph <a href="https://unsplash.com/photos/QqN25A3iF9w">Image</a> by <a href="https://unsplash.com/@sharonp?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Sharon Pittaway</a> on <a href="https://unsplash.com/s/photos/marbles?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span></i>
