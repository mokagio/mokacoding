---
title: Action focused protocols enhance testability 
description: "Using protocols describing a single capability or action that can be performed is a way to enhance local reasoning and facilitate testability"
data: 2018-09-11
tags:
  - Testing
  - Swift
---

For a long time I used to name protocols created in order to write tests doubles with names like `PizzaServiceType`. I recently discovered a better and _Swiftier_ way to do this. I want to share this with you looking at the advantages and the disadvantages it has.

## The `-Type` suffix issues

Hiding dependencies of the system under test behind protocols is a useful way to allow writing test doubles to affect the behaviour to test.

A protocol allows us to implement the test double as a new type rather than a subclass of the dependency itself. This is great because we don't have to worry about what the dependency does internally. The resulting implementation will be very simple.

For a long time I used to name this kind of protocols with the `-Type` suffix.

```swift
protocol PizzaServiceType {

  func getPizzas(_ completion: (Result<[Pizza], PizzaAPIError>) -> ()) { ... }

  func order(_ pizza: Pizza, completion: (Result<Order, PizzaAPIError>) -> ()) { ... }
}

class PizzaService: PizzaServiceType { ... }

class PizzaServiceDouble: PizzaServiceType { ... }
```

Other options I've seen are `-Protocol` or `-Serviceable`, I'm sure there are more.

No matter the flavour, this naming of protocols always made me uncomfortable.

The [Swift API Guidelines](https://swift.org/documentation/api-design-guidelines/) have these recommendations for naming protocols:

> Protocols that describe _what_ something is should read as nouns (e.g. `Collection`).
>
> Protocols that describe a _capability_ should be named using the suffixes `able`, `ible`, or `ing` (e.g. `Equatable`, `ProgressReporting`).

Using the `-Type` suffix doesn't fit in either of those categories. In particular, names like `PizzaServiceType` don't tell us anything about what the type is or the capabilities it has. They don't focus on behaviour.

## A better way

If protocols should give us information on how a type behaves then we should ask what `PizzaService` is. What is it capable of doing?

It does two things. Getting pizzas and making orders. These two behaviours are what the protocol should be about. Since we have two different behaviours, why not having two protocols too?

```swift
protocol PizzasGetter {

  func getPizzas(_ completion: (Result<[Pizza], PizzaAPIError>) -> ()) { ... }
}

protocol OrderMaker {

  func order(_ pizzas: [Pizza], completion: (Result<Order, PizzaAPIError>) -> ()) { ... }
}

class PizzaService: PizzasGetter, OrderMaker { ... }

class PizzaServiceDouble: PizzasGetter, OrderMaker { ... }
```

## Advantages

This approach feels less awkward. It actually focused on the properties of the type.

There is another benefit, it enhances [local reasoning](https://developer.apple.com/videos/play/wwdc2016/419/?time=41). Local reasoning means that when you look at some code you only need to understand or think about how the rest of the code interacts with it. All you need to know to understand the code in front of you is contained there, in that type or function.

Imagine we have a review screen showing the `Pizza`s the user has selected and allows them to submit an `Order`. The business logic driving this screen only needs to access the `order(_ pizzas:, completion:)` method. It doesn't need to call `getPizzas(_ completion:)`.

```swift
class SubmitOrderBusinessLogic {

  let orderMaker: OrderMaker

  init(orderMaker: OrderMaker) { ... }

  func submitOrder(for pizzas: [Pizza], completion: (Result<Order, PizzaAPIError>) -> ()) {
    orderMaker.order(pizzas, completion: completion)
  }
}
```

Making the component expect `OrderMaker` means even if we `init` it with an instance of `PizzaService` type it will only have access to the `order(_ pizza:, completion:)` method.

When looking at the implementation of `SubmitOrderBusinessLogic` a reader will only have to be aware of what `OrderMaker` does. This is less information than `PizzaServiceType` was exposing.

There is more. Because `PizzaServiceType` allows access to `getPizzas(_ completion:)` it leaves the doors open for accidentally breaking the single responsibility principle. A developer in a rushing to implement a feature might be tempted to reach out of the orders domain and make use of `getPizzas` in `SubmitOrderBusinesLogic`. Restricting the type to `OrderMaker` makes this harder. One would have to add a new `init` parameter.

## Disadvantages

This approach can result in types conforming to a number of protocols.

```swift
class PizzaService: PizzasGetter, OrderMaker, OrderGetter, ... { ... }
```

A way to keep this under check could be to conform to each protocol in a dedicated extension.

```swift
extension PizzaService: PizzasGetter { ... }

extension PizzaService: OrderMaker { ... }

extension PizzaService: OrderGetter { ... }
```

---

I have been using this approach in my projects for weeks and I really like it. Naming is one of the hardest problems in software development, but also one of the greatest leverages we have. Once things are well named we can start talking about them without loss of information.

What do you think of this approach? Have you been doing something similar? Will you give it a shot? Get in touch on Twitter at [@mokagio](https://twitter.com/mokagio) or leave a comment below.

_Leave the codebase better than you found it._
