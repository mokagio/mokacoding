---
title: How to decouple unit tests from values that change frequently
description: When the output value of a function changes often but the logic to pick it doesn't, adding a separation layer will make unit tests easier to maintain.
tags:
  - Swift
  - XCTest
  - Testing
og_image: https://mokacoding.s3.amazonaws.com/og-image-wire-cutter.jpg
---

Justin Stanley started this interesting thread on Twitter:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">When unit testing label/string values &amp; using R.swift, in the unit tests themselves, is it better to use a hard-coded string for the expected output, or is it fine to use the R.swift string value directly in the matcher?<a href="https://twitter.com/hashtag/iosdev?src=hash&amp;ref_src=twsrc%5Etfw">#iosdev</a></p>&mdash; Justin Stanley 👨‍💻 (@JStheoriginal) <a href="https://twitter.com/JStheoriginal/status/1298703985688231937?ref_src=twsrc%5Etfw">August 26, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

The answer Justin got was to use literals, hard-coded strings for the expected output.

Using literals in your tests makes them more straightforward.
In Justin's case, it also hides the implementation detail of using [R.swift](https://github.com/mac-cain13/R.swift) so that if one day the code generation tooling will change, the tests won't need updating.

As Jon Reid [pointed out in the thread](https://twitter.com/qcoding/status/1298721989855567873?s=20),
a scenario in which using the R.swift generated value directly might be better is if the copy changes often and you don't want to have to update both localizations and tests every time.

There is another option to avoid updating the tests for every little copy change, one which doesn't require surfacing implementation details: decouple the code making decisions on which value to use from the code defining the values.

Let's imagine we're writing an app that speaks to the user the way a caring granny would: "_it's sunny; you should wear a hat dear, so you don't get sunburned._"

```swift
enum Weather {
    case sunny, windy, rainy
}

class GrannyMessageTests: XCTestCase {

    func testWhenWeatherIsRainyMessageIsGetUmbrella() {
        XCTAssertEqual(getMessage(weather: .rainy), "Don't forget the umbrella")
    }

    func testWhenWeatherIsSunnyMessageIsGetHat() {
        XCTAssertEqual(getMessage(weather: .sunny), "You should wear a hat")
    }

    func testWhenWeatherIsWindyMessageIsGetJacket() {
        XCTAssertEqual(getMessage(weather: .windy), "Wear a jacket or you'll catch a cold")
    }
}

func getMessage(weather: Weather) -> String {
    switch weather {
    case .rainy: return "Don't forget the umbrella"
    case .sunny: return "You should wear a hat"
    case .windy: return "Wear your jacket or you'll catch a cold"
    }
}
```

What's interesting about `getMessage(weather:)` is not the content of the message but whether it is the appropriate one for the weather condition; that's where the actual logic is.
In a sense, the message content is the end product of choosing the right message state for the given input.

We can split the code deciding what's the appropriate message from the code defining the different messages for each weather condition.

```swift
struct Messages {
    let rainy: String
    let sunny: String
    let windy: String

    static let `default` = Messages(
        rainy: "Don't forget the umbrella",
        sunny: "You should wear a hat",
        windy: "Wear a jacket or you'll catch a cold"
    )
}

func getMessage(weather: Weather, greetings: Messages = .default) -> String {
    switch weather {
    case .rainy: return greetings.rainy
    case .sunny: return greetings.sunny
    case .windy: return greetings.windy
    }
}
```

The call site for `getMessage(weather:)` doesn't need to change, because we have extracted the existing messages in the `default` instance of `Messages`.
In the tests, can now focus on the matching rather than the content of the messages by passing a [dummy instance](https://www.mokacoding.com/blog/swift-test-doubles/) of `Messages`.

```swift
func testWhenWeatherIsRainyUsesCopyForRainyState() {
    let dummyMessages = Messages(rainy: "rainy", sunny: "sunny", windy: "windy")
    XCTAssertEqual(getMessage(weather: .rainy, messages: dummyMessages), "rainy")
}

func testWhenWeatherIsSunnyUsesCopyForSunnyState() {
    let dummyMessages = Messages(rainy: "rainy", sunny: "sunny", windy: "windy")
    XCTAssertEqual(getMessage(weather: .sunny, messages: dummyMessages), "sunny")
}

func testWhenWeatherIsWindyUsesCopyForWindyState() {
    let dummyMessages = Messages(rainy: "rainy", sunny: "sunny", windy: "windy")
    XCTAssertEqual(getMessage(weather: .windy, messages: dummyMessages), "windy")
}
```

With the separation layer provided by `Messages`, when the copy changes, only the `default` instance needs to change, with no need to update the tests.

Imagine if we had more inputs alongside the weather condition, like the time of the day and day of the week.
In the afternoon the message could be "did you have lunch?", on a Thursday evening "have you got plans for the weekend?"
The more possible messages, the higher the chance one of them will change, the more time we're likely to spend updating tests, too.
By decoupling the code selecting the message from the code defining the message, we remove the need to update the tests, removing friction in the process.

If copy changes don't require tests to be updated, it becomes simple for copywriters and product managers to make those changes themselves, which is a nice side effect.
They're empowered and we can focus on those tasks only we can do.

---

Let me open a sidebar on whether to test constant values, like the copy for the messages.
Tests are useful for code that has logic; constant values have no logic, so testing them is most often redundant.
You don't need a test to tell you that for `let x = "foo"` the value of `x` is `"foo"`.

I recommend against writing this kind of tests because they don't tell you anything you don't already know.

The only exception is when the constant holds an important value that you don't want accidentally changed, like a token or a base URL.
In such case, having a test may add an extra layer of security: if I come in the codebase with my fat fingers and delete a character from the value, the test will bark at me.

---

Splitting the decision on which value to use based on complicated logic from the definition of the values is a handy technique to make sure that each piece of code has only one reason to change.
Code that only has one reason to change, code that follows the single responsibility principle, is easier to maintain.

As always in software development, whether to go down this route is a matter of tradeoffs.
You have to take into account how much you expect your code to change, how expensive it is to update your tests when the production code changes, and how big is the overhead of the separation layer between the values definition and the logic to pick them.

I have a bias towards code with tests that are easy to maintain, so I'll pretty much always choose to pay the upfront cost of putting the separation in place to save time and time again when the copy changes.

What would you choose?
I'd love to hear from you; get in touch on Twitter [@mokagio](https://twitter.com/mokagio) or leave a comment below.

_Cover image by [Michael Dziedzic](https://unsplash.com/@lazycreekimages?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/decouple?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText)._
