---
title: Honesty-Oriented Programming
---

It's time to trascend the constraints of functional vs. object-oriented programming, and start practicing "honesty-oriented programming".
What's is HOP, you might ask?
It's the discipline of writing honest code.
Code with interfaces and sigantures that don't lie to your face.

The other day, I came across a post by Michael Feathers, the author of one of my favorite software books, [Working Effectively with Legacy Code](), titled [_Functional Code is Honest Code_]().

There are different takes on what it means to be functional, as well as many different language implementation.
There are some common traits across all of them, though, which Feathers identifies as immutability, a strong type systems, and referential transparency.
Having at least two of those working together is "_enough to give us Good Stuff™_."

Referential transparency, in particular, has the advantage of making the code _honest_.

> That is, to say, [the code] is _honest_. You can look at the signatures and see what is possible.

_If you need a refresher on what referential transparency means, like I did when reading the post, [I got an article for you]()._

Techniques to make the code more testable, such as [making its dependencies explicit](https://www.mokacoding.com/blog/explicit-dependencies/), are all geared towards making it as close as possible to a referentially transparent state.

Most of the code you read calls other code.
When you look at those calls and know that they do what they say in their interface, without hidden side effects, you gain confidence.
It become easier to reason about the code.
You can hold more of the behavior in your mind, because you don't need to jump in and out of implementations to make sure there are other things going on under the hood.

If you don't work in a language enforcing referential transparency like [Haskell]() and [Elm](), you'll need the discipline to make sure all the dependencies of your code are explicit and all its side effects exposed in the return type.
That takes hard work and extra code.
But it's all worth it in terms of future understand- and maintainability.

> That’s the goal, really. Simplify understanding. [No surprises](https://www.mokacoding.com/blog/explicit-dependencies/). Honest code.

It doesn't matter wherther you work in an functional or OO language, when practicing honesty-oriented programming you'll end up with code that is easier to work with.
