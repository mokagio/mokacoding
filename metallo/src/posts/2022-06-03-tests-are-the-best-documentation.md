---
title: Tests Are The Best Kind Of Documentation
description: Unit tests are a vital tool for writing quality code. They also happen to be the best kind of documentation for your software, the kind that never gets out of date.
og_description: Tests are the only documentation that never gets out of date
tags:
  - testing
---

When learning about unit testing, we're often shown the value they bring in speeding up the development feedback loop and nudging us towards better software architecture.
But there's another reason tests are software developers' greatest allies:

**Tests are living documentation of the production code.**

When you think of tests this way, you also see the value of writing readable and well-structured tests.

I was recently reminded of tests' role as documentation when looking at how to mark a [Fastlane](https://fastlane.tools/) action as deprecated.
Fastlane has a detailed [documentation site](https://docs.fastlane.tools/), but no one has gotten on to write docs for deprecation.

_Side note: Contributing documentation is a great way to get involved in an open-source project. It's something you can do regardless of your skill level with the project's language and tools._

Lucky for me, the Fastlane maintainers invested in a good test suite.
I'm speculating, but I bet that's a direct result of the project's size and complexity.
Fastlane has so many features, configuration options, and possible ways to use it that it would be impossible to manually verify the code's behavior.

Since I couldn't find documentation for how to deprecate an action, I looked in the tests.
I quickly found the one I was looking for, and it immediately showed me what to do.
Happy days.

**The advantage of learning about software's behavior by looking at its tests is that you are guaranteed to be looking at working examples.**
Conversely, there's little you can do to ensure the snippets in a documentation site are up-to-date.
You can't compile plain language.

How well tests document the software depends on how well they are written.
To a certain extent, readability is in the eye of the beholder and in how familiar they are with the language and project's conventions.
The topic is too broad to tackle in a blog post, but there are a few guidelines I think we can all agree on.

**Separate the Arrange, Act, and Assert stages.**
Visually separating the code that prepares the system under tests (Arrange) from the part that exercises it (Act) and the one that verifies its behavior (Assert) will help readers understand how the tests flow and quickly identify the call site.

**Exercise a single method and verify a single _behavior_.**
Each test should act on only one API of its system under test and only verify how that single one behaves.
Notice that verifying a single behavior doesn't mean having only one assertion.
Certain behaviors have different facets that require dedicated assertions but all fit in the same tests.

**Use helper methods to improve readability but avoid shared setup code**.
One of my favorite advice from [Clean Code](https://geni.us/cz8vB5) is to replace comments with code whenever possible.
Particularly in the arranging stage of a test, if you find yourself needing multiple calls, it pays to extract them into a helper method.

Helper methods shouldn't be confused with shared setup code.
Helpers hide noisy implementation details behind their method signature.
When looking at a test, a reader will see the helper method and decide whether to drill into it or not.
But if implementation details are tucked away in a test life-cycle method, in XCTest those are the various `setUp...` and `tearDown...` ones, a reader might miss them.

Remember, the end goal is to help readers understand everything they need to work with a specific API by looking at its tests.
Helper methods summarize information but shared setup and tear-down hide it.

---

Unit tests are, first and foremost, a tool for writing better code.
That they also are living documentation is a nice side effect of being a specialized consumer of the code's API.
Still, all the recommendations that make tests read like good documentation also make them read like better code.

Spending a couple of extra minutes refining your tests once they are green will help future readers, whether they are trying to modify the code or merely want to learn how to use it.

_And you know what's the best way to write good tests? Practicing Test-Driven Development! Checkout [Test-Driven Development in Swift](https://tddinswift.com) to learn how._
