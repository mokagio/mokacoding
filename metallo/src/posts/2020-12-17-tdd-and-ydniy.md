---
title: 'How to improve your Test-Driven Development workflow by asking "Do I need this yet?"'
description: "The \"You Don't Need It Yet\" technique to ship software on a schedule results in fast real-world feeback. The same mindset can be applied with Test-Driven Development to move between the Red, Green, and Refactor stages faster."
og_description: "Learn how to get the faster feedback with TDD and YDNIY."
tags:
- Testing
- TDD
---

What do YDNIY and TDD have in common?
They're both acronyms. 🥁

Jokes aside, "You Don't Need It Yet" and "Test-Driven Development" are both techniques that focus on moving fast and incrementally.
Applying the YDNIY mindset when practicing TDD will make you more effective at it.

[I already wrote about the value of YDNIY](https://mokacoding.com/blog/you-dont-need-it-yet/), a concept [defined by Itamar Turner-Trauring](https://codewithoutrules.com/2020/09/18/ydniy/).
It's a highly iterative approach for shipping software on a schedule.

With YDNIY, you continuously ask yourself if there is a smaller subset of what you want to build that you can implement and ship to deliver value to your users earlier.

As a byproduct, you'll get real world feedback on your software faster <sup id="fn-feedback-caveat-back"><a href="#fn-feedback-caveat">1</a></sup>.
This focus on fast feedback made it immediately resonate with me.
Fast feedback is at the core of another favorite of mine: Test-Driven Development.

In [_Test-Driven Development By Example_](https://geni.us/NwUB1Ns), Kent Beck introduces the Red/Green/Refactor flow as follows:

> 1. Red: Write a little test that doesn't work, and perhaps doesn't even compile at first.
>
> 2. Green: Make the test work quickly, committing whatever sins necessary in the process.
>
> 3. Refactor: Eliminate all of the duplication created in merely getting the test to work.

You write a little test and you aim to make it pass fast, "committing whatever sins necessary in the process."

Building software driven by tests requires continually asking yourself, "do I need it yet?"
The focus is on getting the test you just wrote to pass as soon as possible.
Doing that establishes a green baseline from which you can safely perform small refactors to refine the implementation.

In my book [_Test-Driven Development in Swift_ (with SwiftUI and Combine)](https://tddinswift.com) introduces TDD concepts by building a "real-world" menu ordering app for an Italian restaurant.

The journey starts with a simplification exercise: what do we need to build _something_ valuable for the users?
What's our [Earliest Testable version](https://blog.crisp.se/2016/01/25/henrikkniberg/making-sense-of-mvp)?

Do we need an API to read the menu?
Not yet, we can start with hardcoding it in the app.
Do we need a fancy UI with animations?
Not yet, we can use stock SwiftUI components and focus on building the business logic.
An so on...

The same goes for writing the code that makes the tests pass.
One of the exercises in the book is adding a spiciness visual indicator when displaying the name of each spicy item<sup id="fn-example-back"><a href="#fn-example">2</a></sup>.

Here's the test for the "adds spiciness indicator" behavior:

```swift
func testWhenItemIsSpicyDisplayNameHasSpicinessIndicator() {
    let item = MenuItem(name: "a name", spicy: true)
    let displayName = item.displayName
    XCTAssertEqual(displayName, "a name 🌶")
}
```

The implementation for `displayName` can be some kind of if-else conditional based on the model's `spicy` property.
Do we need that conditional logic to make that single test pass just yet?
No, we can simply hardcode the result.

```swift
struct MenuItem {

    let name: String
    let spicy: Bool

    lazy private(set) var displayName: String = "\(name) 🌶"
}
```

With a green test for this slice of behavior, we can refactor `displayName` to conditionally add the "🌶".
Or, we could move on with the next test, which will initially fail because of the hardcode implementation and require us to implement the conditional logic.

Regardless of the next step, having a test in place that we can trust gives us the confidence to move forward.

---

The difference between TDD and testing after the fact is that writing tests first introduces a helpful pressure to build small components in small iterations.
Applying YDNIY will help you get the most out of TDD.

**By only writing what is strictly necessary right now while leaving the door open for future changes, we can focus on solving one small problem at a time.**
**This is a psychological relief that should not be underestimated and a way to assign our limited working memory space effectively.**

The next time you'll write the code to make a failing test pass, ask yourself, "do I need it yet?"
Seek to write only as little code as necessary.

What are the techniques you use to get fast feedback when writing tests?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

_Enjoyed this post?_
_Want to know more about how to apply TDD to move iteratively?_
_You might like my book_ [Test-Driven Development in Swift with SwiftUI and Combine](https://tddinswift.com).

## Footnotes

<span id="fn-feedback-caveat">**1.**</span>
There is a caveat.
Unless you spent time doing customer research upfront and have assumptions to validate, that feedback might not be actionable.
Still, you'll definitely get more information on your code's behavior in the wild and what the users need from it than if you didn't ship it.
[Back](#fn-feedback-caveat-back)

<span id="fn-example">**2.**</span>
In the book, this code actually lives in the `ViewModel` for the row displaying `MenuItem` in the menu list view.
I simplified it in this post into a dedicated method in the model itself to keep the code concise.
[Back](#fn-example-back)
