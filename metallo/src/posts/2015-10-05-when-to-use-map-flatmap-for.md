---
layout: post
title: When to use map, flatMap, or for loops in Swift
description: "Swift allows us to natively iterate over arrays using map. Map could be used to replace every for loop in your code, but that's not a great idea. Map and for have different purposes and should be used appropriately"
tags:
  - Swift
---

I am a [big fan of `map` and `flatMap`](https://www.mokacoding.com/blog/functor-applicative-monads-in-pictures/), and of the cleaner code that [they allow to write](https://www.mokacoding.com/blog/demistifying-swift-functor/).

When I realised how easy it was to use `map` in Swift I fell victim of one of the most common engineer disease: the shiny new thing syndrome.

> When you have a new hammer, everything looks like a needle, including screws.

![Thor smashing his hammer](https://media.giphy.com/media/1Nclw5CJ3N77G/giphy.gif)

I started to `map` everything, and got disappointed at the coffee shop when I couldn't `flatMap` my espresso with milk to get a flat white.

Why even bother having a `for` loop construct in the language when you can use `map`?!

Once I recovered from my diseased, making arguable coding choices along the way, I realised that `map` and `for` deserve the same respect, and serve different purposes. So here's the rule of thumb on when to use `map` and when to use `for`.

## Use map when you need to transform arrays

```swift
let arrayOfNumbers = [1, 2, 3, 4]
let arrayOfString = arrayOfNumbers.map { "\($0)" }
```

In the context of `Array` `map` get an array, applies a transformation function to every element, and returns a new array with the resulting elements. That's the best use case for map.

The cool thing about `map` is how you can chain multiple transformation together and have code that clearly express what it does.

```swift
let awesomeImages = averageImage
  .map(cropIntoSquare)
  .map(bumpContrast)
  .map(applySecretFilter)
```

## Use for loops when there are "side effects"

Without going [into details](https://en.wikipedia.org/wiki/Side_effect_(computer_science) an operation has a [side effect](http://programmers.stackexchange.com/questions/40297/what-is-a-side-effect) if it results in some kind of state changing somewhere, for example changing the value of a variable, writing to disk, or updating the UI. In such case using a for loop is more appropriate.

```swift
for number in arrayOfNumbers {
  print(number)
}
```

## And what about flatMap?

Everything said above stand true for `flatMap` as well.

When you need to transform the contents of an array of arrays, into a linear array use `flatMap`:

```swift
let users: [User] = ...
let allEmails = users.flatMap { $0.emails }
```

When the code needs to perform some action that has side effects use `for`, and here's a nice trick to avoid nesting:

```swift
for element in nestedArray.flatten() {
  updateUI(withElement: element)
}
```

## Performances?

I run some quick tests and I couldn't see any relevant performance difference between `map` and a `for` loop in Swift. The Swift compiler is probably smart enough to use the best performing loop operation regardless of the code we wrote.

---

To recap, here's my rule of thumb: **if there's a side effect you probably want to use `for`, otherwise `map` seems a better fit**

What is your experience with `map` vs `for` loops? Do you agree with me or have a different opinion, if so why? Get in touch on Twitter [@mokagio](http://twitter.com/mokagio) or leave a comment below.

## Update: forEach

[Richard Fox](https://twitter.com/RGfox) on Twitter and on the comments below points out that Swift provides a `forEach` method too. The `for` loop above could be rewritten as:

```swift
arrayOfNumbers.forEach { print($0) }
```

I left out `forEach` because in my humble opinion the loop version reads better. _For element in array do stuff_ seems better to me than _array for each do stuff_. Nevertheless `forEach` is as valid Swift as a `for` loop. You could rewrite all what we've said already using `forEach` instead of the loop and everything would still stand.

It is up to you and your team to decide which convention to use, and choose the appropriate construct depending on what you are trying to achieve.

_Happy coding, and leave the codebase better than you found it._
