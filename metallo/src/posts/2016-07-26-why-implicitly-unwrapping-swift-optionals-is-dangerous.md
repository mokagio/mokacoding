---
title: Why Implicitly Unwrapping Swift Optionals Is Dangerous
description: "A look at what implicitly unwrapping an Optional value means and why it should be avoided."
tags:
- Swift
---

## Update

The terminology used in this post is not entirely correct. In most of the
occasions where "implicitly unwrapping" it's used what should actually be used
is "force unwrap".

You can read more about the difference between the two
[here](http://mokacoding.com/blog/impliticly-vs-force-unwrapping-swift-optionals.md).

The message of the post doesn't change though. Implicitly and force unwrapping
Swift optionals is dangerous. Read along to find out why.

---

This post is the third and last part of the little series on Swift's `Optional`
type that I've been writing over the past few weeks.

- [What is an optional value in Swift](http://www.mokacoding.com/blog/what-is-an-optional-value-in-swift/)
- [Writing your own Swift "if let"](http://www.mokacoding.com/blog/writing-your-own-swift-if-let/)

The idea to start writing about `Optional` came from a code review conversation
at my current client:

> **[Team Member]** The !’s make the code read like you’re really excited.
>
> **[Gio]** The `!`s are **very dangerous**, and should be used only in extreme
> circumstances.
>
> **[Team Member]** @gio what does `!` mean as opposed to `?` or nothing at all?

In "[What is an optional value in
Swift](http://www.mokacoding.com/blog/what-is-an-optional-value-in-swift/)" we
introduced Swift's `Optional` enum, and saw how it is used to _wrap_ values to
express their nullability: `Optional<Type>`.

The cool thing about Swift and Optionals is that if a type is not optional, you
can be sure that a value of such type won't be nil.

This code **will not compile**:

```swift
let x: String = nil
// error: nil cannot initialize specified type 'String'
```

This is pretty cool. It means that if you receive a type that is not `Optional`
you don't have to worry about nullability. This takes away a lot of mental load
when writing and reading code, and saves us from always checking for `!= nil`
like we did in Objective-C.

[In the previous
post](http://www.mokacoding.com/blog/what-is-an-optional-value-in-swift/) we
also saw that `?` is just syntactic sugar for the full `Optional` declaration.

These lines do the same thing:

```swift
let a: Optional<Int> = 42

let b: Int? = 42
```

The compiler helps us out when dealing with optionals by preventing us from
using an optional value as if it was an actual value:

```swift
var x: String? = "abc"

x.isEmpty
// ^__ won't compile:
//
// error: value of optional type 'Optional<String>' not unwrapped; did you mean to use '!' or '?'?
```

We can't call `isEmpty` directly on our `String?` value, because we don't know
if it's nil or not.

To do so we need to _unwrap_ the actual value from the Optional container, as
the compiler error suggests.

Like this:

```swift
if let someString = x {
  someString.isEmpty
} else {
  print("Sorry mate, x is nil")
}
```

Another option is to access it like this:

```swift
someString?.isEmpty
```

The type returned by that code is `Optional<Bool>`, it carries the optional
wrapping with it.

What does `!` mean then? The `!` syntax allows us to <del>_implicitly
unwrap_</del> _force unwrap_ optional values.

```swift
someString!.isEmpty
```

The type returned by the code with `!` is `Bool` now, the optional wrapping has
been removed by the compiler.

The important difference is that while when using `if` or `guard` we are
actually unwrapping the value out of the optional container and deal with the
case in which it is `nil`, using <del>implicitly unwrapping</del> force unwrap
we are not.

When you write a `!` you're telling the compiler "Dude, chill about these
`nil`, I assure you that there's a value in there. Trust me!". And the compiler
like every other good machine will do what its told and proceed to unwrap the
`!`-ed value without needing a check for it.

The problem with this is that these assumptions developers do are more often
than not proved wrong, leaving your software to deal with a `nil` value at
runtime.  And there's only one result there: it will crash.

Consider this:

```swift
let sneakyNilValue: Optional<String> = nil
let x: Bool = sneakyNilValue!.isEmpty
```

The compiler will consider `sneakyNilValue!` as unwrappable without needing to
check, and compile all right. At runtime `.isEmpty` will be called on what is
expected to be a `String`, but is actually `nil`, with this result:

```
fatal error: unexpectedly found nil while unwrapping an Optional value
Current stack trace:
0    libswiftCore.dylib                 0x000000010a2fd730 swift_reportError + 132
1    libswiftCore.dylib                 0x000000010a319cf0 _swift_stdlib_reportFatalError + 61
2    libswiftCore.dylib                 0x000000010a11e300 specialized specialized StaticString.withUTF8Buffer<A> (invoke : (UnsafeBufferPointer<UInt8>) -> A) -> A + 351
...
```

This is the reason I told my colleagues "The `!`s are **very dangerous**, and
should be used only in extreme circumstances.".

<del>Implicitly unwrapping</del> Force unwrap gives you the power to treat
optional values as actual values, but from great powers come great
responsibilities. You need to be 100% sure that the value you
<del>implicitly</del> force unwrapped will never be nil, or you're app will
crash, and you're users will be unhappy.

Personally I prefer to spend that little extra time to write code to handle
nullability and make my app more robust. I don't trust my assumptions, and I
don't trust values getting into my code from third parties.

What about you?

If you have more questions regarding Optionals please do leave a comment below,
or get in touch on Twitter [@mokagio](https://twitter.com/mokagio).

All the code examples from this post are available [in this script on
GitHub](https://github.com/mokacoding/swift-implicitly-unwrapping-danger), run
it to see the crashes and compiler errors we've been talking about.

_Leave the codebase better than you found it._
