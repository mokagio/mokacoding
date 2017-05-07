---
layout: post
title: Quick beforeEach and afterEach behaviour
description: "A look at how nested beforeEach and afterEach behave in the Quick testing framework."
tags:
- Quick
- Espresso
- Testing
---

I am sometimes unsure of what to expect from nested `beforeEach` and/or `afterEach` calls in Quick.

Luckily we can verify how they behave with a simple example spec, which you can find [on GitHub](https://github.com/mokacoding/quick-beforeeach-aftereach-behaviour):

```swift
import Quick

class Spec: QuickSpec {
  override func spec() {
    describe("beforeEach and afterEach behaviour") {
      beforeEach {
        print("⭐️ top before each")
      }

      context("some context") {
        beforeEach {
          print("👉 context before each")
        }

        it("example 1") { print("😊 example 1") }

        it("example 2") { print("😊 example 2") }

        it("example 3") { print("😊 example 3") }

        afterEach {
          print("👉 context after each")
        }
      }

      context("another context") {
        beforeEach {
          print("🍎 context before each")
        }

        it("example 1") { print("😜 example 1") }

        it("example 2") { print("😜 example 2") }

        afterEach {
          print("🍎 context after each")
        }
      }

      afterEach {
        print("⭐️ top after each")
      }
    }
  }
}
```

If we run this test the console output, cleared of all the test framework information, will be:

```
behaviour - some context - example 1
⭐️ top before each
👉 context before each
😊 example 1
👉 context after each
⭐️ top after each

behaviour - some context - example 2
⭐️ top before each
👉 context before each
😊 example 2
👉 context after each
⭐️ top after each

behaviour - some context - example 3
⭐️ top before each
👉 context before each
😊 example 3
👉 context after each
⭐️ top after each

behaviour - other context - example 1
⭐️ top before each
🍎 context before each
😜 example 1
🍎 context after each
⭐️ top after each

behaviour - other context - example 2
⭐️ top before each
🍎 context before each
😜 example 2
🍎 context after each
⭐️ top after each
```

This shows us that all and only the `beforeEach` and `afterEach` encountered in the path from the start of the spec are run before and after each `it` block is executed.

That's important to keep in mind and can open the door to some interesting simplifications of how the spec is written.

---

_I set out to write this post to share what I thought was a gotcha with the behaviour of `beforeEach` and `afterEach` have in [Quick](https://github.com/quick/quick), but the [example project](https://github.com/mokacoding/quick-beforeeach-aftereach-behaviour) that I made to verify it revealed that my mental model was incorrect. That's for the best, as the actual behaviour is better than what I thought it was._

Get in touch on Twitter [@mokagio](https://twitter.com/mokagio) or leave a comment below if you want to chat about testing with Quick.
