---
title: "You Don't Need It Yet and Test-Driven Development"
---

What do YDNIY and TDD have in common?
They're both acronyms 🥁

Jokes aside, "You Don't Need It Yet" and "Test-Driven Development" are both techniques that shift the focus on towards moving fast and incrementally.
In fact, applying the YDNIY mindset when practicing TDD will make you more effective at it.

[I already wrote about the value of YDNIY](), a concept [defined by Itamar Turner-Trauring]() describing an highly iterative approach for shipping software on a shedule.
When building a new feature for your software, ask yourself whether you need all of its component to begin with.

<!-- For example, you may be able to ship an initial version of your SaaS that allows users to signup but not to update their password.  You don't need it _yet_.  Eventually, you'll build the password update interface, but you can ship with out one to begin with.  In fact, I would argue that, by waiting for every component to be ready before shipping, are doing a disservice to those people that need your service _right now_.  -->

As I discuss in the post, a byproduct of applying the YDNIY mindset is that you'll get real world feedback on your software faster.

Test[^1]

There is the caveat that, unless you spent time doing customer research upfront and have assumptions to validate, that feedback might not be actionable.
Still, you'll definitely get more information on your code's behavior in the wild and what the users need from it than if you didn't ship it.

I think it's this focus on fast feedback that made YDNIY immediately resonate with me.
<!-- And, as I'm working on the first draft of [_TDD in Swift_](https://bit.ly/tdd-in-swift) it dawned to me that **"You Don't Need It Yet" is the perfect mindset for applying Test-Driven Development**.  -->
And, as I'm working on the first draft of [_TDD in Swift_](https://bit.ly/tdd-in-swift) I realized that there are similarities between TDD and YDNIY.

In [Test-Driven Development By Example]() Kent Beck introduces Red/Green/Refactor as follows:

> 1. Red: Write a little test that doesn't work, and perhaps doesn't even compile at first.
>
> 2. Green: Make the test work quickly, committing whatever sins necessary in the process.
>
> 3. Refactor: Eliminate all of the duplication created in merely getting the test to work.

You write a little test and you aim to make it pass fast, "committing whatever sins necessary in the process."

Building a software driven by tests requires constantly asking yourself "do I need it yet?"
The focus is on getting the simple test to pass first, then once a green baseline has been established perform small refactors to refine the implementation.

[_TDD in Swift_](https://bit.ly/tdd-in-swift) introduces Test-Driven Development concepts by building a menu ordering app.
The journey starts with a simplification exercise: what do we need to build _something_ valuable for the users?
What's our Earliest Testable version?

Do we need an API to read the menu?
Not yet, we can start with hardcoding it in the app.
Do we need a fancy UI with animations?
Not yet, we can use stock SwiftUI components and focus on building the business logic.
An so on...

The same goes for the writing the code.
Say you want to add a spiciness indicator to the name of each spicy item (something we'll actually do in the book).

The first test would be:

```swift
func testWhenItemIsSpicyDisplayNameHasSpicinessIndicator() {
    let item = MenuItem(name: "a name", spicy: true)
    let displayName = item.displayName
    XCTAssertEqual(displayName, "a name 🌶")
}
```

When writing the implementation for `displayName` do we need actual logic yet?
No, we can just hardcode the result.

```swift
struct MenuItem {

    let name: String
    let spicy: Bool

    var displayName: String { "\(name) 🌶" }
}
```

Now that we have established the baseline for the correct behavior, we can refactor `displayName` to conditionally add the 🌶 based on the value of `spicy`.
Or, we can move on with the next test, which will initially fail because of the hardcode implementation and require us to implement the conditional logic.

---

Asking "do we need this yet?" is a great way to design software and write code test-first.
It helps us focus on moving in small safe steps

[^1]: Potato.

  Tomato.
