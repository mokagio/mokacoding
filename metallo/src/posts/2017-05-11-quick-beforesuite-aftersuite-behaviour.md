---
layout: post
title: Quick beforeSuite and afterSuite behaviour
description: "A look at how beforeSuite and afterSuite behave in the Quick testing framework, and the dangers of using them"
tags:
- Quick
- Espresso
- Testing
---

After I shared [this little post about Quick beforeEach and afterEach](https://www.mokacoding.com/blog/quick-beforeeach-aftereach-behaviour/) with the team at [iflix](https://twitter.com/iflixdevs), Gerald popped a question in our chat:

![Gerald's question: how does beforeSuite fits in the calls hierarchy?](https://s3.amazonaws.com/mokacoding/2017-05-11-beforesuite-aftersuite-question.jpg)

Here's the documentation these two functionalities:

> `beforeSuite`
>
> Defines a closure to be run **prior to** any examples in the test suite.
> You may define an unlimited number of these closures, but there is no guarantee as to the order in which they're run.

> `afterSuite`
>
> Defines a closure to be run **after all** of the examples in the test suite.
> You may define an unlimited number of these closures, but there is no guarantee as to the order in which they're run.

The [example code](https://github.com/mokacoding/quick-beforeEach-afterEach-behaviour) from the previous example has been updated adding calls to `beforeSuite` and `afterSuite`.

```swift
import Quick

class Spec: QuickSpec {
  override func spec() {
    beforeSuite {
      print("☕️ before suite")
    }

    describe("beforeEach and afterEach behaviour") {
      beforeEach {
        print("⭐️ top before each")
      }

      context("some context") {
        beforeEach {
          print("👉 context before each")
        }

        // ...
      }

      afterEach {
        print("⭐️ top after each")
      }
    }

    afterSuite {
      print("🗑 after suite")
    }
  }
}
```

In the code above `beforeSuite` and `afterSuite` are positioned at the very top and very bottom of the test, but you can put them anywhere inside a `describe` or `context`.

Can you guess how the console log will look like?

```
☕️ before suite
😈 an after suite call you weren't aware of

behaviour - some context - example 1
⭐️ top before each
👉 context before each
😊 example 1
👉 context after each
⭐️ top after each

...

behaviour - other context - example 2
⭐️ top before each
🍎 context before each
😜 example 2
🍎 context after each
⭐️ top after each

🗑 after suite
😈 an after suite call you weren't aware of
```

Hang on a second, where do those 😈 logs come from?!

### The danger of using `beforeSuite` and `afterSuite`

Quick will look for all the `beforeSuite` and `afterSuite` calls in all your test suite, and run them respectively all at the start and all at the end.

Those unexpected 😈 console logs are simply defined in another spec in the project.

This is one of the danger of `beforeSuite` and `afterSuite`, there is no way other that by doing a text search to know how many such calls there are and where.

As time passes one might even forget having added those calls. That's a recipe for issues that are hard do debug.

The other danger is that being able to fiddle with state in the unit tests can lead us to write tests that are not as isolated and robust as they should be. If unit tests are isolated and simple to setup then the code they test will be simple and easy to setup as well.

Yes, `beforeSuite` and `afterSuite` can be life savers when you need to get started writing test on legacy code and you really cannot take out certain assupmtions baked in it. They allow you to work around them, and get the job done.

In such cases though, I would encourage you to leave a big FIXME note there:

```
// FIXME: Doing this now because the app makes assumptions that impact each
// unit test.
//
// Need to allocate proper time to refactor for isolation.
//
// If you are reading this comment after <date> get in touch with <person>.
```

Until next time:

👋 _Leave the codebase bettern than you found it_
