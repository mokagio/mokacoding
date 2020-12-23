---
title: How to set default values in Swift compiler-generated initializers
description: "You can get the Swift compiler to generate an initializer with default values for your structs, if you're willing to put up with a bit of mutability."
tags:
- Swift
- Espresso
---

For the longest time, I used to roll out my own `init` when I wanted to set default values for a `let` property of a `struct`.
Today, I discovered a way to retain the compiler-generated init and have it set the default value, too.

One of the many cool Swift compiler features that save development time is the compiler-generate initializer for `struct`s.
Unless you explicitly define an `init` method, the compiler will generate one for you based on the properties of your `struct`.

Consider this `Pizza` `struct`:

```swift
struct Pizza {

  let name: String
  let ingredients: [Ingredient]
}
```

The compiler will generate an `init` method for it with the parameters in the same order as the properties definition.

```
let pizza = Pizza(name: "Margherita", ingredients: [.tomatoSauce, .mozzarella])
```

Now, imagine we want to add extras to our `Pizza`.
By default, a pizza should not have extras, but consumers can decide to add some – I like my Margherita extra cheesy, so I always ask for double mozzarella.

One way to do that is to define an `init` with the default value:

```swift
struct Pizza {

  let name: String
  let ingredients: [Ingredient]
  let extra: [Ingredient]

  init(name: String, ingredients: [Ingredient], extras: [Ingredient] = []) {
    self.name = name
    self.ingredients = ingredients
    self.extras = extras
  }
}
```

Unfortunately, by providing our own `init`, we take responsibility of updating it every time the shape of the `struct` changes.

A different way to have a default value while also leveraging the compiler-generated `init` is to set it as part of the property definition.

```swift
struct Pizza {

  let name: String
  let ingredients: [Ingredient]
  private(set) var extras: [Ingredient] = []
}
```

It never occurred to me to do this because I try to keep my code as immutable as I can; using a `var` leaves the door open for mutations.

On the other hand, the `private(set)` access control mitigates the mutable state risk: only the code internal to the `struct` can change the value of `extras`.

That seems like a good tradeoff.
I can keep the default value, the compiler-generate `init`, and make the `struct` immutable for consumers.
I only need to be mindful not to change the property in the `struct` implementation.

What do you think of this little trick / feature?
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).
