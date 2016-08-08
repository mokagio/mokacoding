---
title: Implicitly vs Force Unwrapping Swift Optionals
description: A look at what implicitly unwrapping and force unwrap a Swift Optional mean, and how they differ from each other.
tags:
- Swift
---

This post is a followup to a ["Why Implicitly Unwrapping Swift Optionals Is
Dangerous"](http://www.mokacoding.com/blog/why-implicitly-unwrapping-swift-optionals-is-dangerous/).
[Daniel H Steinberg ](http://dimsumthinking.com/), on Twitter as
[@dimsumthinking](https://twitter.com/dimsumthinking),
pointed out to me that the terminology used in the poost wasn't accurate:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/mokagio">@mokagio</a> Actually your article is about explicitly unwrapped optionals not implicitly unwrapped. Very different.</p>&mdash; dimsumthinking (@dimsumthinking) <a href="https://twitter.com/dimsumthinking/status/758290839504359424">July 27, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

He was right. I went back on the [Swift
book](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Types.html#//apple_ref/swift/grammar/optional-type),
did more reading, and understood that what I kept referring to as implicitly
unwrapping is a technique actually
called force unwrapping, and that to implicitly unwrap an `Optional` value
means something slighltly different.

Let's have a look.

## Implicitly Unwrapping

You define an `Optional` as impliticly unwrapped when you define its type like
this:

```swift
let x: String!
```

This technique allows you to tell the compiler to automatically unwrap that
value, as if it wasn't optional at all.

Simlarly to `Type?` which is a syntactic sugar for `Optional<Type>`, `Type!` is
equivalent to `ImplicitlyUnwrappedOptional<Type>`.

A common example of implicitly unwrapped optionals is how view controller
define their `IBOutlet`s:

```swift
@IBOutlet var messageLabel: UILabel!
@IBOutlet var actionButton: UIButton!
```

It makes sense to define the outlets as implicitly unwrapped optionals because
their are going to be instantiated by Interface Builder. It would be cumbersome
to always unwrap each view outlet inside view controllers.

Because of their implicitly unwrapped nature, if you forget to connect an
outlet to it Interface Builder view an run the app you'll get a runtime error
when you try to access it in the view controller.

## Force Unwrap

Force unwrap, or force-unwrap, or forced unwrapping, is the technique most
of [the previous post]() was actually about. It consist in adding a `!` after
an `Optional` value, to automatically unwrap it, without having to check
whether it is `nil` or not.

```swift
let strings = ["mokacoding", "is", "a", "blog"]
let firstLength: Int = strings.first!.length
```

Like implicitly unwrapping, force unwrap uses a `!` and makes the compiler
treat an otherwise optional value as the type it wraps. Unlike implicitly
unwrapping though, this technique is used on existing values.

You define a type as implicitly unwrapped, `ImplicitlyUnwrappedOptional<T>`,
and you force unwrap a value which has `Optional` type.

## They are both dangerous

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/dimsumthinking">@dimsumthinking</a> While semantically different, the end result of using either of the two tools is the same though: less runtime confidence</p>&mdash; You can call me Joe (@mokagio) <a href="https://twitter.com/mokagio/status/758470579276029952">July 28, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

As said in the `IBOutlet` example and in [the previous
post](http://www.mokacoding.com/blog/why-implicitly-unwrapping-swift-optionals-is-dangerous/),
unwrapping an `Optional` value without taking into account its nullability is
dangerous, it can in fact crash your app.

There are some scenarios in which implictly or forced unwrapping an `Optional`
can make sense, such as the outlets scenario. It is up to us as developers to
take into account the tradeoff between code that is easier to consume, versus
code that leverages the compiler to guarantee its safety.

My take on this? Never use `!` apart for `IBOutlet`s. I'd rather sprinkle `if
let`s and `guard lets`s all around my code then access a `nil` value and crash
my apps because something changed an the assumption "its never going to be `nil`"
which I made when I wrote that `!` is no longer valid, but I forgot about having
written it in the first place.

How do you feel about impliticly unwrapping or force unwrap `Optional` values?
Get in touch on Twitter [@mokagio](https://twitter.com/mokagio) or leave a
comment below.

Thanks again [Daniel](https://twitter.com/dimsumthinking) for pointing my
mistake out, leading to me learning more about Swift, an writing this post 😄.

_Leave the codebase better than you found it_
