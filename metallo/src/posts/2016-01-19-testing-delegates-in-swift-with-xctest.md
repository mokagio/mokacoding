---
layout: post
title: Testing Delegates in Swift with XCTest
description: "In this second post of the Practical Testing in Swift we a look at strategies to test how objects call their delegate methods or set property on them."
tags:
- Swift
- Testing
- XCTest
---

In the [previous post](https://mokacoding.com/blog/testing-callbacks-in-swift-with-xctest/)
of the **Practical Testing in Swift** series we saw how to test asynchronous
code that calls a callback using XCTest.

Calling callbacks is not the only pattern available to perform asynchronous
operations, [delegation](https://en.wikipedia.org/wiki/Delegation_pattern) is
an option as well. In fact, Cocoa and Cocoa Touch use the delegate pattern **a
lot**.

Let's see how to write unit tests for types using delegates.

### Testing Delegate Method Call

Probably the most interesting, and useful, kind of delegate tests are the ones
that verify that an object calls its delegate as a result of an asynchronous
operation.

The object and its delegate protocol usually look something like this:

```swift
protocol Delegate: class {

  func somethingWithDelegate(something: SomethingWithDelegate, didAsyncStuffWithResult result: Bool)
}

class SomethingWithDelegate {
  weak var delegate: Delegate?

  func doAsyncStuff() {
		// does async operation, and when operation is completed...
		self.delegate?.somethingWithDelegate(self, didAsyncStuffWithResult: true)
  }
}
```

To test this behaviour we will need to combine the `XCTestExpectation` API we
saw [in the previous post](https://mokacoding.com/blog/testing-callbacks-in-swift-with-xctest/) with a test pattern called **Spy**.

This pattern is defined as:

> Use a Test Double to capture the indirect output calls made to another component by the system
> under test (SUT) for later verification by the test. [Source](http://xunitpatterns.com/Test%20Spy.html)

In our case we will apply the pattern by defining and instantiating an object
conforming to `Delegate` for the sole purpose of our test. When implementing
the delegate the spy will have a flag we can inspect to verify whether the
object that was suppose to call its delegate actually did so.

Note that this kind of usage is not 100% in line with the definition, as we are
not really making a double of an existing class. I still feel that the Spy name
is still appropriate though, because of the capturing behaviour.

The implementation is pretty straightforward:

```swift
class SpyDelegate: Delegate {

  // Setting .None is unnecessary, but helps with clarity imho
  var somethingWithDelegateAsyncResult: Bool? = .None

  // Async test code needs to fulfill the XCTestExpecation used for the test
	// when all the async operations have been completed. For this reason we need
	// to store a reference to the expectation
  var asyncExpectation: XCTestExpectation?

  func somethingWithDelegate(something: SomethingWithDelegate, didAsyncStuffWithResult result: Bool) {
    guard let expectation = asyncExpectation else {
      XCTFail("SpyDelegate was not setup correctly. Missing XCTExpectation reference")
      return
    }

    somethingWithDelegateAsyncResult = result
    expectation.fulfill()
  }
}
```

The actual test will simply need to instantiate and configure a `SpyDelegate`
and exercise the method under test [in an asynchronous way](https://mokacoding.com/blog/testing-callbacks-in-swift-with-xctest/).

```swift
class DelegateTestExample: XCTestCase {

  func testDelegateMethodIsCalledAsync() {
    let something = SomethingWithDelegate()
    let spyDelegate = SpyDelegate()
    something.delegate = spyDelegate

    let expectation = expectationWithDescription("SomethingWithDelegate calls the delegate as the result of an async method completion")
    spyDelegate.asyncExpectation = expectation

    something.doAsyncStuff()

    waitForExpectationsWithTimeout(1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }

      guard let result = spyDelegate.somethingWithDelegateAsyncResult else {
        XCTFail("Expected delegate to be called")
        return
      }

      XCTAssertTrue(result)
    }
  }
}
```

That's it. The amount of setup code that we need for this test is higher than
for testing async code executing a callback, but they are conceptually identical.

### Other Delegate Tests

The same approach can be used to test that a class with a delegate properly sets
the value of a property or calls a synchronous method on it.

```swift
protocol Delegate: class {
    var property: Int? { get set }
}

class DelegateTestExample: XCTestCase {

	func testDelegatePropertySet() {
		let something = SomethingWithDelegate()
		let spyDelegate = SpyDelegate()
		something.delegate = spyDelegate

		something.methodResultingInDelegatePropertySet()

		guard let propertyValue = spyDelegate.property else {
			XCTFail("Expected delegate to be called")
			return
		}

		XCTAssertEqual(propertyValue, 42)
	}
}
```

I'll let writing a test for a synchronous method call up to you.

---

With Swift and functional programming becoming more popular our applications
and libraries tend to rely on callbacks rather than delegation more and more.
Nevertheless this pattern is very useful and battle tested, and is important to
know how to write unit tests for code using it.

Get in touch with me on Twitter [@mokagio](http://twitter.com/mokagio) or leave
a comment below if you have questions, need help setting up your delegate
tests, or have experience to share.

Stay tuned for the next article in the series in which we will see how to use
[Quick](https://github.com/Quick/Quick) and
[Nimble](https://github.com/Quick/Nimble) to write asynchronous tests.
[Subscribe to the mailing list](/#subscribe) to avoid missing out and receive
links to interesting articles on testing, automation, and productivity.
