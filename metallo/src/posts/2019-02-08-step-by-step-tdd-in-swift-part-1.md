---
title: "How to TDD in Swift, a step by step guide"
description: With test driven development you can write high quality software in small shippable steps. Here's how to get started.
tags:
- TDD
- Swift
og_image: https://s3.amazonaws.com/mokacoding/2019-02-08-test-succeded.jpg
---

There is a way of writing software that minimizes the chances of bugs and unexpected behaviours creeping in. Developing this way also results in small easy to change components.

This way of writing software is Test Driven Development. This post show how to practice TDD, and how it makes for a pleasurable and effective coding experience.

---

Giuseppe, the owner of you favourite pizza place, has hired you to build the iOS app for his business. Like the wise developer that you are you encourage Giuseppe to start small and iterate quickly. The two of you agree to start with a digital menu for his customers, to gauge its reception.

A way to move quickly in developing an app, while making sure it behaves as expected, is to detach its business logic from the details of the how inputs and outputs are sent to the users. [Uncle Bob](https://blog.cleancoder.com/) illustrates the idea in [this talk](https://www.youtube.com/watch?v=HhNIttd87xs) and in his book [Clean Architecture](https://geni.us/dM1KXD8).

We should consider iOS the _delivery layer_ for our applications, keeping as little business logic implementation living at that level as possible. Imagine you were building a CLI app instead, then pretend iOS is a GUI wrapper around it. Ideally none of the business logic should ever `import UIKit`.

The question you should always ask yourself when TDDing is "**what's the smallest and simplest thing I can do?**". What's the smallest thing we can build to start developing this app? Giuseppe's menu has three sections: pizzas, beverages, and desserts. Let's start with a menu app showing only the pizzas.

This version of the app with only pizzas is our [walking skeleton](http://wiki.c2.com/?WalkingSkeleton), an app with only the bare minimum of functionality to make sure all the components are glued together and working end to end.

Since the core of our business logic is the conversion of Giuseppe's menu to a format that can be displayed let's start with a component for it, let's call it `MenuDataSource`.

**When doing TDD we always start from the tests**, so let's create one for `MenuDataSource`. In this post we'll use Apple's [`XCTest` famework](https://developer.apple.com/documentation/xctest), but that's not the only option to write tests in Swift.

```swift
@testable import Giuseppes
import XCTest

class MenuDataSourceTests: XCTestCase {
}
```

Our test should describe and verify the **behaviour** we want for `MenuDataSource`. We decided that our walking skeleton will have only pizzas, so let's make sure `MenuDataSource` provides only one section for the menu.

To test this behaviour we'll first need an instance of `MenuDataSource`.

```swift
@testable import Giuseppes
import XCTest

class MenuDataSourceTests: XCTestCase {

    func testHasOneSection() {
        let dataSource = MenuDataSource()
        // 🔴 Use of unresolved identifier 'MenuDataSource';
        // did you mean 'MenuDataSourceTests'?
    }
}
```

The code is not compiling, as we haven't defined `MenuDataSource` yet. In TDD compilation failures count as test failures, and our job is to **write the simplest code that we can to make the test pass**, which in this case means compile.

To make the test compile we have to define `MenuDataSource`.

```swift
struct MenuDataSource { }
```

Notice that there are no properties or `init` parameters in this `MenuDataSource`. This is what means to write the simplest code possible, just enough code to make the test pass. We'll add properties to the type only as we'll need them to make the tests we'll write pass.

Now that the test is compiling let's move to asserting the behaviour of `MenuDataSource` when asked for sections.

```swift
func testHasOneSection() {
    let dataSource = MenuDataSource()
    XCTAssertEqual(dataSource.numberOfSections, 1)
    // 🔴 Value of type 'MenuDataSource' has no member 'numberOfSections'
}
```

Once again we have a failing test due to a compilation error. What's the simplest code we can write to make it pass?

```swift
struct MenuDataSource {

    let numberOfSections = 1
}
```

Notice once again that there is no logic here, just an hardcoded value. This is enough to make our test compile and also pass, and we're happy with it.

```swift
@testable import Giuseppes
import XCTest

class MenuDataSourceTests: XCTestCase {

    func testHasOneSection() {
        let dataSource = MenuDataSource()
        XCTAssertEqual(dataSource.numberOfSections, 1)  // ✅
    }
}
```

A word of warning. **You should never trust a test you haven't seen fail**. We've seen the test fail due to a compilation error, but what about testing the actual behaviour? It wouldn't hurt to change the hardcoded 1 in `MenuDataSource` to another value, and verify that the test fails.

We finally have a passing test, let's commit: `Implement MenuDataSource returning number of sections`.

What's next? Let's add a way to get the number of rows in a section.

```swift
func testRowsInSection() {
	let dataSource = MenuDataSource()
	XCTAssertEqual(dataSource.numberOfRows(inSection: 0), ???)
}
```

Hang on, how many rows should there be in a section? If our section is showing the pizzas then it should have as many rows as the pizzas to display. How can we test this behaviour? We need a way to control this input parameter, for example we can pass the array of pizzas to display to `MenuDataSource` at `init` time.

**The act of writing tests for the behaviours we want reveals the design details of our software**. We didn't decide upfront that `MenuDataSource` should be initialized with an `Array<Pizza>`, we let the need for it [emerge](https://en.wikipedia.org/wiki/Emergent_Design) from the tests.

Before solving that problem let's bring the test to a successful state. Let's just say number of rows should always be 3.

```swift
func testRowsInSection() {
    let dataSource = MenuDataSource()
    XCTAssertEqual(dataSource.numberOfRows(inSection: 0), 3)
    // 🔴 Value of type 'MenuDataSource' has no member 'numberOfRows';
    // did you mean numberOfSections'?
}
```

Once again the simplest way to make the test pass it to hardcode the result to be 3.

```swift
func numberOfRows(inSection section: Int) -> Int {
    return 3
}
```

```swift
func testRowsInSection() {
	let dataSource = MenuDataSource()
	XCTAssertEqual(dataSource.numberOfRows(inSection: 0), 3)  // ✅
}
```

Let's commit this intermediate step. `Implement dummy number of rows in section`.

Now that we have a green test let's move to initializing `MenuDataSource` with an array of pizzas. What's the least amount of code we can write to achieve it? We always start from the tests:

```swift
func testHasOneSection() {
    let dataSource = MenuDataSource(pizzas: [Pizza()])
    // 🔴 Use of unresolved identifier 'Pizza'
    XCTAssertEqual(dataSource.numberOfSections, 1)
}

func testRowsInSection() {
    let dataSource = MenuDataSource(pizzas: [Pizza(), Pizza(), Pizza()])
    // 🔴 Use of unresolved identifier 'Pizza'
    XCTAssertEqual(dataSource.numberOfRows(inSection: 0), 3)
}
```

The compiler is now hinting the next step to us, define `Pizza`.

```swift
struct Pizza { }
```

It's tempting to add properties to `Pizza`, like its name, price, and ingredients, but we don't need that code to make the test pass. The problem we're trying to solve is not writing a comprehensive `Pizza`, but making sure we can pass `Pizza`s to display to `MenuDataSource`. **TDD is all about solving one very little problem after the other.**

If we try to run the tests again we'll get a new error:

```swift
func testHasOneSection() {
    let dataSource = MenuDataSource(pizzas: [Pizza()])
    // 🔴 Argument passed to call that takes no arguments
    XCTAssertEqual(dataSource.numberOfSections, 1)
}

func testRowsInSection() {
    let dataSource = MenuDataSource(pizzas: [Pizza(), Pizza(), Pizza()])
    // 🔴 Argument passed to call that takes no arguments
    XCTAssertEqual(dataSource.numberOfRows(inSection: 0), 3)
}
```

Let's pass an array of our new `Pizza`s as an argument to the `init` method of `MenuDataSource`.

```swift
struct MenuDataSource {

    let pizzas: [Pizza]
}
```

```swift
func testHasOneSection() {
    let dataSource = MenuDataSource(pizzas: [Pizza()])
    XCTAssertEqual(dataSource.numberOfSections, 1)  // ✅
}

func testRowsInSection() {
	let dataSource = MenuDataSource(pizzas: [Pizza(), Pizza(), Pizza()])
	XCTAssertEqual(dataSource.numberOfRows(inSection: 0), 3)  // ✅
}
```
Now the tests are passing again, so let's commit, even if we haven't implemented the logic to read the number of `Pizza`s yet. `Pass [Pizza] to MenuDataSource init`.

**Committing often makes TDD easier**. We move a little bit at a time, and if we end up with something that doesn't work we only have little code to review. You could even discard those unstaged changes and start from scratch.  Don't worry about the Git history becoming long, commits are cheap to store. If you want to have a more compact history before your changes are merged you can always [do an interactive rebase](https://thoughtbot.com/blog/git-interactive-rebase-squash-amend-rewriting-history) and tidy it up.

Moving on, let's write the simplest code we can to read make `MenuDataSource` return a number of rows based on the given `[Pizza]`.

```swift
// MenuDataSource.swift
func numberOfRows(inSection section: Int) -> Int {
    return pizzas.count
}
```

Tests are still green, so our change is a valid implementation of the behaviour. Let's commit this little change: `Return number of menu rows based on input [Pizza]`.

What's our next step? Before moving on to implement the next behaviour let's look at how we're testing `numberOfRows(inSection:)`. Have we considered all its possible behaviours? To answer this question we can look at its input parameter, should the method return the same output for every input? What should it do if the `section` index provided doesn't match any of the sections -currently just one- in the menu? Given this method is called "number of rows" a reasonable thing to do would be to return 0. Let's write a test for this scenario.

```swift
func testRowsInOutOfBoundsSectionIsZero() {
    let dataSource = MenuDataSource(pizzas: [Pizza(), Pizza(), Pizza()])
    XCTAssertEqual(dataSource.numberOfRows(inSection: 1), 0)
    // ❌ XCTAssertEqual failed: ("3") is not equal to ("0")
    XCTAssertEqual(dataSource.numberOfRows(inSection: -1), 0)
    // ❌ XCTAssertEqual failed: ("3") is not equal to ("0")
}
```

The tests are failing, you're not surprised by that are you? The current version of `numberOfRows(inSection:)` always returns the count of the pizzas. Let's write as little code as we can to make the tests pass.

```swift
func numberOfRows(inSection section: Int) -> Int {
    guard section == 0 else { return 0 }
    return pizzas.count
}
```

```swift
func testRowsInOutOfBoundsSectionIsZero() {
    let dataSource = MenuDataSource(pizzas: [Pizza(), Pizza(), Pizza()])
    XCTAssertEqual(dataSource.numberOfRows(inSection: 1), 0)  // ✅
    XCTAssertEqual(dataSource.numberOfRows(inSection: -1), 0) // ✅
}
```
We made a change and the tests are passing, it's time to commit: `Handle out of bounds sections in numberOfRows(inSection:)`.

Next step, make `MenuDataSource` return what to display for a given a section and row. It's useful to make the return value a distinct type, let's call it `MenuItem`. The reason this is better than returning a `Pizza` is that it introduces a separation between the domain of the data, pizzas, and the domain of the UI, menu items. This separation allows us to change either of the domains without affecting the other, only the code that converts between the two.

But how can we verify that the `MenuItem` returned by the method is the one we're expecting? Or rather, what's the simplest thing we can do to verify that the `MenuItem` returned by the method is the expected one? Using pizza name seems like a good candidate for this, if a pizza is named "Margherita" the `MenuItem` should have `title` "Margherita" as well.

```swift
func testItemForRowAndSection() {
    let dataSource = MenuDataSource(pizzas: [Pizza(), Pizza(), Pizza()])
    XCTAssertEqual(dataSource.item(forRow: 0, inSection: 0).title, "Margherita") 
    // 🔴 Value of type 'MenuDataSource' has no member 'item'
}
```

The simplest code we can write to make this test pass is having a `MenuItem` with `title` that's always "Margherita".

```swift
// in MenuItemDataSource.swift
func item(forRow row: Int, inSection section: Int) -> MenuItem {
   return MenuItem()
}

// in MenuItem.swift
struct MenuItem {

    let title = "Margherita"
}
```

```swift
func testItemForRowAndSection() {
    let dataSource = MenuDataSource(pizzas: [Pizza(), Pizza()])
    XCTAssertEqual(dataSource.item(forRow: 0, inSection: 0).title, "Margherita")  // ✅
}
```

We have a green test, it's admittedly incomplete, but still enough for us to have a solid foundation to build upon. Let's commit it: `Implement dummy item(forRow:, inSection:) in MenuDataSource`.

Our test is not yet testing the "if a pizza is named 'Margherita'" behaviour. To refine our test we need a way to give it `Pizza`s with different names. It's time to grow the definition of `Pizza` with a `name` property.

Before making the change to the `Pizza` `init` and its consumers let's make the change easy to make. In Kent Beck's words "make the change easy, warning this might be hard, then make the easy change".

A way to make the change easier is to reduce number of places in the code where we init `Pizza` directly. We can do that using a [fixture extension](https://mokacoding.com/blog/streamlining-tests-setup-with-fixtures-in-swift/).

```swift
@testable import Giuseppes

extension Pizza {

    static func fixture() -> Pizza {
        return Pizza()
    }
}
```

The extension is not doing anything now, but it will make changing the `init` of `Pizza` easier because we'll only have to update the fixture, not all the tests.

```swift
func testHasOneSection() {
    let dataSource = MenuDataSource(pizzas: [.fixture()])
    XCTAssertEqual(dataSource.numberOfSections, 1) // ✅
}

func testRowsInSection() {
    let dataSource = MenuDataSource(pizzas: [.fixture(), .fixture(), .fixture()])
    XCTAssertEqual(dataSource.numberOfRows(inSection: 0), 3) // ✅
}

func testRowsInOutOfBoundsSectionIsZero() {
    let dataSource = MenuDataSource(pizzas: [.fixture(), .fixture(), .fixture()])
    XCTAssertEqual(dataSource.numberOfRows(inSection: 1), 0) // ✅
    XCTAssertEqual(dataSource.numberOfRows(inSection: -1), 0) // ✅
}

func testItemForRowAndSection() {
    let dataSource = MenuDataSource(pizzas: [.fixture(), .fixture()])
    XCTAssertEqual(dataSource.item(forRow: 0, inSection: 0).title, "Margherita") // ✅
}
```

Time to commit, `Use fixture extension for Pizza`.

Now that we've made the change easy, now let's make the easy change. As always, we start from the tests.

```swift
func testItemForRowAndSection() {
    let dataSource = MenuDataSource(
        pizzas: [.fixture(name: "Margherita"), .fixture(name: "Capricciosa")]
        // 🔴 Argument passed to call that takes no arguments
    )
    XCTAssertEqual(dataSource.item(forRow: 0, inSection: 0).title, "Margherita")
}
```

The tests are not compiling because `Pizza` and its fixture don't have a `name`. Here you can see how having a fixture makes changing tests easier. By defaulting the `name` parameter we make it so that all the tests calling `.fixture()` don't need to be updated, unless we want to test behaviour depending directly on the value by passing a custom one.

```swift
// Pizza.swift
struct Pizza {

    let name: String
}

// Pizza+Fixture.swift
extension Pizza {

    static func fixture(name: String = "Margherita") -> Pizza {
        return Pizza(name: name)
    }
}
```

```swift
func testHasOneSection() {
    let dataSource = MenuDataSource(pizzas: [.fixture()])
    XCTAssertEqual(dataSource.numberOfSections, 1) // ✅
}

func testRowsInSection() {
    let dataSource = MenuDataSource(pizzas: [.fixture(), .fixture(), .fixture()])
    XCTAssertEqual(dataSource.numberOfRows(inSection: 0), 3) // ✅
}

func testRowsInOutOfBoundsSectionIsZero() {
    let dataSource = MenuDataSource(pizzas: [.fixture(), .fixture(), .fixture()])
    XCTAssertEqual(dataSource.numberOfRows(inSection: 1), 0) // ✅
    XCTAssertEqual(dataSource.numberOfRows(inSection: -1), 0) // ✅
}

func testItemForRowAndSection() {
    let dataSource = MenuDataSource(
        pizzas: [.fixture(name: "Margherita"), .fixture(name: "Capricciosa")]
    )
    XCTAssertEqual(dataSource.item(forRow: 0, inSection: 0).title, "Margherita") // ✅
}
```

You know what's next right? Commit: `Add name property to Pizza`.

This time, rather than replacing the dummy implementation straightaway let's add another test to prove the code we have right now is incorrect. This technique is called triangulation (even if we're using only two assertions).

```swift
func testItemForRowAndSection() {
    let dataSource = MenuDataSource(
        pizzas: [.fixture(name: "Margherita"), .fixture(name: "Capricciosa")]
    )
    XCTAssertEqual(dataSource.item(forRow: 0, inSection: 0).title, "Margherita") // ✅
    XCTAssertEqual(dataSource.item(forRow: 1, inSection: 0).title, "Capricciosa")
    // ❌ XCTAssertEqual failed: ("Margherita") is not equal to ("Capricciosa")
}
```

Let's write a proper implementation:

```swift
// MenuDataSource.swift
func item(forRow row: Int, inSection section: Int) -> MenuItem {
   return MenuItem(pizza: pizzas[row])
}

// MenuItem.swift
struct MenuItem {

    let title: String
}

extension MenuItem {

    init(pizza: Pizza) {
        self.init(title: pizza.name)
    }
}
```

```swift
func testItemForRowAndSection() {
    let dataSource = MenuDataSource(
        pizzas: [.fixture(name: "Margherita"), .fixture(name: "Capricciosa")]
    )
    XCTAssertEqual(dataSource.item(forRow: 0, inSection: 0).title, "Margherita") // ✅
    XCTAssertEqual(dataSource.item(forRow: 1, inSection: 0).title, "Capricciosa") // ✅
}
```

Commit `Provide actual implementation for item(forRow:, inSection:)`

Like we did for `numbe of rows`, we should ask ourselves whether we've covered the behaviour for all the possible kinds of input. What would happen if we gave a section index that doesn't match? What about a row? Given this method is called "item for row in section" if the row and section pair doesn't match the backing data then returning "nothing" seems appropriate. Swift's beautiful `Optional` type is the best tool to describe this scenario.

```swift
func testItemForOutOfBoundsRowAndSectionIsNil() {
    let dataSource = MenuDataSource(
        pizzas: [.fixture(name: "Margherita"), .fixture(name: "Capricciosa")]
    )
    XCTAssertNil(dataSource.item(forRow: 2, inSection: 0))
    XCTAssertNil(dataSource.item(forRow: 0, inSection: 1))
    XCTAssertNil(dataSource.item(forRow: 2, inSection: 1))
    XCTAssertNil(dataSource.item(forRow: -1, inSection: -1))
}
```

![screenshot of tests crashing](https://s3.amazonaws.com/mokacoding/2019-02-07-tdd-28.png)

Running the tests now results in a crash, after all we are accessing an out of bounds array. What's the simplest way we can fix it?

```swift
func item(forRow row: Int, inSection section: Int) -> MenuItem? {
    guard row >= 0, pizzas.count > row else { return .none }
    return MenuItem(pizza: pizzas[row])
}
```

```swift
func testItemForRowAndSection() {
    let dataSource = MenuDataSource(
        pizzas: [.fixture(name: "Margherita"), .fixture(name: "Capricciosa")]
    )
    XCTAssertEqual(dataSource.item(forRow: 0, inSection: 0).title, "Margherita")
    // 🔴 Value of optional type 'MenuItem?' must be unwrapped to refer to member 'title'
    // of wrapped base type 'MenuItem'
    XCTAssertEqual(dataSource.item(forRow: 1, inSection: 0).title, "Capricciosa")
    // 🔴 Value of optional type 'MenuItem?' must be unwrapped to refer to member 'title'
    // of wrapped base type 'MenuItem'
}
```

Notice that this change in the type signature of `item(forRow:, inSection:)` from `-> MenuItem` to `-> MenuItem?` broke the tests. We need to update the other calls to the methods to take into account the new optionality.

```swift
func testItemForRowAndSection() {
    let dataSource = MenuDataSource(
        pizzas: [.fixture(name: "Margherita"), .fixture(name: "Capricciosa")]
    )
    XCTAssertEqual(dataSource.item(forRow: 0, inSection: 0)?.title, "Margherita") // ✅
    XCTAssertEqual(dataSource.item(forRow: 1, inSection: 0)?.title, "Capricciosa") // ✅
}

func testItemForOutOfBoundsRowAndSectionIsNil() {
    let dataSource = MenuDataSource(
        pizzas: [.fixture(name: "Margherita"), .fixture(name: "Capricciosa")]
    )
    XCTAssertNil(dataSource.item(forRow: 2, inSection: 0)) // ✅
    XCTAssertNil(dataSource.item(forRow: 0, inSection: 1))
    // ❌ XCTAssertNil failed: "MenuItem(title: "Margherita")"
    XCTAssertNil(dataSource.item(forRow: 2, inSection: 1)) // ✅
    XCTAssertNil(dataSource.item(forRow: -1, inSection: -1)) // ✅
}
```

No crash, but still the test for out of bounds section is failing. That's because in the code above we only checked for the row. Let's make the check comprehensive.

```swift
func item(forRow row: Int, inSection section: Int) -> MenuItem? {
    guard section == 0 else { return .none }
    guard row >= 0, pizzas.count > row else { return .none }

    return MenuItem(pizza: pizzas[row])
}
```

```swift
func testItemForOutOfBoundsRowAndSectionIsNil() {
    let dataSource = MenuDataSource(
        pizzas: [.fixture(name: "Margherita"), .fixture(name: "Capricciosa")]
    )
    XCTAssertNil(dataSource.item(forRow: 2, inSection: 0)) // ✅
    XCTAssertNil(dataSource.item(forRow: 0, inSection: 1)) // ✅
    XCTAssertNil(dataSource.item(forRow: 2, inSection: 1)) // ✅
    XCTAssertNil(dataSource.item(forRow: -1, inSection: -1)) // ✅
}
```

All the tests are now passing, happy days. Commit: `Address out of range behaviour of item(forRow:, inSection:)`.

We now have a functioning data source for our menu of pizzas. 🎉. The next step would be to feed it into a view controller to show that information to a user. We can of course drive that implementation with tests too, but that's out of the scope of this post.

Here's how `MenuDataSource` can be used to back a `UITableView`.

```swift
extension MenuViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return menuDataSource.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDataSource.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let item = menuDataSource.item(forRow: indexPath.row, inSection: indexPath.section) else {
            return cell
        }

        cell.textLabel?.text = item.title

        return cell
    }
}
```

## "It's too slow"

A common observation I get from developers and managers is that TDDing takes longer. **"It would have taken me way less time to write this without tests."** Sure, it would have. But building a software product is not just a matter of writing code, we also need to make sure the code behaves as expect, and be able to change the code easily.

On top of that, when you have only one screen to work with this might seem like overkill, but most apps don't have only one screen or one feature do they? For example if we were to add a detail screen for each item in the menu to verify how that screen behaves we would have to always navigate to it. If most of the behaviour is covered by tests we can verify it simply by running the tests, and launch and navigate through the app only when necessary to verify UI details, saving a lot of time.

When driving your implementation with tests you go a bit slower in the writing phase to go faster in all the other steps of the development process. It's also important to note that as you get more hours of TDD under your belt you'll get faster at it. The maturity of a test driven codebase helps writing tests faster too, as you'll have a lot of infrastructure already in place.

## Recap

We've seen how to write software driven by tests. The process is simple:

- Write a test for the code you wish you had, it'll fail because the code is not there yet.
- Use the failing test as feedback to implement just enough code to make the test pass.
- Once you have a passing test make the underlying code better.

In other words: red, green, commit, refactor, commit.

This simplicity is what makes it powerful. Writing just enough test code to get a failure, then just enough code to make it pass means you're always solving small problems. This constant and fast feedback loop is a [flow](https://geni.us/StUP) inducing process. Like athletes and stand up comedians know well, the faster your feedback loop the faster you'll improve.

**TDD is more than a way to write code, is a business philosophy**. It's a way to build a product in small incremental steps while continuously getting feedback, from the micro level of a single function, to the macro of an iteration on the next version.
