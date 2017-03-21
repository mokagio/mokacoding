---
layout: post
title: XCTest closure based expectations
description: "Testing async code is not simple, but XCTest provides us with all the required tool. This post shows how to wait for an expectation to be fulfilled based on a Swift closure."
tags:
- Swift
- XCTest
- Testing
---

How do you test a Swift object that changes other objects asynchronously in XCTest?

Async code and its side effects are one of the trickiest things to tests. But without asynchronicity and side effects our products would be rather useless.

The pattern to test asynchronous code in XCTest is to define one or more expectations, and the use the `waitForExpectations(timeout:, handler:)` method to tell your test to wait until they are fulfilled, or the timeout is over.

We've already seen some techniques to test asynchronous code. Here's another one useful when...

Here's an example, which you can find in full [on GitHub](https://github.com/mokacoding/swift-predicate-block-expectation).

Say we have a `ProductView`, and a `ProductViewConfigurator` service which given a product id fetches its data and configures the view with it.

```swift
class ProductView: UIView {
  let name: UILabel = UILabel()
  let price: UILabel = UILabel()
}

class ProductViewConfigurator {
  let view: ProductView

  init(view: ProductView) {
    self.view = view
  }

  func configure(withProductId id: Int) { ... }
}
```

How can we test that given a know product id the view will be configured with the expected name and price values?

XCTest provides a method to generate an expectation that will fulfil based on the result of an [`NSPredicate`](https://developer.apple.com/reference/foundation/nspredicate), [`expectation(for:, evaluatedWith:, handler:)`](https://developer.apple.com/reference/xctest/xctestcase/1500569-expectation).

Add to that the fact that `NSPredicate` can be [initialized with a closure to evaluate](https://developer.apple.com/reference/foundation/nspredicate/1416182-init), and now you have a recipe for a closure based expectation.

```swift
// When ProductViewConfigurator configures the view with a given product id
// It sets the view name with the name of the fetched product
// It sets the view price with the formatted price of the fetched product
func testItConfiguresTheView() {
  let view = ProductView()
  let configurator = ProductViewConfigurator(view: view)

  // Create an NSPredicate with a closure describing the test condition
  //
  let predicate = NSPredicate(block: { any, _ in
    // Note that because the predicate receives an Any as input we need to
    // cast it.
    guard let view = any as? ProductView else { return false }
    return view.name.text == "Foo" && view.price.text == "$42"
  })

  // Create an expectation using the predicate
  //
  _ = self.expectation(for: predicate, evaluatedWith: view, handler: .none)

  // Exercise the system under test
  //
  configurator.configure(withProductId: 123)

  // Wait for the expectation to fulfil
  //
  waitForExpectations(timeout: 1, handler: .none)
}
```

That's it. Create a block based `NSPredicate`, use it as create an `XCTestExpectation`, exercise the system under test, make the test wait for the expectation to be fulfilled.

---

I hope you found this post useful. If you have any question or concern please do get in touch on Twitter [@mokagio](https://twitter.com/mokagio), or leave a comment below.

_Leave the codebase better than you found it._
