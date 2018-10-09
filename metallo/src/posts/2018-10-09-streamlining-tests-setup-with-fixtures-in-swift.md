---
title: Streamlining tests setup with fixtures in Swift
description: "Keeping tests short and focused is important for the health of the test suite. A fixture method to generate instances with default values in the tests helps keeping the setup code short, focused, and readable"
og_image: https://s3.amazonaws.com/mokacoding/2018-10-09-swift-fixtures-naming-convention.png
tags:
  - Testing
  - Swift
---

When writing unit tests you often need to provide input values to the component inspected.

For example when testing a function like `combine(_ base: Base, with toppings: [Toppings]) -> Pizza` you might want to provide an instance of `Base` that is gluten free and an array of toppings like `[TomatoSauce(), Mozzarella(), Salami()]`.

Those input values are not [test doubles](https://martinfowler.com/bliki/TestDouble.html) but actual instances of your system's types.

To keep the tests focused and easy to write it's good to abstract their creation to another place. This will make your tests shorter and easier to read, their content focused on acting and asserting the system under test, with little distraction in the setup stage.

For example, compare these two tests:

```swift
func testWithLongSetup() {
  let base = Base(flour: .00, thin: true)
  let toppings = [TomatoSauce(), Mozzarella(), Salami(extraSpicy: false)]
  let pizza = Pizza(base: base, toppings: toppings)

  let deliveryAddress = Address(
    street: "1 Infinite Loop",
    town: "Cupertino",
    state: "CA",
    postCode: "95014",
    country: "USA"
  )

  let order = Order(pizzas: [pizza], deliveryAddress: deliveryAddress)

  XCTAssertEqual(order.itemsCount, 1)
}
```

```swift
func testWithShortSetup() {
  let order = Order(
    pizzas: [salamiPizza()],
    deliveryAddress: mothershipAddress()
  )

  XCTAssertEqual(order.itemsCount, 1)
}
```

The second example is shorter and arguably easier to read. Having removed the long setup makes it focused only on the testing of the behaviour.

This kind of input values for tests are called **fixtures**. The [JUnit 4](https://junit.org/junit4/) documentation defines test fixtures as:

> a fixed state of a set of objects used as a baseline for running tests. The purpose of a test fixture is to ensure that there is a well known and fixed environment in which tests are run so that results are repeatable.

A popular library in the Ruby on Rails testing community is [factory_bot](https://github.com/thoughtbot/factory_bot). It allows the creation of fixtures with a syntax like:

```ruby
user = create(:user)
pizza = create(:pizza, :toppings: [:pepperoni, :mozzarella])
```

Using `factory_bot` simplifies the test code setup, while retaining the ability to set values relevant for the behaviour under test. The library is easy to use thanks to Ruby being a dynamic language and the great work of the authors, maintainers, and contributors.

Swift is a stricter language than Ruby. I don't know of a way to pass a literal to a function and have it return an instance of a type matching that literal, pre-filled with default values like `factory_bot` does without having to write extra code.

My poor man's approach to get a similar behaviour is to use an extension in the test target, and do some manual labor.

```swift
extension Pizza {

  static func fixture(
    name: String = "name",
    toppings: [Topping] = [TomatoSauce(), Mozzarella()]
  ) -> Pizza {
    return Pizza(name: name, toppings: toppings)
  }
}
```

A note on using `"name"` as the default value for the `name:` parameter. When setting default values in the tests it's tempting to get creative and smart. In the past I was proud of how many references to Marvel comics I could spread in my test suites.

In his excellent course [Refactoring Rails](https://www.refactoringrails.io/), [Ben Orenstein](https://twitter.com/r00k) recommends using boring values for all those inputs that don't matter for the outcome of the test. Ben points out that having interesting input values, code that draws the eyes, makes the reader think the inputs are important for the outcome of the test. But if that's not the case then these smart tests are subtly lying to us.

Now let's see how to use these fixtures. If the behaviour you are testing doesn't care about how the inputs are built you can call `fixture()` with no argument, this will create an instance with all default values.

```swift
let order = Order(pizzas: [Pizza.fixture()], drinks: [Beverage.fixture()])

XCTAssertEqual(order.items, 2)
```

If the behaviour you are testing depends on some properties of its inputs you can set those and only those in the call to `fixture()`.

```swift
let pizza = Pizza.fixture(toppings: [TomatoSauce(), Mozzarella()]).isVegetarian
XCTAssertTrue(pizza.isVegetarian)

let otherPizza = Pizza.fixture(toppings: [TomatoSauce(), Mozzarella(), Salami()]).isVegetarian
XCTAssertFalse(pizza.isVegetarian)
```

When working with fixtures I found it's best to violate the [YAGNI principle](https://martinfowler.com/bliki/Yagni.html). It's worth spending the time to build a complete fixture as soon as you need it, rather than adding functionality to it when it's required. You should build a fixture extension with all the type's `init` parameters in its argument list, rather than only the ones needed by your test right now.

```swift
// Incomplete fixture
extension Topping {

  static func fixture(
    name: String = "name",
    isVegetarian: Bool = false
  ) -> Topping {
    return Topping(
      name: name,
      sku: "12AB",
      isVegetarian: isVegetarian,
      isVegan: false,
      isGlutenFree: false
    )
  }
}

// Complete fixture
extension Topping {

  static func fixture(
    name: String = "name",
    sku: String = "a-sku",
    isVegetarian: Bool = false,
    isVegan: Bool = false,
    isGlutenFree: Bool = false
  ) -> Topping {
    return Topping(
      name: name,
      sku: sku,
      isVegetarian: isVegetarian,
      isVegan: isVegan,
      isGlutenFree: isGlutenFree
    )
  }
}
```

The extra work you put in creating the fixture will pay off in later PRs, when you or your team mates won't have to go off track to add the support for the input value they need to test against. It'll be already there.

### Why not a `convenience init`?

The reason I'm suggesting to use a `static func` rather than a `convenience init` with all the default values is because calling `.fixture()` tells the reader the code is getting a test value more explicitly.

On top of that, it's not always possible to define a convenience initializer for a type keeping the argument labels the same as the type's properties. So for consistency I prefer to always use the `.fixture()` approach, which can always be implemented.

### Where to put the fixtures?

You can either put all the fixture extensions in a `Fixtures.swift` file in the test target, or used a dedicated `Type+Fixture.swift` file for each. I prefer the latter.

![Screenshot of the Xcode navigator showing Swift fixture files with the +Fixture suffix](https://s3.amazonaws.com/mokacoding/2018-10-09-swift-fixtures-naming-convention.png)

### Live Demo

You can play around with the code in the post checkout [this example project](https://github.com/mokacoding/Swift-Fixtures-Example/). Also notice in [this PR](https://github.com/mokacoding/Swift-Fixtures-Example/pull/1/files) the difference in the code surface using fixtures makes.

## Conclusion

If you want to be serious about testing you should put as much effort in your test code as in your production one. The test suite needs to be tidy, its code reading in a way that surfaces what the tests are about, without distracting the reader with irrelevant setup details.

The use of fixtures to initialize test inputs with the ability to set only the relevant parameters, leaving the others as default, is a technique that will help you maintain focus and order in your test code.

What do you think about this approach? Have you been using something similar? I'd love to hear from you. Leave a comment below or get in touch on Twitter [@mokagio](https://twitter.com/mokagio).
