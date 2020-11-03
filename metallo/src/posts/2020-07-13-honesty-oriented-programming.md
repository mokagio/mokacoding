---
title: Honesty-Oriented Programming
description: If you focus on writing honest code, you'll end up with software that is easier to understand and work with.
tags:
- Software Design
date: 2020-07-13 01:00
---

If you focus on writing _honest_ code, regardless of the language and paradigm you work in, you'll end up with software that is easier to understand and work with.

In his post [_Functional code is honest code_](https://michaelfeathers.silvrback.com/functional-code-is-honest-code), [Michael Feathers](https://geni.us/WcwM) identifies common threads among the different philosophies and implementations of functional programming:
immutability, referential transparency, and a strong type systems.
Of course, a language doesn't have to feature them all to be functional, but having at least two of those working together is "_enough to give us Good Stuff™_."

[Referential transparency](https://mokacoding.com/blog/referential-transparency-in-swift), in particular, has the advantage of making the code honest.

> That is, to say, [the code] is honest. You can look at the signatures and see what is possible.

Techniques to make the code more testable, such as [making its dependencies explicit](https://mokacoding.com/blog/explicit-dependencies/), have the side effect of making it more referentially transparent.

Most of the code you read calls other code.
When you look at those calls and know that they do what they say in their interface, without hidden side effects, you gain confidence.
It becomes easier to reason about the code.
You don't need to drill in and out of implementations to make sure there aren't other things going on under the hood, you can just follow the code.

If you don't work in a language enforcing referential transparency like [Haskell](https://www.haskell.org/) or [Elm](https://elm-lang.org/), you'll need the discipline to make sure all the dependencies of your code are explicit and all its side effects exposed in a return type.
That takes hard work and extra code but it's all worth it in terms of future understandability and maintainability.

> That’s the goal, really. Simplify understanding. [No surprises](https://mokacoding.com/blog/explicit-dependencies/). Honest code.

It's time to end the paradigms war, set aside language preferences, and focus on practicing Honesty-Oriented Programming instead.
