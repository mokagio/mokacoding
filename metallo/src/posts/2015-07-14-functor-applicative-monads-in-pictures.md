---
layout: post
title: Swift Functors, Applicatives, and Monads in Pictures
description: "In this port to Swift of the great of Haskell's \"Functors, Applicatives, And Monads In Pictures\" we are going to look at these functional programming concepts aided by some very helpful pictures."
date: 2015-07-14
tags:
  - Swift
  - Functional Programming
---

> This is a translation of [Functors, Applicatives, And Monads In Pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html) from [Haskell](https://www.haskell.org/) into Swift. 

> I don't want to take any merit for writing this, I only went through the fun exercise of translating the code snippets in Swift. 

> If you enjoy this post be sure to say thanks to the author of the original version: [Aditya Bhargava](http://adit.io/index.html), [@_egonschiele](https://twitter.com/_egonschiele) on Twitter.

> Despite all the hype about it, **Swift is not a functional language**. This means that we need to write a bit of extra code to achieve the same results that language like Haskell have with built-in operators.

> You can find a Playground with all the code from the article [on GitHub](https://github.com/mokacoding/Swift-Functors-Applicative-Monads-In-Pictures-Playground).

> Finally, don't worry if you find the content hard to grasp. I had to read the original version a number of times to wrap my head around it, plus a lot of mess around with the Swift code.

Here’s a simple value:

![](http://adit.io/imgs/functors/value.png)

And we know how to apply a function to this value:

![](http://adit.io/imgs/functors/value_apply.png)

Simple enough. Lets extend this by saying that any value can be in a context. For now you can think of a context as a box that you can put a value in:

![](http://adit.io/imgs/functors/value_and_context.png)

Now when you apply a function to this value, you’ll get different results **depending on the context**. This is the idea that Functors, Applicatives, Monads, Arrows etc are all based on. The `Optional` type defines two related contexts:

> **Note:** the pictures use Maybe (Just | None) from Haskell, which correspond to Swift's Optional .Some and .None.

![](http://adit.io/imgs/functors/context.png)

```swift
enum Optional<T> {
  case None
  case Some(T)
}
```

In a second we will see how function application is different when something is a `.Some(T)` versus a `.None`. First let’s talk about Functors!

# Functors

When a value is wrapped in a context, you can’t apply a normal function to it:

![](http://adit.io/imgs/functors/no_fmap_ouch.png)

This is where `map` comes in (`fmap` in Haskell). `map` is from the street, `map` is hip to contexts. `map` knows how to apply functions to values that are wrapped in a context. For example, suppose you want to apply a function that adds 3 to `.Some(2)`. Use `map`:

```swift
func plusThree(addend: Int) -> Int {
  return addend + 3
}

Optional.Some(2).map(plusThree)
// => .Some(5)
```
or with a simple syntax using Swift's autoclosure:

```swift
Optional.Some(2).map { $0 + 3 }
// => .Some(5)
```

![](http://adit.io/imgs/functors/fmap_apply.png)

**Bam!** `map` shows us how it’s done! But how does `map` know how to apply the function?

# Just what is a Functor, really?

A Functor is any type that defines how `map` (`fmap` in Haskell) applies to it. Here’s how `map` works:

![](http://adit.io/imgs/functors/fmap_def.png)

So we can do this:

```swift
Optional.Some(2).map { $0 + 3 }
// => .Some(5)
```

And `map` magically applies this function, because `Optional` is a Functor. It specifies how `map` applies to `Some`s and `None`s:

```swift
func map<U>(f: T -> U) -> U? {
  switch self {
  case .Some(let x): return f(x)
  case .None: return .None
}
```

Here’s what is happening behind the scenes when we write `Optional.Some(2).map { $0 + 3 }`:

![](http://adit.io/imgs/functors/fmap_just.png)

So then you’re like, alright `map`, please apply `{ $0 + 3 }` to a `.None`?

![](http://adit.io/imgs/functors/fmap_nothing.png)

```swift
Optional.None.map { $0 + 3 }
// => .None
```

![](http://adit.io/imgs/functors/bill.png)

_Bill O’Reilly being totally ignorant about the Maybe functor_

Like Morpheus in the Matrix, `map` knows just what to do; you start with `None`, and you end up with `None`! `map` is zen. Now it makes sense why the `Optional` type exists. For example, here’s how you work with a database record in a language without `Optional`, like Ruby:

```ruby
let post = Post.findByID(1)
if post != nil {
  return post.title
} else {
  return nil
}
```

But in with Swift using the `Optional` functor:

```swift
findPost(1).map(getPostTitle)
```

If `findPost(1)` returns a post, we will get the title with `getPostTitle`. If it returns `None`, we will return `None`! 

We can even define an infix operator for `map`, `<^>` (`<$>` in Haskell), and do this instead:

```swift
infix operator <^> { associativity left }

func <^><T, U>(f: T -> U, a: T?) -> U? {
  return a.map(f)
}

getPostTitle <^> findPost(1)
```

> **Note:** we have to use `<^>` because `<$>` wouldn't compile.

Here’s another example: what happens when you apply a function to an array?

![](http://adit.io/imgs/functors/fmap_list.png)

Arrays are functors too!

Okay, okay, one last example: what happens when you apply a function to another function?

```swift
map({ $0 + 2 }, { $0 + 3 })
// => ???
```

Here's a function:

![](http://adit.io/imgs/functors/function_with_value.png)

Here’s a function applied to another function:

![](http://adit.io/imgs/functors/fmap_function.png)

The result is just another function!

```swift
typealias IntFunction = Int -> Int

func map(f: IntFunction, _ g: IntFunction) -> IntFunction {
  return { x in f(g(x)) }
}

let foo = map({ $0 + 2 }, { $0 + 3 })
foo(10)
// => 15
```

So functions are Functors too! When you use fmap on a function, you’re just doing function composition!

# Applicatives

Applicatives take it to the next level. With an applicative, our values are wrapped in a context, just like Functors:

![](http://adit.io/imgs/functors/value_and_context.png)

But our functions are wrapped in a context too!

![](http://adit.io/imgs/functors/function_and_context.png)

Yeah. Let that sink in. Applicatives don’t kid around. Unlike Haskell, Swift doesn't have _yet_ a built-in way to deal with Applicative. But it is very easy to add one! We can define an `apply` function for every type supporting Applicative, which knows how to apply a function wrapped in the context of the type to a value wrapped in the same context:

```swift
extension Optional {
  func apply<U>(f: (T -> U)?) -> U? {
    switch f {
      case .Some(let someF): return self.map(someF)
      case .None: return .None
    }
  }
}

extension Array {
  func apply<U>(fs: [Element -> U]) -> [U] {
    var result = [U]()
      for f in fs {
        for element in self.map(f) {
          result.append(element)
        }
      }
      return result
    }
}
```

If both `self` and the function are `.Some`, then the function is applied to the unwrapped option, otherwise `.None` is returned. _Also note that because the optional type is defined in terms of `Optional<T>` we only need to specify the generic type `U` in `apply`s signature._

We can also define `<*>`, to do the same thing:

```swift
infix operator <*> { associativity left }

func <*><T, U>(f: (T -> U)?, a: T?) -> U? {
  return a.apply(f)
}

func <*><T, U>(f: [T -> U], a: [T]) -> [U] {
  return a.apply(f)
}
```

![](http://adit.io/imgs/functors/applicative_just.png)

i.e:

```swift
Optional.Some({ $0 + 3 }) <*> Optional.Some(2)
// => 5
```

Using `<*>` can lead to some interesting situations. For example:

```swift

[ { $0 + 3 }, { $0 * 2 } ] <*> [1, 2, 3]
// => [ 4, 5, 6, 2, 4, 6 ]
```

![](http://adit.io/imgs/functors/applicative_list.png)

> **Note:** the original article now shows how Applicatives are more powerful than Functors in that they allow function application with multiple parameters. Again this is not feasible in vanilla Swift, but we can work around it by defining the function we want to handle in a [curried way](https://en.wikipedia.org/wiki/Currying). 

Here’s something you can do with Applicatives that you can’t do with Functors. How do you apply a function that takes two arguments to two wrapped values?

```swift
func curriedAddition(a: Int)(b: Int) -> Int {
  return a + b
}

curriedAddition <^> Optional(2) <^> Optional(3)
// => COMPILER ERROR: Value of optional type '(Int -> Int)? not unwrapped; did you mean to use '!' or '??'
```

Applicatives:

```swift
curriedAddition <^> Optional(2) <*> Optional(3)
```

`Applicative` pushes `Functor` aside. “Big boys can use functions with any number of arguments,” it says. “Armed with `<^>` and `<*>`, I can take any function that expects any number of unwrapped values. Then I pass it all wrapped values, and I get a wrapped value out! AHAHAHAHAH!”

```swift
func curriedTimes(a: Int)(b: Int) -> Int {
  return a * b
}

curriedTimes <^> Optional(5) <*> Optional(3)
```

# Monads

How to learn about Monads:

1. Get a PhD in computer science.
2. Throw it away because you don’t need it for this section!

Monads add a new twist.

Functors apply a function to a wrapped value:

![](http://adit.io/imgs/functors/fmap.png)

Applicatives apply a wrapped function to a wrapped value:

![](http://adit.io/imgs/functors/applicative.png)

Monads apply a function that returns a wrapped value to a wrapped value. Monads have a function `|` (>>= in Haskell) (pronounced “bind”) to do this.

Monads have a function `flatMap` (`liftM` in Haskell) to do this. And we can define an infix operator `>>-` (`>>=` in Haskell) for it.

```swift
infix operator >>- { associativity left }

func >>-<T, U>(a: T?, f: T -> U?) -> U? {
  return a.flatMap(f)
}
```

> **Note:** Unlike `<$>`, `>>=` would compile. I decided to use `>>-` to be in line with the library [Runes](https://github.com/thoughtbot/Runes) which provides "Infix operators for monadic functions in Swift", and it's hopefully going to become the standard for this sort of things.

Let’s see an example. Good ol’ Optional is a monad:

![](http://adit.io/imgs/functors/context.png)

Just a monad hanging out

Suppose `half` is a function that only works on even numbers:

```swift
func half(a: Int) -> Int? {
  return a % 2 == 0 ? a / 2 : .None
}
```

![](http://adit.io/imgs/functors/half.png)

What if we feed it a wrapped value?

![](http://adit.io/imgs/functors/half_ouch.png)

We need to use `>>-` (`>>=` in Haskell) to shove our wrapped value into the function. Here’s a photo of `>>-`:

![](http://adit.io/imgs/functors/plunger.jpg)

Here’s how it works:

```swift
Optional(3) >>- half
// .None
Optional(4) >>- half
// 2
Optional.None >>- half
// .None
```

What's happening inside? Let's look at `>>-`'s (`>>=` in Haskell) signature again:

```swift
// For Optional
func >>-<T, U>(a: T?, f: T -> U?) -> U?

// For Array
func >>-<T, U>(a: [T], f: T -> [U]) -> [U]
```

![](http://adit.io/imgs/functors/bind_def.png)

So `Optional` is a Monad. Here it is in action with a `.Some(3)`!

![](http://adit.io/imgs/functors/monad_just.png)

And if you pass in a `.None` it’s even simpler:

![](http://adit.io/imgs/functors/monad_nothing.png)

You can also chain these calls:

```swift
Optional(20) >>- half >>- half >>- half
// => .None
```

![](http://adit.io/imgs/functors/monad_chain.png)

> NOte: the original article now describes Haskell's `IO` Monad. Swift doesn't have anything like that so this translation skips it.

# Conclusion

1. A functor is a type that implements `map`.
2. An applicative is a type that implements `apply`.
3. A monad is a type that implements `flatMap`.
4. `Optional` implements `map` and `flatMap`, plus we can extend it to implement `apply`, so it is a functor, an applicative, and a monad.

What is the difference between the three?

![](http://adit.io/imgs/functors/recap.png)

* **functors**: you apply a function to a wrapped value using `map`.
* **applicatives**: you apply a wrapped function to a wrapped value using `apply`, if defined.
* **monads**: you apply a function that returns a wrapped value, to a wrapped value using `flatMap`.

So, dear friend (I think we are friends by this point), I think we both agree that monads are easy and a SMART IDEA(tm). Now that you’ve wet your whistle on this guide, why not pull a Mel Gibson and grab the whole bottle. Check out LYAH’s [section on Monads](http://learnyouahaskell.com/a-fistful-of-monads). There’s a lot of things I’ve glossed over because Miran does a great job going in-depth with this stuff.

> Thanks for reading through this article, if you have any feedback, suggestion, or error to report please tweet me [@mokagio](https://twitter.com/mokagio), or leave a comment below.

> If you want to play around with the code head over to GitHub and [clone the Playground](https://github.com/mokacoding/Swift-Functors-Applicative-Monads-In-Pictures-Playground)

> Once again, thanks [Adit](https://twitter.com/_egonschiele) for the wonderful post, and for all the other great ones on [the blog](http://adit.io/index.html).

_Happy coding, and leave the codebase better than you found it_
