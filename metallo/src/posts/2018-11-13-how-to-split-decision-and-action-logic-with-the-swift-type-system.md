---
title: "How to split decision and action logic with the Swift type system"
description: "There is a subtle way to overload software components, by making them both take decision and act on them. We can simplify these bloated components by separating the responsibility of taking decisions from the one action on them. This will result in leaner and easier to maintain software, and is made simple by the Swift type system."
tags:
  - Swift
  - Testing
  - Refactoring
---

As your codebase grows so will your test suite. Production code is often refactored to stay simple to work with. The same care should be applied to the test code.

Your unit test suite should be kept as tidy as your production code. We already saw [how to remove duplication from tests using test helpers](https://mokacoding.com/blog/how-to-remove-duplication-from-swift-tests-with-helper-functions/), functions extracting common functionalities in your test suite to avoid duplication.

Test helpers are an invaluable tool to make the tests suite easy to read and to expand without requiring extra work. I encourage you to use them.

Still, tests are a feedback on how our software is designed. Having to do a lot of work to test a component is usually a signal the its design can be improved.

## Split decision logic from action logic

Let's pick up the test for the `Logger` component of the [test helper example](https://mokacoding.com/blog/how-to-remove-duplication-from-swift-tests-with-helper-functions/).

```swift
func testLoggerLogsMessageWithPizza() {
  let storageMock = StorageMock()
  let logger = Logger(storage: storageMock())

  logger.log(Pizza())

  XCTAssert(storageMock.hasBeenLogged("Pizza is delicious")
}
```

The test is verifying calling `log(_:)` writes the expected value using the storage component given to `Logger`.

You could argue there are two behaviours being tested here. The act of logging, and the decision on what to log.

A good rule of thumb to build systems simple to work with is to have components do only one thing. Let's rewrite `Logger` so the only thing it does is logging, leaving the responsibility to decide what to log to some other component.

```swift
class Logger {

  let transformation: (Any) -> String
  let storage: StorageService

  init(transformation: (Any) -> String, storage: StorageService) {
    self.transformation = transformation
    self.storage = storage
  }

  func log(_ input: Any) {
    storage.perist(transformation(input))
  }
}
```

The new `Logger` expects an input `(Any) -> String` function to use to get the `String` to log for the given `input`.

The only thing to do to test `Logger` is to pass an arbitrary `transformation` and verify it uses it properly<sup>[1](#fn1)</sup>.

```swift
func testLoggerLogsMessageBehaviour() {
  let storageMock = StorageMock()
  let logger = Logger(
    transformation: { return "something" },
    storage: storageMock()
  )

  logger.log("any input")

  XCTAssert(storageMock.hasBeenLogged("something"))
}
```

Notice how `Logger` is now not only simpler to test but also simpler to maintain. `Logger` itself needs to change only if the mechanic of logging changes, e.g. from one storage to two. Adding support for a new log input can be done in the `transformation` function.

Ease of testability and maintainability go hand in hand.

## Splitting decision from action using a Swift protocol

Splitting the code performing the action from the one making the decision on what the output should be is neat, simplifies the testing, and makes the design of our component easier to scale.

Speaking of scaling, if we expect to have many different types of input being logged with our `Logger` we'll also see the `transformation` function growing in length and complexity.


```swift
func extractLogMessage(fromInput input: Any) -> String {
  switch input {
  case is Pasta:
    return "There's nothing like home made pasta"
  case is Pizza:
    return "Pizza is awesome!"
  // more and more cases here...
  case _:
    return "\(input)"
  }
}

func testTransformation() {
  XCTAssertEqual(
    extractLogMessage(fromInput: Pasta()), "There's nothing like home made pasta"
  )
  XCTAssertEqual(
    extractLogMessage(fromInput: Pizza()), "Pizza is awesome!"
  )
  // more and more of the assertions like the ones above here...
}
```

We have moved the long test from `Logger` where it originally was in the first example to `transformation`.

Moreover, the fact it accepts `Any` as its input leaves the door open for future developers using `log(_:)` without adding support for the input type to the transformation.

Swift offers a way to clean all this up by using a protocol.

We can make `log(_:)` accept inputs conforming to a protocol describing the ability of generating a log message.

```swift
protocol Loggable {
  var message: String { get }
}

class Logger {

  func log(_ input: Loggable) {
    storage.persist(input.message)
  }
}
```

Now our test for `Logger` can become

```swift
func testLoggerLogsMessageBehaviour() {
  let storageMock = StorageMock()
  let logger = Logger(storage: storageMock())

  logger.log(DummyLoggable())

  expect(storageMock.hasBeenLogged("a message")) == true
}

struct DummyLoggable: Loggable {
  var message { "a message" }
}
```

This approach decentralizes the knowledge of the input-output conversion by encapsulating it in a `protocol`.

Using a `protocol` also ensures the compiler will enforce that any input provided to `log(_:)` has logic to generate its message because it needs to conform to `Loggable`.

As Manuel Chakravarty argues in his excellent talk [A Type is Worth a Thousand Tests](http://justtesting.org/post/153668237436/here-is-the-video-of-my-talk-a-type-is-worth-a) we should leverage the type system and the compiler whenever possible. We can forget to write a test, or write a buggy test resulting in a false positive. The compiler is harder to fool.

---

Between this and [the previous post](https://mokacoding.com/blog/how-to-remove-duplication-from-swift-tests-with-helper-functions/) we saw three different approaches to avoid duplication in tests, ranging from the use of an helper function to encapsulate an expectation repeated multiple times, to the use of the type system to split the code taking decisions on the output from the code actioning it.

Each is valuable, and each comes with different trade-offs. That's the beauty of software development, multiple solutions for the same problem, which one to pick is up to us.

If you ask my opinion, when using a language like Swift **relying on the type system is your best option**.

Have you got other approaches to suggest to remove duplication in this example? Or have you got tests with duplication and would like to chat about ways to remove it? Leave a comment below, get in touch [on Twitter at @mokagio](https://twitter.com/mokagio), or write to [gio@mokacoding.com](mailto:gio@mokacoding.com).

<p style="font-size: smaller"><a id="fn1">1</a>: One could argue the test in the example could tricked by making the `log(:)` body return `"something"`, the value returned by the test `transformation` function. While that's true it leads us into a spiral of more and more refined tests which might eventually turn into the need for generative testing. Let's just assume no one is trying to intentionally trick the tests and compromise using this single simpler one.</p>
