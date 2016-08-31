---
title: Swift Either enum
description: "This post introduces the Either type and shows a practical application of it in Swift, injecting extra cells in a table view."
tags:
- Swift
- Haskell
---

Swift `enum` is very powerful and versatile. It's a type in its own right, with
support for methods and initializers, and the associate values feature allows
us to use it in some nifty way.

One example of the power of `enum` is the `Optional` type, which we've seen in
detail in
[previous](http://www.mokacoding.com/blog/what-is-an-optional-value-in-swift/)
[posts](http://www.mokacoding.com/blog/writing-your-own-swift-if-let/).

`Optional` is defined as an `enum` with two cases. The case `None` represents
the absence of value, while `Some` the presence of value. `Some` _wraps_ the
value which presence is representing in its associated value.

A less known but equally powerful type which we can implement as an enum is `Either`.

## Either

The `Either` type represents duality, a value that can either be of a type or
another.

This is how we can write `Either`:

```swift
enum Either<A, B>{
  case Left(A)
  case Right(B)
}
```

`Either` allows us to write elegant, self explanatory, and type safe code by
switching on it:

```swift
let x: Either<SomeType, AnotherType> = ...

switch x {
case .Left(let someTypeValue):
  // do something with someTypeValue
case .Right(let anotherTypeValue):
  // do something with anotherTypeValue
}
```

Defined like that `Either` might not seem very practical, but here's a great
usage for either: injecting extra cells in a table or collection view.

## Injecting cells in a table view using Either

![screenshot of app using Either to inject ad banner cells in table view](https://s3.amazonaws.com/mokacoding/2016-07-18-either-table-view.png)

Sometimes we need to display lists in table or collection views with extra
cells dedicated to call to action, or advertisement banners, which we'll let the
user remove through in-app purchase (a dev still needs to pay the bills right?).

We could do this by displaying a banner instead of the actual item for a given
index path, and shifting the index used to fetch the next item we want to
display from the array of data based on the number of banner cells that we've
already displayed.

Or we could use `Either`.

Rather than an array of cell models we could feed the data source an array of `Either<CellModel, BannerModel>`.

```swift
let data: [Either<CellModel, BannerModel>] = ...

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return data.count
}
```

In the `tableView(_:cellForRowAt:)` method we could then get the item for the
current index path and simply switch and behave accordingly to its type.

```swift
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	let item = data[indexPath.row]

	let identifier: String = {
		switch item {
		case .Left: return pizzaCellIdentifier
		case .Right: return adCellIdentifier
		}
	}()

	let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

	switch item {
	case .Left(let pizza):
		configure(cell, with: pizza)
	case .Right(let ad):
		configure(cell, with: ad)
	}

	return cell
}
```

This approach seems more solid to me. It doesn't rely on any math, making the
code easier to digest, and I find the `switch-case` construct a very elegant
and self explanatory way to describe behaviour.

You can see the whole project from which the example code is taken [on
GitHub](https://github.com/mokacoding/either-tableview).

---

I came in touch with Either by reading [Maybe
Haskell](https://gumroad.com/l/maybe-haskell/?utm_medium=blog&utm_source=mokacoding)
by [Pat Brisbin](https://twitter.com/patbrisbin). If I hadn't stepped outside
of my comfort zone and decided to learn something quite different from the
tools I use for my "day job" I might have never learnt about this type and I'd
still be shifting array indexes.

I'm saying this to encourage you to experiment an play around with different
technologies, and see if some of the ideas you'll encounter can be brought back
in your daily development.

_Leave the codebase better than you found it._
