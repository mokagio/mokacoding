---
title: Referential Transparency in Swift
description: An explanation of what referential transparency means with examples in Swift
tags:
- Swift
---

The [Wikipedia](https://en.wikipedia.org/wiki/Referential_transparency) definition for referential transparency is

> An expression [that] can be replaced with its corresponding value without changing the program's behavior.

Here's an example in Swift:

```swift
func rtIncrement(_ number: Int) -> Int {
    return number + 1
}
```

Functions that are not referentially transparent are referentially opaque.

```
var i = 0

func roIncrement(_ number: Int) -> Int {
    i += 1
    return number + i
}
```

Take these two expressions:

```swift
let a = rtIncrement(x) + rtIncrement(y) * (rtIncrement(x) - rtIncrement(x))
let b = rtIncrement(x)
```

Referential transparency means that we can replace an invocation of `rtIncrement` with its value.
That way, we can simplify `a` into:

```swift
rtIncrement(x) + rtIncrement(y) * 0
```

and then into:

```swift
rtIncrement(x) + 0
```
Because of referential transparency, `a == b` is true; the two expressions are equivalent.

The same cannot be said for the referentially opaque counterpart.

```swift
let a = roIncrement(x) + roIncrement(y) * (roIncrement(x) - roIncrement(x))
let b = roIncrement(x)
```

Every time `roIncrement` is called, the global value `i` changes.
So, `roIncrement(x) - roIncrement(x)` is not equal to 0, but -1 (`x + i - (x + (i + 1)) = x + i - x - i - 1`).

So what?
Being able to simplify expressions might be interesting for mathematicians and  people building compiler optimizations, but what does it mean for the everyday software development like you and I?

In practical terms, **code that is not referentially transparent is harder to reason about**.

The function signature of referentially opaque code doesn't tell the whole story.
It's not [honest](https://www.mokacoding.com/blog/honesty-oriented-programming).
You cannot trust that a function does only what it says by only looking at its input and output types, you need to drill into the implementation.

In the real world, `roIncrement` could be a `loadData()` function to load the data for the UI which toggles a flag in the global state in its implementation.
Reading the code calling `loadData()` you wouldn't know the flag has been toggled already, so you might end up toggling it again resulting in an incorrect state of the system.
The only way to know that flag had already been changed, is to ready the implementation of `loadData()`.
This takes more effort and time.

Languages like [Haskell](https://www.haskell.org/) and [Elm](https://elm-lang.org/) enforce referential transparency.
In other languages, referential transparency can be achieved with techniques such as [making all the dependencies explicit](https://www.mokacoding.com/blog/explicit-dependencies/).

When you go back to your IDE after reading this post and find yourself writing a new method, think about its dependencies and side effects.
Can you make it referentially transparent?
