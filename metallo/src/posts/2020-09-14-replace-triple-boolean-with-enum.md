---
title: Replace Triple-state Boolean with Enumeration
description: Triple-state Booleans can be ambiguous to work with. Replace them with an enum to make the code clearer.
tags:
  - Swift
og_image: https://mokacoding.s3.amazonaws.com/2020-09-14-tri-state-bool-swift.jpg
---

In [episode 258 of The Bike Shed](https://www.bikeshed.fm/258), hosts [Chris Toomey](https://twitter.com/christoomey) and [Steph Viccari](https://twitter.com/SViccari) talked about the problem of the Three-state Boolean in Ruby on Rails applications.

A Three-state Boolean can occur, [for example](https://thoughtbot.com/blog/avoid-the-threestate-boolean-problem), when you define the type of a database table column as a nullable Boolean.
In this scenario, you end up with a Boolean value that can be true, false, _or null_!

In a dynamic language like Ruby, Three-state Boolean can lead to runtime failures when a `nil` value read from the database is not handled.

When using a statically typed language like Swift, we don't have the same risk our Rails colleagues have.
As long as our ORM does its job properly, a nullable Boolean column translates to an `Optional<Bool>` value, and we're always forced to deal with its nullability.

Regardless of how strong the type system is, an `Optional<Bool>`, or `Bool?`, doesn't solve the ambiguity of the null state: what should the code do when the value is neither `true` nor `false`?

Let's make this practical; here's some code to prepare a meal:

```swift
guard let prefersVegetarian: Bool? = user.prefersVegetarian() else {
  return askForVegeratarianPreference()
}

if prefersVegetarian {
  prepareFalafel()
} else {
  prepareSteak()
}
```

Here's a different approach:

```swift
let prefersVegetarian: user.prefersVegetarian() ?? true

if prefersVegetarian() {
  prepareFalafel()
} else {
  prepareSteak()
}
```

In the first case, if the `Bool?` value is `.none`, then the app should ask the user for its preference before preparing the meal.
In the second, when the preference is `.none`, the author decided it's best to assume the user is vegetarian, to avoid presenting them with a meal they wouldn't eat.

Yet another approach could be to default to `false` when there is no preference and prepare a steak, under the assumption that the majority of the users won't be vegetarian.

All approaches are valid;
the code compiles and the user is served a meal.
But, how is a developer supposed to know which is the _correct_ approach?

The code, or rather the API to read the user preferences, is unclear.
Without extra context, there's a two-in-three chance of making a mistake when handling the null state.

We could compensate for this ambiguity by adding documentation to the method, but what's the guarantee consumers are actually going to read it?

There is a simple solution to the Three-state Boolean ambiguity, one which also makes the code clearer without leaving room for error: use an `enum` instead.

```swift
enum Preference {
  case `true`
  case `false`
  case notAsked
}
```

```swift
switch user.prefersVegetarian() {
case .notAsked: askForVegeratarianPreference()
case .true: prepareFalafel()
case .false: prepareSteak()
}
```

If we don't want to make an assumption on the default value when the preference is missing, then defining an `enum` to model the scenario removes the ambiguity.
By using a more specialized type than `Bool?` as the return value for `prefersVegetarian()`, we can make it clearer for the consumers of the code what to do when there is no stored preference.

_By the way, did you know that [`Optional` is an `enum`, too](https://www.mokacoding.com/blog/what-is-an-optional-value-in-swift/)?_

---

When using a statically typed language, we can write code that is highly expressive and helps its users to make the right decisions.
Replacing Triple-state Boolean with enumerations is one technique to make your code clearer.

Clear code is easier to understand and reason about; it's easier to work with.
Remember, you may write a piece of code once, but, between you and your teammates, that code might end up being read hundreds, if not thousands, of times.
Spending a little extra time being thoughtful about the clarity of your code has huge return of investment over time.
