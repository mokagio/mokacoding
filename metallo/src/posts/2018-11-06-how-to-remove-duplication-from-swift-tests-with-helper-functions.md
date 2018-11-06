---
title: "How to remove duplication from Swift tests with helper functions"
description: "Some code ends up requiring a lot of duplication to be tested. You can remove it by using helper functions encapsulating the shared assertion logic."
date: 2018-11-06
og_image: https://s3.amazonaws.com/mokacoding/2018-11-06-test-helper-failure-in-call-site.png
tags:
  - Testing
  - Xcode
  - Swift
  - XCTest
---

As your codebase grows so will your test suite. Production code is often refactored to stay simple to work with. The same care should be applied to the test code.

Your unit test suite should be kept as tidy as your production code. Let's see how to remove duplication from tests using helper functions.

Imagine you have a logging component and you want to ensure it logs the expected message for the given inputs to the provided storage layer.

```swift
func testLoggerLogsMessageWithPizza() {
  let storageMock = StorageMock()
  let logger = Logger(storage: storageMock())

  logger.log(Pizza())

  expect(storageMock.hasBeenLogged("Pizza is delicious")) == true
}
```

_This code is also available [on GitHub](https://github.com/mokagio/removing-duplications-in-swift-examples)._

Now, let's say in this system it's important to ensure the logger behaves as expected with inputs of type `Pasta`, `Gelato`, and `Cappuccino`.

One way to do it is to duplicate the test for `Pizza` for each of those inputs.

```swift
func testLoggerLogsMessageWithPasta() {
  let storageMock = StorageMock()
  let logger = Logger(storage: storageMock())

  logger.log(Pasta())

  expect(storageMock.hasBeenLogged("There's nothing like home made pasta")) == true
}

func testLoggerLogsMessageWithGelato() {
  let storageMock = StorageMock()
  let logger = Logger(storage: storageMock())

  logger.log(Gelato())

  expect(storageMock.hasBeenLogged("I love gelato any time of the year")) == true
}

// etc...
```

While [there's nothing bad with a bit of duplication](https://www.sandimetz.com/blog/2016/1/20/the-wrong-abstraction) in the case of a mechanical behaviour like this one you could do worst than spending a bit of time to remove those duplicated test code.

This is worth doing. You'll end up with code that is easier to read and change in the future. All with little time investment upfront. Bargain!

## Extracting expectation from tests

Have a look at those three tests, you'll see they all look the same. The only differences are the input of the system under test and its expected behaviour.

You can extract the test in a function of those parameters:

```swift
func expectLogger(toLog output: String, forInput input: Any) {
  let storageMock = StorageMock()
  let logger = Logger(storage: storageMock())

  logger.log(input)

  XCTAssert(storageMock.hasStored(output), "\"\(output)\" was not logged.")
}
```

You can then write a single test in which to call the encapsulated expectation for each of the inputs you care about.

```swift
func testLoggerLogsMessageBehaviour() {
  expectLogger(toLog: "There's nothing like home made pasta", forInput: Pasta())
  expectLogger(toLog: "Pizza is awesome!", forInput: Pizza())
  expectLogger(toLog: "I love gelato any time of the year", forInput: Gelato())
}
```

Nice. There's a little problem though. If the test fails Xcode will show the failure in the expectation function body, not at the call site. 

![📸 Screenshot of a test failure reported in the helper function body](https://s3.amazonaws.com/mokacoding/2018-11-06-test-helper-inline-failure.png)

Even worse if you have more than one failure, it requires you to click on the message to expand it an learn which tests failed.

![📸 Screenshot of multiple test failures reported in the helper function body](https://s3.amazonaws.com/mokacoding/2018-11-06-test-helper-inline-failure-multiple.png)

When writing unit tests the easier you make failures to be discovered the better off you'll be.

## Accurate failures with `#file` and `#line`

Not having duplicated code is great, but not knowing which of the `expectLogger(toLog:, forInput:)` calls failed makes understanding -and eventually fixing- the test failures harder.

Wouldn't it be great if the failures were reported at the call site of the test helper method?

The documentation for the `XCTAsser-` family of methods shows how to do it. Xcode's code completion when calling an `XCTAssert-` method shows this:

![📸 Screenshot of multiple test failures reported in the helper function body](https://s3.amazonaws.com/mokacoding/2018-11-06-xctassert-autocompletion.png)

There are other two input parameters the functions can accept. They don't come up in the autocompletion view because they have a default value.

```swift
func XCTAssert(
  _ expression: @autoclosure () throws -> Bool,
  _ message: @autoclosure () -> String = default,
  file: StaticString = #file,
  line: UInt = #line
)
```

The [documentation](https://developer.apple.com/documentation/xctest/1500669-xctassert) reads:

> **`file`** The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
>
> **`line`** The line number on which failure occurred. Defaults to the line number on which this function was called.

Armed with this knowledge you can pass the call site details to the test helper, so it can relay that information when calling an `XCTAssert-` or `XCTFail`.

```swift
private func expectLogger(
  toLog output: String,
  forInput input: Any,
  file: StaticString = #file,
  line: UInt = #line
) {
  let storageMock = StorageMock()
  let logger = Logger(storage: storageMock)

  logger.log(input)

  XCTAssert(
    storageMock.hasStored(output),
    "\"\(output)\" was not logged.",
    file: file,
    line: line
  )
}
```

Now the test failures are reported where `expectLogger(toLog:, forInput:)` is called. This makes it clearer where to start looking for the issue.


![📸 Screenshot of multiple test failures reported in the helper function body](https://s3.amazonaws.com/mokacoding/2018-11-06-test-helper-failure-in-call-site.png)

---

As a developer who cares about your craft you'll be already spending a lot of time refactoring your production code to make it as pleasant and simple as possible to work with. You ought to do the same with your test suite.

When extracting code calling an `XCTest` assertion method you want failures to be reported at the call site, not in the helper function. This can be done by passing the `#file` and `#line` values through.

This technique will help keeping the tests tidy and avoid extra work when adding new ones.

On the other hand, tests are a window on the ergonomics of your software. If something is hard to test it's likely its design can be improved.

You should always be paying attention to how your tests feel to write and read. When they become painful or require extra work ask yourself whether the design can be improved.

In next week's post we'll look at how to rewrite the `Logger` component in a way to make testing it -and as a direct effect using it- easier.

👉 [Subscribe to the email list](http://eepurl.com/dEr0DH) to avoid missing out!

In the meantime, what do you think of test helpers? Is there anywhere in your test suite where you could use them? Or maybe you are already using them and want to share how they're working out for you. Leave a comment below or get in touch [on Twitter](https://twitter.com/mokagio), I'd love to hear from you.
