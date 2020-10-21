---
title: "What can a pipe wrench teach us about software engineering?"
description: "With his famous pipe wrench lecture, Vannevar Bush taught young MIT engineers the value of precision. The same teaching holds true for software developers."
tags:
  - Books
  - Software Design
  - Swift
og_image: https://mokacoding.s3.amazonaws.com/2020-10-21-pipe-wrench.jpg
---

What can a pipe wrench teach us about software engineering?
A lot, according to [Vannevar Bush](https://en.wikipedia.org/wiki/Vannevar_Bush).

An electrical engineer and professor at MIT, Bush was "one of the most politically powerful inventors in America since Benjamin Franklin," as his biographer [G. Pascal Zachary puts it](https://geni.us/liVH8).
During WWII, he personified the United State's military research, organized the Manhattan Project, and played a crucial role in the Allied victory.
He was also a mentor to [Claude Shannon](https://en.wikipedia.org/wiki/Claude_Shannon), the father of the information age.

One anecdote of Bush's career as an instructor at MIT particularly inspired me: his pipe wrench lecture.

Bush would greet an auditorium filled with aspiring engineers, hold up a pipe wrench, and challenge them: "Describe this".

<img src="https://mokacoding.s3.amazonaws.com/2020-10-21-pipe-wrench.jpg" style="margin: 0 auto; display: block" width=70% alt="image of a pipe wrench"/>

<p style="text-align: center; opacity: .6; font-size: .85rem"><i>Not the actual pipe wrench showed by Bush, I found this one on Amazon.</i></p>

One by one, they would try, and each time Bush would dissect the description, pointing out where it was vague.

Finally, he would write in precise English a patent application for the wrench:

> By turning the nut to the right or left the movable jaw may be moved either toward or away from the fixed jaw, as may be desirable.
> The inner face of the movable jaw is formed at a right angle to its shank, and is also provided with a series of teeth, which pitch or rake on its fellow jaw...

With this exercise, Bush drilled into the class the value of precision.

## Precision

"Given the pipe wrench, produce the words for that wrench and no other; given the words, produce the wrench.
That, Bush taught his students, was the beginning of engineering", write Soni and Goodman in [_A Mind at Play_](https://geni.us/FqRN7P).

Bush MIT students were electrical engineers, but precision is something software engineers should learn, too.

Precision is fundamental when representing building a model for the domain of the software in code.

One way in which a domain representation can be vague is when it allows inconsistent state to occur.
If you work in a language with a strong type system, like Swift, you can use precise types to make your domain modeling clearer and make undesirable state unrepresentable.

For example, when modeling an operation that can either succeed with some data or fail with an error, you could use a type like this:

```swift
struct Operation {
  let success: Bool
  let data: Data?
  let error: Error?
}
```

This type does the job but leaves room for errors: nothing stops you from creating an instance with `success` true but `data` nil or one with values in both `data` and `error`.

```swift
let inconsistentOperation = Operation(success: false, data: someData, error: .none)
```

Using the [`Result` `enum`](https://developer.apple.com/documentation/swift/result), you can remove this ambiguity _at compile time_, making it impossible for both data and error to be set simultaneously.

```swift
struct Operation {
  let result: Result<Data, Error>
}
```

Another useful `enum`, borrowed from the [Elm programming language](https://elm-lang.org/), is [`RemoteData`](https://github.com/mokagio/RemoteData): a way to encapsulate the state of a network operation.

```swift
enum RemoteData<T> {
  case notAsked
  case loading
  case loaded(T)
  case failed(Error)
}
```

`enum`s are not the only way tool to make your domain modeling more precise.
[`NonEmpty`](https://github.com/pointfreeco/swift-nonempty) uses [type constrained generics](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID186) to represent `Collection`s that are not empty.

```swift
// A non-empty array of integers
let xs = NonEmpty<[Int]>(1, 2, 3, 4)
xs.first + 1 // `first` is non-optional since it's guaranteed to be present
```

Using `NonEmpty` adds clarity to the values you define, possibly avoiding runtime crashes by making it impossible to access via subscript an empty array.

If you had to represent "a collection of unique positive integers where order matters and with at least one element," you could use `[Int]`, or you could combine `NonEmpty`, [`OrderedSet`](https://github.com/Weebly/OrderedSet), and [`UInt`](https://developer.apple.com/documentation/swift/uint) in `NonEmpty<OrderedSet<UInt>>`.

Using `[Int]` might be simpler but leaves the door open for all sorts of inconsistent instances, like an empty array, an array with negative values, or one with more than one occurrences of the same value.
`NonEmpty<OrderedSet<UInt>>` requires more work but using it will make the compiler help you avoid inconsistent state.

---

We like to call ourselves software _engineers_, but sometimes forget that engineering is an applied science.
It is rigorous and methodical.
When building a bridge, an integrated circuit, or a motor, precision matters.
If the parts don't fit, if the power supply is not adequate, if there isn't enough material, things won't work.

With software, we're blessed with having a more malleable medium than our colleagues working in the physical realm.
That shouldn't be an excuse to forget the value of precision.

What are your favorite ways to use the type-system to implement a precise domain model?

Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).
