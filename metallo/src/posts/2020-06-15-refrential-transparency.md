---
title: Referential Transparency
---

The Wikipedia definition for referential transparency is

> An expression is called referentially transparent if it can be replaced with its corresponding value without changing the program's behavior.

Here's an example in Swift.

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
That way we can simplify `a` into:

```swift
rtIncrement(x) + rtIncrement(y) * 0
```

and then

```swift
rtIncrement(x) + 0
```
Because of referential transparency, `a == b` is true.
That's to say, the two expressions are equivalent.

The same cannot be said for the referentially opaque counterpart.

```swift
let a = roIncrement(x) + roIncrement(y) * (roIncrement(x) - roIncrement(x))
let b = roIncrement(x)
```

Every time `roIncrement` is called, the global value `i` changes.
So, `roIncrement(x) - roIncrement(x)` is not equal to 0, but -1 (`x + i - (x + (i + 1)) = x + i - x - i - 1`).

So what?
Being able to simplify expressions might be interesting for people building compiler optimizations, but what does it mean everyday software development?

In practical terms, code that is not referentially transparent is harder to reason about.

The function signature is not as informative, you always need to look into the implementation of the code to check for side effects.

Languages like [Haskell]() and [Elm]() enforce referential transparency.
In other languages, referential transparency can be achieved with techniques such as [making all the dependencies explicit](https://www.mokacoding.com/blog/explicit-dependencies/).
