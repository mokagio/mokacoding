---
title: Better tests for delegates
description: "When testing delegates we are asserting rigid implementation details. Here's a way to make those tests more flexible."
tags:
- Swift
- Testing
---

[Delegation](https://en.wikipedia.org/wiki/Delegation_pattern) is a powerful design patter.
The Apple frameworks `Foundation` and `UIKit` use it in many places,
such as [`UITableViewDelegate`](https://developer.apple.com/documentation/uikit/uitableviewdelegate)
or [`URLSessionDelegate`](https://developer.apple.com/documentation/foundation/urlsessiondelegate).

Testing how an object interacts with its delegate is straightforward.
Define a spy test double,
use it to keep track of the methods called, and parameters passed to them,
assert the behavior you are expecting by looking into the state of the spy.

For example,
we can test how a `ResourceFetcher` type calls its delegate upon a successful fetch like this.

```swift
import XCTest
import Nimble

class ResourceFetcherTests: XCTestCase {

  func testCallsDelegateOnSuccess() {
    let resourceFecther = ResourceFetcher()
    let delegateSpy = ResourceFetcherDelegateSpy()
    resourceFecther.delegate = delegateSpy

    resourceFecther.fetch()

    expect(delegateSpy.didCallResourceFetched).toEventually(beTrue())
    expect(delegateSpy.didCallResourceFetchedValue).toEventually(equal(Resource(id: 1)))
  }
}

protocol ResourceFetcherDelegate: class {

  func resourceFetcher(_ resourceFetcher: ResourceFetcher, fetched resource: Resource)
}

class ResourceFetcher {

  weak var delegate: ResourceFetcherDelegate?

  func fetch() {
    // In a real system, you would have something like a network request here.
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) { [weak self] in
      guard let self = self else { return }

      self.delegate?.resourceFetcher(self, didFetch: Resource(id: 1))
    }
  }
}

lass ResourceFetcherDelegateSpy: ResourceFetcherDelegate {

  private(set) var didCallResourceFetched = false
  private(set) var didCallResourceFetchedValue: Resource?

  func resourceFetcher(_ resourceFetcher: ResourceFetcher, didFetch resource: Resource) {
    didCallResourceFetched = true
    didCallResourceFetchedValue = resource
  }
}
```

I talk more about this testing tactic [here](https://www.mokacoding.com/blog/testing-delegates-in-swift-with-xctest/).

## Behaviour vs. Implementation

I want my test suites to help developers as their codebase evolves.
This means we should be able to refactor code without having to update its tests.
In the words of [Corey Haines](http://articles.coreyhaines.com/)
in [this podcast interview](http://www.rubytestingpodcast.com/corey-haines),
"the test suite should serve you; you shouldn't serve it."

Test suites that focus on asserting behavior rather than implementation serve us better in the long run.
Focusing on behavior means that we can change implementation details,
such as method names or the order of their parameters,
and perform refactors like [extract method](https://refactoring.com/catalog/extractFunction.html),
without having to update our tests.

The use of a delegate _is_ an implementation detail.
In the example of `ResourceFetcher`,
the behavior is the act of communicating the fetch has completed successfully,
the fact that a delegate is used is an implementation detail.

On the other hand,
we cannot test `ResourceFetcher` in isolation without taking into account the implementation detail that is its delegate.
Testing components in isolation is usually a valuable thing to do;
it ensures they are flexible,
easy to consume,
and easier to extract.

Let's say we wanted to use the word `didFetch` instead of `fetched` in our `ResourceFetcherDelegate`,
to be consistent with the naming conventions used in the Apple libraries
([`tableView(_:didSelectRowAt:)`](https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614877-tableview),
[`urlSession(_:didReceive:completionHandler:)`](https://developer.apple.com/documentation/foundation/urlsessiondelegate/1409308-urlsession)
etc.)

```diff
- func resourceFetcher(_ resourceFetcher: ResourceFetcher, fetched resource: Resource)
+ func resourceFetcher(_ resourceFetcher: ResourceFetcher, didFetch resource: Resource)
```

To make our test read consistently, we would have to update them:

```diff
  // ResourceFetcherTests.swift
- expect(delegateSpy.didCallResourceFetched).toEventually(beTrue())
- expect(delegateSpy.didCallResourceFetchedValue).toEventually(equal(Resource(id: 1)))
+ expect(delegateSpy.didFetchResourceCalled).toEventually(beTrue())
+ expect(delegateSpy.didFetchResourceValue).toEventually(equal(Resource(id: 1)))

  // ResourceFetcherDelegateSpy.swift
  class ResourceFetcherDelegateSpy: ResourceFetcherDelegate {

-   private(set) var didCallResourceFetched = false
-   private(set) var didCallResourceFetchedValue: Resource?
+   private(set) var didFetchResourceCalled = false
+   private(set) var didFetchResourceValue: Resource?

    func resourceFetcher(_ resourceFetcher: ResourceFetcher, didFetch resource: Resource) {
-     didCallResourceFetched = true
-     didCallResourceFetchedValue = resource
+     didFetchResourceCalled = true
+     didFetchResourceValue = resource
    }
```

I know,
it's a small thing.
However, **small things matter, and they do add up**.
Plus,
let me repeat it one more time,
I'm not interested in what the delegate method is called,
but in the behavior it captures.

If a new reader of the codebase,
which includes our future selves,
sees a test suite made up of tests and assertions biased towards behavior
they'll be more likely to adopt the same style.

If we agree on the value of testing how objects call their delegates,
and on the value of focusing on behavior rather than implementation,
is there a way for us to write these tests without being coupled to implementation details?

## A behavior-oriented delegate test

A way to mitigate the intrinsic dependency on implementation
when testing delegation
is to shift the API we use in the tests
from focusing on the method and property names
towards the kind of behavior the delegate is notified about.

In the `ResourceFetcher` example above
we could use something like this:

```swift
// ResourceFetcherTests.swift
func test_delegate_success_call() {
  let resourceFecther = ResourceFetcher()
  let delegateSpy = ResourceFetcherDelegateSpy()
  resourceFecther.delegate = delegateSpy

  resourceFecther.fetch()

  expect(delegateSpy.wasCalledForSuccessfulFetch(of: Resource(id: 1)))
      .toEventually(beTrue())
}

// ResourceFetcherDelegateSpy.swift
class ResourceFetcherDelegateSpy: ResourceFetcherDelegate {

  private var fetchedResource: Resource?

  func wasCalledForSuccessfulFetch(of resource: Resource) -> Bool {
    return fetchedResource == resource
  }

  func resourceFetcher(_ resourceFetcher: ResourceFetcher, didFetch resource: Resource) {
      fetchedResource = resource
  }
}
```

When reading the test,
we don't focus on the implementation details of the method name
and its parameters,
but instead on what they achieve.
Those details, by the way, are one click away;
we just need to drill into the implementation of the `wasCalledForSuccessfulFetch(of:)` method in the Spy.

Notice as well how the diff for a change in the delegate method name looks like this time:

```diff
  class ResourceFetcherDelegateSpy: ResourceFetcherDelegate {

    private var fetchedResource: Resource?

    func wasCalledForSuccessfulFetch(of resource: Resource) -> Bool {
      return fetchedResource == resource
    }

-   func resourceFetcher(_ resourceFetcher: ResourceFetcher, didFetch resource: Resource) {
+   func resourceFetcher(_ resourceFetcher: ResourceFetcher, fetched resource: Resource) {
        fetchedResource = resource
    }
  }
```

Because of the abstraction layer
between how the delegate works
and how we check if it's consumed properly,
we had to update only the Spy implementation details,
without having to touch the test using it.

Yes, this is a small achievement.
But once again,
small achievements all add up to make a huge difference in the long run.

---

I believe tests that focus on behavior
rather than implementation
are the most useful
and sustainable kind of tests.

Depending on the business logic we are implementing
it's not always possible to hide implementation details from the tests.
In those occasions
we can still try to mitigate them as much as possible.
Hiding the implementation details of how a delegate is called
behind a method named after the behavior being notified to the delegate
is one such mitigation tactic.

What do you think of this approach?
Have you used something similar?
How do you minimize the number of implementation details you assert in your tests?
