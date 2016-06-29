---
title: What is an optional value in Swift
description: "This post looks into one of Swift's most powerful feature: optionals"
tags:
- Swift
---

_Note: this is the first of a short series of short posts on Swift `Optional`,
[subscribe to the newsletter](#subscribe) or [RSS
feed](http://www.mokacoding.com/feed.xml) to avoid missing out on the next
ones._

Optional values are definitely one of my favourite things about Swift.

I love they how force you to deal with nullability, and how the
compiler never fails to remind when you are not doing so. I
also love that if a value _is not_ optional then I am
guaranteed it is an actual value, and I don't have to worry
about `nil` at all.

The Swift team has done a great job at making working with optional values easy
and straightforward. Developers can work with optionals without really knowing
they're there. This is great to onboard beginners, but I feel that to fully
appreciate, and leverage, optionals we need to dig a bit deeper.

Let's have a look at this piece of code for example:

```swift
let x: String? = "Hello World"

if let y = x {
  print(y)
}
```

When I started looking into Swift my understanding of this code would have been
something like: "there's a value `x` that is a `String` that may or may not be
nil. Make sure that `x` is not nil, and if so print it".

That is what that code does, right?

The point that I was missing is that `x` is not "a `String` that may or may not
be nil", but a different type all together.

In fact if you add a `print(x.dynamicType)` statement in the code above you'll
see this in the console:

```
Optional<String>
```

`String?` is actually syntactic sugar for `Optional<String>`, and `Optional` is
a type in its own right.

Here's a simplified version of the header of `Optional`, which
you can see by command-clicking on the word `Optional` in your
code from Xcode:

```swift
enum Optional<Wrapped> {

  /// The absence of a value.
  case none

  /// The presence of a value, stored as `Wrapped`.
  case some(Wrapped)
}
```

`Optional` is actually an `enum`, defined in relation to a generic type
`Wrapped`. It has two cases: `.none` to represent the absence of a value, and
`.some` to represent the presence of a value, which is stored as its associated
value of type `Wrapped`.

I find the fact that such a powerful tool is implemented in such a simple
fashion remarkable and fascinating.

Let me go through it again: `String?` is not a `String` but an
`Optional<String>`, `Int?` is not an `Int` but an `Optional<Int>`, and so on.

Understanding that optional values have a different type explains why we need
to check if the actual value is there or not before using it.

One cannot call `.length` on an `Optional<String>` the same way one cannot call
`.legth` on an `Int`, the type doesn't have the method. And even if it had it
we would be calling it on the wrong object.

The fact that `Optional` is a type means that it has its own methods, for
example `map` and `flatMap`. If you are curious about what they do [check out
this post](http://www.mokacoding.com/blog/demistifying-swift-functor/).

## What does "unwrapping optionals" really mean

When describing the `if let` example code above, if past me wanted to show off,
it would have said "I unwrap the optional". But let me tell you, he didn't know
what he was talking about.

Fortunately we now have seen that `T?` really means `Optional<T>`, and the
whole wrapping business now makes more sense.

A value of optional type _wraps_ another type. It can wrap any type, so in its
definition we use a generic, which we can call `T` or `Wrapped` like the Swift
team has done for extra clarity.

You can imagine `Optional` hugging `Wrapped` with its angle bracket arms, to
keep it safe from the dangers of nullability.

Now the sentence "I unwrap the optional" makes more sense. Tools like `if let`
aand `guard let` allow us to try to get the actual value out of its `Optional`
wrapper, and react to the case when its not there.

---

I hope this post has helped you appreciating Swift's optional values, and
understand what all those `?` really mean. But what about the `!`? We'll look
at them in the next post, [subscribe]() to avoid missing out 😉.

Feel free to get in touch with me on Twitter
[@mokacoding](https://twitter.com/mokacoding) or to leave a comment below if
you have any questions or if there's something wrong in the post.

_Leave the codebase better than you found it._
