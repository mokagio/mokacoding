---
title: How to test view controllers navigation
description: 'The answer to "How can I test that a view controller presents another view controller when something happens?" is as simple as defining a delegate.'
tags:
- Swift
- Testing
- iOS
- Software-Design
---

Here's a question that often comes up when testing iOS application: "How can I test that _a view controller_ presents _another view controller_ when _something_ happens?"

Testing navigation between view controllers can be tricky.
You need to wrap your view controller under test in a `UINavigationController` if you want to test a push navigation or add it to a `UIWindow` if for a modal presentation.
There are usually animations involved, which in turn require either your test assertions to be asynchronous or your code to allow the `animated` flag to be injected as `false` from the tests.

Those and other little gotchas make the tests harder to write and reason about, but it doesn't have to be so.

You can use a simple and cheap pattern to easily test how your view controllers trigger navigation, making your code easier to work with in the process.

## `NavigationDelegate`

The key to make navigations between view controllers easy to test lies in appreciating that **view controllers be responsible for presenting other view controllers**.

View controllers should only trigger the navigation and then _delegate_ the act of performing it to another object.
I like to call this kind of delegates `NavigationDelegate`s[<sup id="pattern-origin">*</sup>](#fn1).

With a `NavigationDelegate` in place, testing how a view controller does navigations is now a matter of testing how it interacts with its delegate.
This can be done by using a [spy](https://www.mokacoding.com/blog/swift-test-doubles/#spy).

### `NavigationDelegate` in action

To test that a view controller triggers the expected navigation you can verify that it calls the appropriate method of its `NavigationDelegate`.

```swift
func testCallsShowRedWhenRedButtonTouched() {
    let viewController = loadViewController()
    let navigationDelegateSpy = ViewControllerNavigationDelegateSpy()
    viewController.navigationDelegate = navigationDelegateSpy

    viewController.redButton.sendActions(for: .touchUpInside)

    XCTAssertTrue(navigationDelegateSpy.showRedCalled)
}
```

```swift
protocol ViewControllerNavigationDelegate: class {
    func showRedViewController()
}

class ViewController: UIViewController {

    @IBOutlet weak var redButton: UIButton!

    weak var navigationDelegate: ViewControllerNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        redButton.addTarget(self, action: #selector(redButtonTouched), for: .primaryActionTriggered)
    }

    @objc func redButtonTouched() {
        navigationDelegate?.showRedViewController()
    }
}
```

```swift
class ViewControllerNavigationDelegateSpy: ViewControllerNavigationDelegate {

    private(set) var showRedCalled = false

    func showRedViewController() {
        showRedCalled = true
    }
}
```

_All the this code is available in [this GitHub repo](https://github.com/mokagio/Navigation-Delegate-Example)_.

The tests above look simple, don't they?
By using this pattern, you remove the need to set up the whole navigation stack containing the view controller under test to verify it's behavior.
You also don't need to put the view controller inside a `UIWindow` or `UINavigationController`, simplifying the test setup and tear down.

The only downside is that you have to build a spy test double for the `NavigationDelegate`.
Given how little code this involves, I think it's a pretty good tradeoff.

If you want to test how the type conforming to the `NavigationDelegate` performs the navigation -a wise thing to do- you can do that in isolation.

```swift
func testPushesRedViewController() {
    let navigator = Navigator(navigationController: UINavigationController(rootViewController: UIViewController()))

    navigator.showRedViewController()

    _ = expectation(
        for: NSPredicate { input, _ in
            return (input as? UINavigationController)?.topViewController is RedViewController
        },
        evaluatedWith: navigator.navigationController,
        handler: .none
    )
    waitForEnavigatorpectations(timeout: 1, handler: .none)
}
```

## You can adopt `NavigationDelegate`s today

What I love about this idea is that it is cheap and portable.
You don't have to change your application architecture to adopt it.
In fact, it fits well with most architectures.

You can start using `NavigationDelegate`s today.

To get started and make your code testable you can even have the view controller be its own navigation delegate.
This is definitely not something I would endorse in the long run, but it might help you get started.
Once the delegate is in the codebase, you can come back to it later and extract the implementation in a dedicated object.

## Benefits

Making the navigation side of your view controllers easier to test this way comes with other benefits too.

Because your view controllers are now unaware of how to present new view controllers, they won't need to change when updating the way navigation works (see [this PR](https://github.com/mokagio/Navigation-Delegate-Example/pull/1) in the example project).

Remember the definition of the [single responsibility principle](https://en.wikipedia.org/wiki/Single_responsibility_principle)? An object should only have one reason to change.
View controllers are the glue code of iOS applications; they end up doing a lot of things.
With a `NavigationDelegate` they have one less thing to do. 😉

Single responsibility is also why I prefer to use a dedicated delegate for navigation only, even if the view controller already has a delegate.
Yes, you end up with more definitions and objects, but I'd rather work in a codebase with a lot of small and easy to reason about pieces, than one with a handful of classes doing all the work.

---

If you know the right approach, testing how a `UIViewController` triggers a navigation is as simple as verifying any other side effect code.

The `NavigationDelegate` pattern follows the _dīvide et imperā_ rule; divide and conquer.
Split the implementation of the navigation in two pieces, the code that starts it and the code that performs it.
Testing both in isolation is easier than testing them together.

Using `NavigationDelegate`s will not only make a critical area of your app such as how screens are linked together easier to test, but it will also make it easier to reuse view controllers in different areas of the application.
A case in point for how making things easy to test also makes them easy to use.

The pattern also scales nicely.
You can imagine a view controller triggering the presentation of a different screen based on some internal state.
For example, a button could present a screen to up-sell the user to a subscription if they don't have one or push to the feature screen if they have it.
These two different flows are triggered by two different methods in a `NavigationDelegate`.
In the tests, you can set the state in the view controller, synthesize the user action that should trigger the presentation, and verify with a spy that the correct navigation method is called.

What do you think of this approach? I'd love to hear your thoughts if you use it, and the spin that you'll put on it.
Get in touch on Twitter at [@mokagio](https://twitter.com/mokagio) or leave a comment below.

### Footnotes

<span id="fn1"></span> [*](#pattern-origin). The idea of delegating the responsibility of performing navigations from a view controller is not original.
This concept is what makes patterns like [Coordinators](http://khanlou.com/2015/10/coordinators-redux/), [Navigators](https://www.swiftbysundell.com/posts/navigation-in-swift), and [Routers](https://clean-swift.com/routing-in-clean-swift/) possible.
The first time I saw this formalized was in Alberto De Bortoli's 2014 post "[Flow Controllers on iOS for a better navigation control](https://albertodebortoli.com/2014/09/03/flow-controllers-on-ios-for-a-better-navigation-control/)".
Although he injects the object responsible for the navigation in the view controller, the result is pretty much the same.
