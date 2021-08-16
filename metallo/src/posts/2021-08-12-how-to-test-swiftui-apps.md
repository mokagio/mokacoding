---
title: How to write unit tests for SwiftUI apps
description: "To test SwiftUI applications, don't test SwiftUI code. The SwiftUI framework doesn't lend itself to writing unit tests so don't try to shoehorn views in your test harness. Instead, split layout declaration form content generation logic."
twitter_title: Getting started with TDD in SwiftUI
og_description: "To test SwiftUI applications, don't test SwiftUI code."
tags:
  - swift
  - swiftui
  - testing
  - tdd
---

How do you write unit tests for a SwiftUI application?

SwiftUI, with its declarative approach to UI development and its opaque types, doesn't lend itself to writing unit tests.
Are UI and snapshot tests our only option?
Should we generate multiple Previews for every behavior permutation of our views?

The answer is simpler and doesn't require any extra tool, only good software design:

**To test SwiftUI applications, don't test SwiftUI code.**

Let me show you how to write unit tests for the actual logic behind a SwiftUI app by decoupling layout declaration from content generation.

_Hey! I'm trying something new: I made a video tutorial version of this post, check it out [here](https://www.youtube.com/watch?v=6uhPkYyI7DY&ab_channel=TDD%26Pizza)_ 📺

The template Xcode uses to generate a SwiftUI app for us includes a `View` printing the classic ["Hello, world!" message](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program).


```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

Let's make it a bit more interesting by adding a subject.
The app should say "Hello, `<user>`!" when given a user and fallback to "Hello, world!" otherwise.

## Quick & dirty implementation: All in the view

Given the template code, a natural approach to implement this new behavior would be to write the code inline in the `ContentView` `body` and use different Previews to verify the behavior.

```swift
struct ContentView: View {

    let userName: String?

    var body: some View {
        if let userName = userName {
            Text("Hello, \(userName)!").padding()
        } else {
            Text("Hello, world!").padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userName: "Ada")
        ContentView(userName: .none)
    }
}
```

This approach gets the job done in a trivial scenario such as this hello world example but doesn't scale well because of two issues.

From a practical point of view, both our brain and the screen size limit how effective Previews are to verify behavior.
As you can see in the image below, two different previews make the canvas crowded and the details hard to see.
If we were to add more, they'd end up too small to see, and we'd have to zoom in a scroll through the canvas to check all of them.

![Screenshot of Xcode using two previews](https://s3.amazonaws.com/mokacoding/2021-08-12-two-previews.png)

Moreover, using Previews relies on our eyes and brain to verify the behavior.
Unfortunately, this biological hardware of ours is slow and bug-ridden.
It is a suboptimal tool to verify the code's behavior.

There are also software designs considerations.
In a small dumb view like the `ContentView` from the Xcode template, mixing content generation logic with the layout declaration doesn't affect maintainability that much.
But, as your app grows, mixing layout with content code will make it increasingly difficult to make changes to your views because of the amount of code you'll have to navigate before being able to find what you are looking for.

**SwiftUI views are for declaring layout, not implementing content generation.**

The approach I advocate for is to use automated unit tests to verify the code's behavior.
Automated tests are faster than our eyes and more reliable than our easy to distract brains.
To write a test for the content generation logic, it's necessary to extract it in a way that makes it easier to call.
The need to write tests nudges us towards a design with a better separation of concerns.

## The Test-Driven approach

As I argue in my book [_Test-Driven Development in Swift_](https://tddinswift.com), if you want to add tests to your code, particularly to new code, writing the tests _first_ is the best approach.
Writing tests first puts a helpful pressure on the design, nudging you towards implementations made up of loosely coupled, highly cohesive pieces.

Let's see how to apply TDD to implementing the new hello world behavior.

### Step 1: Test List

The first step is to write a _Test List_, a list of the different behaviors our hello world implementation should have.

```swift
class HelloWorldTests: XCTestCase {

    func testHelloWorldWithNoNameReturnsHelloWorld() {}

    func testHellowWorldWithNameReturnsHelloUser() {}
}

```

Writing a Test List instead of jumping headfirst into coding gives us a 30,000 feet view of the work ahead and lets us be strategic with where to start.

Test-Driven Development aims to maximize learning through fast, continuous feedback.
Each iteration of writing a test, seeing it fail, and finding the code that makes it pass teaches us something about the system we're building.

With all the scenarios to test in front of you, you can choose the one that can teach you something the fastest.

### Step 2: Test the simplest behavior

In [_Test-Driven Development: By Example](https://geni.us/NwUB1Ns), Kent Beck recommends starting with a test you know you can make pass.
By starting from a low-hanging fruit, you can do the work of putting in place the bulk of the coding structure without the overhead of complex behavior implementation.

In our hello world Test List, I feel like the simplest test to implement is for the fallback behavior because it doesn't require any string interpolation to generate the return value.

Let's build an empty version of the hello world, just enough to call in the test without the compiler complaining at us, then use it to write the test.

```swift
func hello(name: String?) -> String { "" }
```

```swift
func testHelloWorldWithNoNameReturnsHelloWorld() {
    XCTAssertEqual(hello(name: .none), "Hello, world!")
}
```

If you run the test now, it will fail:

```
XCTAssertEqual failed: ("") is not equal to ("Hello, world!")
```

We can make the test pass by returning the value the test expects.

```swift
func hello(name: String?) -> String { "Hello, world!" }
```

With the test now passing, we have two options in front of us.
We could refactor the implementation to add a check to return the fallback message only if the input is `nil`, or leave it untouched and move with the next test.

I choose to move on with the next test, confident that it will show us when to add extra logic in the implementation.

### Step 3: Test remaining behavior

```swift
func testHellowWorldWithNameReturnsHelloUser() {
    XCTAssertEqual(hello(name: "Ada"), "Hello, Ada!")
}
```

The new tests, unsurprisingly, fails:

```
XCTAssertEqual failed: ("Hello, world!") is not equal to ("Hello, Ada!")
```

To make it pass, we need to write the conditional logic that inspects the input value.

```swift
func hello(name: String?) -> String {
  if let name = name {
      return "Hello, \(name)!"
  } else {
      return "Hello, world!"
  }
}
```

Both tests pass.
Let's pat ourselves on the back, take a deep breath, and ask, "Is there any improvement we can make to the code?"

### Step 4: Refactor

Unit tests make it easier to change code because they allow you to verify its behavior faster and more thoroughly than running the app manually.

In fact, at the core of the Test-Driven Development workflow, there is a refactoring step.
First, you write a test, then you make it pass with the first solution that comes to mind, and, finally, you can take a step back and improve your code.
The tests make the refactoring step possible because they give you the confidence to change your code as many times as you like, always knowing they will verify its correct behavior.

When looking at my implementation, something that catches my eyes is that there's a bit of duplication in the string structure.
Just for fun, let's apply DRY and remove it:

```swift
func hello(name: String?) -> String {
    let receiver: String
    if let name = name {
        receiver = name
    } else {
        receiver = "world"
    }

    return "Hello, \(receiver)!"
}
```

The tests still pass after this change, which shows us it was correct.

I'm still unhappy with this implementation.
It looks clunky, unnecessarily long.

The fast feedback loop from the tests makes it cheap to keep experimenting with different code versions.

Here's the one I settled for:

```swift
func hello(name: String?) -> String {
    "Hello, \(name.map { $0 } ?? "world")!"
}
```

### Step 5: Inject in the view

To finish our work, we need to make the app UI use the new code.
Integrating `hello(name:)` in the UI merely requires calling it from within `ContentView`'s `body`.

```swift
struct ContentView: View {
    let userName: String?

    var body: some View {
        Text(hello(name: userName))
            .padding()
    }
}
```

Unlike the quick and dirty implementation that didn't rely on tests, we don't need to generate two Previews to verify the conditional hello world behavior because that's already done in the unit tests.
If that seems like a marginal gain, it's only because of how trivial this example is.
Take a moment to picture a real-world application, where you have a combinatorial explosion of possible scenarios to render, and imagine if your only tool to verify them was to manually add and maintain multiple previews.
To me, it's clear how faster and easier to work with delegating the responsibility to verify code's behavior to automated tests is.

## Conclusion

If all code was as straightforward to test as the hello world algorithm, and if all apps were as simple as the updated template app we worked on in this tutorial, we wouldn't need Test-Driven Development — but our jobs would be pretty dull.

In this tutorial, I worked with trivial code to give you an end-to-end overview of the TDD workflow and how it fits in SwiftUI application development.
In the real world, you'll be working with much more complex views, need to implement behavior with more facets, and navigate apps made of a multitude of screens.
It's then that Test-Driven Development becomes a productivity multiplier because it will let you work in isolation and verify every change without spinning up the whole application and go through the motions of its UI.

_If you enjoyed this introduction to TDD with SwiftUI, you'll like my book [_Test-Driven Development in Swift_](https://tddinswift.com) where we build a real-world application using TDD, SwiftUI, and Combine._

_Thanks to [Nikita Ermolenko](https://twitter.com/otbivnoe) for reporting an issue with the first version of this post._ 🎩
