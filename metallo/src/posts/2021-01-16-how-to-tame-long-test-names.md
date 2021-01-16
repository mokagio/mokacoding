---
title: How to tame long test names
---

What's the best way to name test methods in Swift with XCTest?
In particular, how do you keep the test methods name readable when the test is testing non trivial behavior?

In this post, we'll look at four options, and they pros and cons.

Let's imagine we are building an extension on `String` that returns its first word.
When the string has more than one word, it should return the first word, otherwise, it should return the whole string.

Let's write a three tests for it, one for the default behavior and two for the edge cases when the string is empty or only has one word.

- When the string is empty, it returns an empty string
- When the string has only one word, it returns the whole string
- When the string has more than one word, it returns the first word

## Option 1: Add a comment

There is no explicit guidance from Apple on how to name test methods, but the [XCTest documentation](https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods) uses concise test method names with documentation comments to add detailed context

```swift
class FirstWordTests: XCTestCase {

  /// Test that when the string is empty, it returns an empty string
  func testEmptyStringFirstStringValue() {
    XCTAssertEqual("".firstWord, "")
  }

  /// Test that when the string has only one word, it returns the whole string
  func testSingleWordStringFirstStringValue() {
    XCTAssertEqual("pizza".firstWord, "pizza")
  }

  /// Test that when the string has more than one word, it returns the first word
  func testMultiWordStringFirstStringValue() {
    XCTAssertEqual("pizza quattro stagioni".firstWord, "pizza")
  }
}
```

The advantage of this approach is that you can keep your test method names relatively short, while having complete freedom on the description you give in the comment.

Relying on comments, on the other hand, has the downside that they're easily ignored when reading the code or updating it.

Another issue with this approach is that you'll only get the test name in the test report, missing out on all the useful information that lives in the comment.

%% Option 1: Snake tests
## Option 2: Use `_` to separate the test name components

An option to embed all of the test information in the method name and mitigate the readability issue of long camel cased names is to add snake casing in the mix to separate the test components, as codified by Roy Osherove in [The Art of Unit Testing]().

There are [different ways to organize test methods names](). I like Jon Reid's approach of splitting the test name in three ordered parts: the unit of work being tested, the input values and initial state, and finally the expected output or outcome.

```swift
func test_firstWord_whenStringEmpty_returnsEmptyString() {
  XCTAssertEqual("".firstWord, "")
}

func test_firstWord_whenStringHasOnlyOneWord_returnsWholeString() {
  XCTAssertEqual("pizza".firstWord, "pizza")
}

func test_firstWord_whenStringHasMoreThanOneWord_returnsFirstWord() {
  XCTAssertEqual("pizza quattro stagioni".firstWord, "pizza")
}
```

This approach removes the overhead of adding documentation comments to the tests and guarantees all the information will be part of the test report.

Still, even with the components separated with `_`, the test method is not that readable.
It's hard to match a pure string when it comes to readability.

%% https://qualitycoding.org/unit-test-naming/
%% https://www.amazon.com.au/Art-Unit-Testing-Roy-Osherove/dp/1617290890/ref=sr_1_1?crid=2D9CK6DO4BZBX&dchild=1&keywords=the+art+of+unit+testing&qid=1610760023&sprefix=tiny+ha%2Caps%2C455&sr=8-1

%% Option 2: XCTContext
## Option 3: Implement a "Given, when, then" DSL

Victor Magalhães came up with [a neat way]() to use, or rather _abuse_, [`XCTActivity`]() and [`XCTContext`]() to address test readability: build test helper functions to organize tests in BDD-like "given, when, then" blocks.

```swift
import os.log

func given<A>(_ description: String, block: () throws -> A) rethrows -> A {
    os_log("Given %{public}@", description)
    return try XCTContext.runActivity(named: "Given " + description, block: { _ in try block() })
}

func when<A>(_ description: String, block: () throws -> A) rethrows -> A {
    os_log("When %{public}@", description)
    return try XCTContext.runActivity(named: "When " + description, block: { _ in try block() })
}

func then<A>(_ description: String, block: () throws -> A) rethrows -> A {
    os_log("Then %{public}@", description)
    return try XCTContext.runActivity(named: "Then " + description, block: { _ in try block() })
}
```

```swift
func testEmpty() {
  given("an empty string") {

    let string = ""

    when("firstWord") {

      let firstWord = string.firstWord

      then("returns empty string") {
        XCTAssertEqual(firstWord, "")
      }
    }
  }
}
```

Because we don't need to do any setup in the `given` step or extra work in the `when` one, we can make the test more concise.

```swift
func testEmpty() {
  given("an empty string") {
    when("firstWord") {
      then("returns empty string") {
        XCTAssertEqual("".firstWord, "")
      }
    }
  }
}
```

The main benefit is in clearly splitting the components and possibly reusing code thanks to the use of `XCTContext` and `XCTActivity` under the hood.

```swift
func testMultiWordString() {
  given("a multi word string") {

    let string = "pizza quattro stagioni"

    when("firstWord") {
      then("returns the first word") {
        XCTAssertEqual(string.firstWord, "pizza")
      }
    }

    when("lastWord") {
      then("returns the last word") {
        XCTAssertEqual(string.lastWord, "stagioni")
      }
    }
  }
}
```

This approach helps describing tests in great detail but the _abuse_ of the context APIs might result in a test report that is harder to navigate.

%% Option 2: Quick
## Option 3: Use the Quick testing framework

If you like using a structured "given-when-then" BDD approach, then you might want to all-in with it and use the [Quick](https://github.com/Quick/Quick) testing framework.

Quick has its own DSL to build tests on top of XCTest and comes with ways to run setup and teardown logic for every test or for every test case and advanced global configurations.

```swift
import Quick
import XCTest

class FirstWordSpec: QuickSpec {

}
```

Quick uses `describe`, `context`, and `it` to build actual XCTest methods, so it won't result in a nested test report, unlike the previous approach.

I like Quick a lot, but I often seen it misused.
It's ability do deconstruct tests in nested steps can easily be overused, resulting in [pyramids of doom]() or tests where you need to keep scrolling up and down to piece together the state of the `it` example you are running because there are some many other `it` examples in its `context` that you can fit all the code in the screen.

If you decide to adopt Quick with your team, make sure to define clear rules to help you keep the specs as linear as possible.

---

Neither of these options is a silver bullet for test readability and maintainability.

Using comments...
The standard camel case names for your test methods makes them hard to read.
Using snake case to split the test name components helps a bit, but you're left with awkward looking test names.
Both the bespoke `given`, `when`, `then` test helpers and the Quick framework require extra discipline to avoid building tests that are so nested that they loose any readability benefit you might have gained in the first place.

In Kotlin, you can use strings to name test methods:

```kotlin
fun `test that when the string is empty, it returns an empty string`() {}
```

This feature was suggest for Swift, too, but eventually rejected.
Until XCTest will have support for test annotations to enable developers to use strings to describe tests, we're all left with compromises.

Whichever solution you'll decide to adopt, remember that oftentimes, if the test condition is hard to describe, then the test is testing too much.
Oftentimes, the best way to have tests with short names is to make the code under test do less.

_Special thanks to [Olivier All]() and [Joe Masillotti]() for the interesting conversation that inspired this blog post._

What's your favorite strategy to keep test names readable and informative?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).
