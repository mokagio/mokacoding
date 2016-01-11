---
layout: post
title: "Testing callbacks in Swift with XCTest"
description: ""
tags:
- Testing
- XCTest
- Swift
---

_This post is going to be the first of a series on **Practical Testing in
Swift**. I plan for the posts to be cover one single topic and be focused on
the code implementation. The plan is to release at least one post a week, and I
have already 5 topics I'd like to write about. Feedback is very much
appreciated._

How do you test asynchronous code that calls a callback?

Say that you have a class that perform an asynchronous operation and executes
a closure callback closure passed as a method parameter.

```swift
class SomeService {
  func doSomethingAsync(completion: (success: Bool) -> ()) { ...  }
}

let service = SomeService()
service.doSomethingAsync { success in
  // ...
}
```

You might already have experienced that writing tests for code like
`doSomethingAsync` in the _traditional_ way will result in unexpected
behaviours and false positives.

The reason this happens is because by default XCTest is synchronous, like most
of the application code we usually write, while what you we are trying to test
is asynchronous. This means that the execution of the tests goes to the next
line of code right after the async method is called, and the whole test
finishes before the callback closure is run.

The [XCTest](https://developer.apple.com/library/ios/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/01-introduction.html)
framework provides us with an handy API to test the behaviour of asynchronous
code: `XCTestExpectation`.

Let's have a look at how to test `doSomethingAsync` using `XCTestExpectation`.
You can also follow along with the [example project for this post](https://github.com/mokacoding/PracticalTesting).

```swift
import XCTest
@testable import MyApp

class CallbackTest: XCTestCase {

  func testAsyncCalback() {
    let service = SomeService()

    // 1. Define an expectation
    let expectation = expectationWithDescription("SomeService does stuff and runs the callback closure")

    // 2. Exercise the asynchronous code
    service.doSomethingAsync { success in
      XCTAssertTrue(success)

      // Don't forget to fulfill the expectation in the async callback
      expectation.fulfill()
    }

    // 3. Wait for the expectation to be fulfilled
    waitForExpectationsWithTimeout(1) { error in
      if let error = error {
        XCTFail("waitForExpectationsWithTimeout errored: \(error)")
      }
    }
  }
}
```

As you can see there are three steps in the process.

1. Define an expectation with a meaningful description.
2. Go on with the test setup and exercise phases, calling the asynchronous method and fulfilling the expectation at the end of the callback closure.
3. Make the test runner wait for you expectation to be fulfilled, so that the asynchronous operations can be completed and you assertions verified.

It is important to provide a meaningful description because such description is
reported in the failure message of an unfulfilled expectation:

```
error: -[PracticalTestingTests.CallbackTest testAsyncCalback] : Asynchronous wait failed: Exceeded timeout of 1 seconds, with unfulfilled expectations: "SomeService does stuff and succeeds".
```

When testing having descriptive failure messages is very important to make your
future self and the rest of the team identify the failure reason as soon as
possible.

---

I hope you found this post useful and would greatly appreciate feedbacks on the
format in the comments below or by pinging me on Twitter
[@mokagio](https://twitter.com/mokagio).

If you need help with your asynchronous testing don't hesitate to get in touch,
I'd be happy to help.

Stay tuned for the next article in which we'll see how to test asynchronous
calls of delegate objects. If you don't want to miss out be sure to [subscribe
to the newsletter](http://mokacoding.com#subscribe).

_Leave the codebase better than you found it._

