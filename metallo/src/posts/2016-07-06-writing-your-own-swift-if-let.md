---
title: 'Writing your own Swift "if let"'
description: "An exercise to understand Swift's optional type: reimplementing the if let functionality"
date: 2016-07-07
tags:
- Swift
- Espresso
---

In the [previous post](https://mokacoding.com/blog/what-is-an-optional-value-in-swift/) we looked under the hood of Swift's optionals, and discovered
that writing `String?` actually means writing `Optional<String>`. `Optional` is
a type in its own right, defined as an enum.

To consolidate our understanding of how optional works let's try to implement
a custom version of Swift's `if let ... else` construct.

```swift
let optionalString: String? = ...
if let string = optionalString {
  print(string)
} else {
  print("Wooops! No string")
}
```

We can imagine `if let ... else` as a function that takes a `String?` as its
input, together with two other functions. One will be `String -> ()`, the
_then_ branch of the conditional which executes if the unwrapping of the input
value is successful; the other `() -> ()`, which executes otherwise.

```swift
func ifLet(_ value: String?, then: String -> (), else elseFunc: () -> ()) {
  // ...
}
```

How do we find out if `value` is null or not, without using `if let`? We could
check for nullability like `if (value == null)`, or we could remember that
`Optional` is an enum type, and use pattern matching, which is way neater:

```swift
func ifLet(_ value: String?, then: String -> (), else elseFunc: () -> ()) {
	switch value {
	case .some(let string): then(string)
	case .none: elseFunc()
	}
}
```

We can use our custom `if let` like this:

```swift
ifLet(optionalString,
	then: { print($0) },
	else: { print("Wooops! No string") }
)
```

Our `ifLet(value: then: else:)` is restricted to `String?` as its input, but
what if we wanted to use it with other types of optionals? `Int?`, `Double?`,
`NSDate?`, etc.

Let's make it generic!

```swift
func ifLet<T>(value: T?, then: T -> (), else elseFunc: () -> ()) {
	switch value {
	case .some(let x): then(x)
	case .none: elseFunc()
	}
}
```

Nice ☺️. Now we can pass any kind of inputs of our `ifLet`. But we're still a
bit constrained, for example we couldn't replicate this behaviour:

```swift
let input: String? = "a string"
let output: Int = {
	if let string = input  {
    return Array(string.characters).count
	} else {
    return -1
	}
}()
```

So let's add a return value in the mix, generic of course:

```swift
func ifLet<T, U>(
	_ value: Optional<T>,
	then thenFunction: (T) -> U,
	else elseFunction: () -> U) -> U {

	switch value {
	case .some(let x): return thenFunction(x)
	case .none: return elseFunction()
	}
}

let o = ifLet(
	input,
	then: { x in
		return Array(x.characters).count
	},
	else: {
		return -1
	}
)
```

That's it. Now we have a full fledged custom `if let ... else`
implementation...  which we obviously never use because the original one is way
easier to work with.

Nevertheless I think that going through this kind of exercises is a good way to
consolidate new concepts, and stretch oneself as a developer.

All the code in this post is available [in this Playground on
GitHub](https://github.com/mokacoding/swift-3-optional-playground).

Feel free leave a comment below or to get in touch with me on Twitter
[@mokagio](https://twitter.com/mokagio) if you found something wrong in the
code, you'd like to suggest more of this kind of exercises, or you just wanna
chat.

_Leave the codebase better than you found it._
