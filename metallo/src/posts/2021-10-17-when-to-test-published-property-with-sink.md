---
title: When to test a published property with sink
description: "Swift @Published properties come with an associated Combine Publisher that emits values over time. In this free tutorial I'll explain when to write an XCTest unit test that access the property directly and when to it's instead necessary to subscribe to it using the sink operator."
twitter_title: "@Published properties and unit tests"
og_description: "When to test a @Published property directly and when to subscribe to it instead"
tags:
  - Testing
  - Swift
  - Combine
  - XCTest
---

A [_Test-Driven Development in Swift_](https://tddinswift.com) reader wrote with a question about testing Swift `@Published` properties.
He noticed that some of the examples access a `@Published` property directly while others subscribed to it using `sink` and wanted to know when to use one approach instead of the other.

Here's my rule of thumb:

**In a test, access a `@Published` property directly only when you want to verify its initial value. Otherwise, subscribe to it.**

Let's dig deeper to understand how `@Published` properties behave in unit tests.

The Swift [docs](https://developer.apple.com/documentation/combine/published) explain that annotating a property with `@Published` creates a `Publisher` for it.
The publisher will emit a new value every time the property changes, including on its first assignment.

We can read a `@Published` property value like any other property.

```swift
@Published var items: [Item] = []

print(items.count) // => 0
```

We can access the generated `Publisher` via the `$` prefix and subscribe to it to observe how the property changes over time:

```swift
$items.sink { print($0) }
```

How you interact with a `@Published` property –in the tests as well as the production code– depends on which of its possible values you want.
Are you interested in its value _right now_ or in the value it will have in the future?

Here's an example from [_Test-Driven Development in Swift_](https://tddinswift.com) Chapter 7, _Testing Dynamic SwiftUI Views_.
We want to ensure the initial value of the menu list ViewModel menu section property is an empty array.
The property is defined as:


```swift
@Published var sections: [MenuSection] = []
```

In the test, we access `sections` directly:

```swift
func testPublishesEmptyMenuAtInit() {
    let viewModel = MenuList.ViewModel(menuFetching: MenuFetchingPlaceholder())

    XCTAssertTrue(viewModel.sections.isEmpty)
}
```

_You can find [the code above](https://github.com/Apress/Test-Driven-Development-in-Swift/blob/13c24681fb0df9f109bd8bdf9575b6b6d90682a3/07-testing-dynamic-swiftui-views/1-end/AlbertosTests/MenuList.ViewModelTests.swift#L9-L13) and all the other examples from the book [on GitHub](https://github.com/Apress/Test-Driven-Development-in-Swift)._

`@Published` properties stream values over time, but when you access them directly, they return their current value.
Above, we are interested in the property's initial value, so we can read from it directly.

Nothing stops us from subscribing to it, but as you can see from the example below, it requires extra effort:

```swift
func testPublishesEmptyMenuAtInit() {
    let viewModel = MenuList.ViewModel(menuFetching: MenuFetchingPlaceholder())

    let expectation = XCTestExpectation(description: "The first publishes value is an empty section")

    viewModel
        .$sections
        .sink { value in
            XCTAssertTrue(value.isEmpty)
            expectation.fulfill()
        }
        .store(in: &cancellables)

    wait(for: [expectation], timeout: 1)
}
```

Because subscribing to a `Publisher` requires more code, I do that only when absolutely necessary.
Alas, that turns out to be most of the time.

The whole point of making a property `@Published` is to support streaming value changes.
We're seldom interested in its initial value alone, which means **most tests `@Published` properties require subscribing to it.**

Here's another example inspired by [the book](https://tddinswift.com), where we check how `sections` changes due to a successful response from the fetching component.

```swift
func testWhenFetchingSucceedsPublishesReceivedSections() {
    let viewModel = MenuList.ViewModel(menuFetching: MenuFetchingPlaceholder())

    let expectation = XCTestExpectation(description: "Publishes sections built from received menu")

    viewModel
        .$sections
        // Drop first to ignore the initial value
        .dropFirst()
        .sink { value in
            // For the sake of this example, check the count only
            XCTAssertEqual(value.count, 4)
            expectation.fulfill()
        }
        .store(in: &cancellables)

    wait(for: [expectation], timeout: 1)
}
```

Because we are interested in how `section` _changes_, we need to subscribe to it.

If one wanted to be pedantic, they could point out that we can write the same test with direct access by reading the property after the expectation is fulfilled.

```swift
func testWhenFetchingSucceedsPublishesReceivedSections() {
    let viewModel = MenuList.ViewModel(menuFetching: MenuFetchingPlaceholder())

    let expectation = XCTestExpectation(description: "Publishes sections built from received menu")

    viewModel
        .$sections
        .dropFirst()
        .sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)

    wait(for: [expectation], timeout: 1)

    XCTAssertEqual(viewModel.sections.count, 4)
}
```

I prefer the implementation with the check right inside the `sink` but wouldn't complain about this if I came across it in a code review.
Still, while it's true that it runs the assertion on `.section` and not `.$section`, it didn't remove the necessity to subscribe to the `Publisher` to keep track of how it changed.

---

To recap, whenever you want to assert the value of a `@Published` property after it changes, you'll have to subscribe to it with `sink`.
It's up to you to verify the value it will have taken directly in the `sink` closure or afterward by accessing the property directly — I recommend the former.

If you want to learn more about testing Combine `Publisher` and `@Published` properties, check out my [Unit Testing Combine Publisher Cheatsheet](https://mokacoding.com/blog/testing-combine-publisher-cheatsheet/) and, of course, [_Test-Driven Development in Swift](https://tddinswift.com/).
