---
layout: post
title: Async Testing with Quick and Nimble
description: "A look at how to write tests for async code when using the Quick and Nimble Swift frameworks. This post is part of the Practical Testing in Swift series."
tags:
- Swift
- Testing
---

In the previous two posts of the Practical Testing in Swift series we had a
look at how to test asynchronous code using XCTest, both when dealing with
[callbacks](https://www.mokacoding.com/blog/testing-callbacks-in-swift-with-xctest/)
and
[delegates](https://www.mokacoding.com/blog/testing-delegates-in-swift-with-xctest/).
In this post we'll see how to do that using
[Quick](https://github.com/Quick/Quick) and
[Nimble](https://github.com/Quick/Nimble), a pair of Swift testing frameworks.

In case you are not familiar with them, let me introduce these two frameworks:
Quick provides an [RSpec](http://rspec.info/) style syntax for Swift testing,
so that we can write our tests in a more descriptive way; Nimble brings to the
table a rich and powerful set of expectations and matchers. Read [this post](https://www.mokacoding.com/blog/testing-delegates-in-swift-with-xctest/)
if you want to know more.

### Testing Callbacks with Quick and Nimble

```swift
describe("Callback testing") {
	it("can test callbacks using waitUntil") {
		let service = SomeService()

		waitUntil { done in
			service.doSomethingAsync { success in
				expect(success).to(beTrue())
				done()
			}
		}
	}
}
```

Our method that executes an async operation and receives a closure to run as
its callback is called from within a `waitUntil` block.

`waitUntil` will wait for one second and fail unless the `done` function
received as its only parameter of its closure is not executed. For this reason
the last line of the callback is `done()`, to notify the test runner that it
can stop waiting.

This setup is similar to the `XCTestExpectation` one that we [saw already](https://www.mokacoding.com/blog/testing-callbacks-in-swift-with-xctest/),
but in my opinion easier to reason about, and simpler to write.

This approach can be used to test that a delegate method is called as a result
of an async operation being executed by its owner.

**Pro tip:** you can configure the duration of the wait interval like this:

```swift
waitUntil(timeout: 2) { done in
	// ...
	done()
}
```

### Testing Delegate Properties Setting with Quick and Nimble

Testing this kind of behaviour reveals how neat the Nimble expectations are,
and how better our test can feel by using this library.

The example below uses the _spy delegate_ technique introduced in the [previous post](https://www.mokacoding.com/blog/testing-delegates-in-swift-with-xctest/),
head over there to read more about it, or checkout the [example project](https://github.com/mokacoding/PracticalTesting)
for this post to see the full code.

```swift
describe("Delegate testing") {
	context("property setting") {
		it("can be tested with toEventually") {
			let something = SomethingWithDelegate()
			let spyDelegate = SpyDelegate()
			something.delegate = spyDelegate

			something.methodResultingInDelegatePropertySet()

			expect(spyDelegate.property).toEventually(equal(42))
		}
	}
}
```

That's it! `toEventually` will periodically executes the expectation for a
configurable interval of time, and fail only if the expectation is not
fulfilled at the last run.

---

As you might have notice by reading this post, and a number of other articles
in this blog, I am a big fan of Quick and Nimble. And how could you not be
after seeing the improved quality of tests that they allow you to write?

Regardless of the style you use, being able to write tests for asynchronous
code is important to build confidence in your code. I hope these three posts
helped you with that. If you have any comments, questions, corrections or would
like help with asynchronous code testing leave a comment below, or get in touch
on Twitter [@mokagio](https://twitter.com/mokagio).

Stay tuned for the [next article](https://www.mokacoding.com/blog/why-hitting-the-network-is-bad-for-your-tests/)
in which well see how to decouple ourselves from the server when testing
network related code.

