---
layout: post
title: How to test UI changes in Xcode 7
description: "One of the characteristic of the UI is that it changes, and there are scenarios in which writing UI tests to assure that the change has happened correctly can be very valuable for the reliability of our apps. Writing such a test is a bit harder than normal, let's see how to do it."
tags:
  - Acceptance Testing
  - UI Testing
  - iOS
date: 2015-07-25
---

With Xcode 7 Apple introduced a [new framework for UI testing](https://mokacoding.com/blog/xcode-7-ui-testing/). As with every new thing there is always room for improvement, and with Xcode 7 Beta 4, UI testing got a very useful improvement: the ability to wait asynchronously for view changes.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Xcode 7 beta 4 adds async waiting for UI changes in UI testing with: &#10;&#10;-[XCTestCase expectationForPredicate:evaluatedWithObject:handler:]</p>&mdash; Joar Wingfors (@joar_at_work) <a href="https://twitter.com/joar_at_work/status/623716723787587585">July 22, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

[Joar](https://twitter.com/joar_at_work)'s tweet is enlightening but doesn't show any code, so let's see how to do that. You can checkout the [example project](https://github.com/mokacoding/UI-Test-View-Change) as well if you want.

```swift
func expectationForPredicate(predicate: NSPredicate, evaluatedWithObject object: AnyObject, handler: XCPredicateExpectationHandler?) -> XCTestExpectation
```

The header for this method reads: creates an expectation that is fulfilled if the predicate returns true when evaluated with the given object. The expectation periodically evaluates the predicate and also may use notifications or other events to optimistically re-evaluate. If the handler is not provided the first successful evaluation will fulfill the expectation. If provided, the handler can override that behavior which leaves the caller responsible for fulfilling the expectation.

So what we need to do to assert the changes in our views is write a test predicate and pass it to `expectationForPredicate`, together with the object the predicate has to be evaluated with, and an optional handler.

More in details here's what Joar suggests:

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/mokagio">@mokagio</a> That looks alright. Usually something makes the element change state, and that something should go after creating the expectation.</p>&mdash; Joar Wingfors (@joar_at_work) <a href="https://twitter.com/joar_at_work/status/624587295878852608">July 24, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Let's take a [sample app](https://github.com/mokacoding/UI-Test-View-Change) in which we have a button that once touched triggers an delayed update in a label. This is somehow similar to an "Updated at..." label that updates its text once the app receives the response to an update request to the server. A possible UI test for it would be:

```swift
func testOtherButtonChangesFooter() {
  let app = XCUIApplication()

  // Define the expectation on the final UI state
  //
  let expectedText = "Oh! Did something happen?!"
  let labelIdentifier = "footer label"
  let testPredicate = NSPredicate(format: "label = '\(expectedText)'")
  let object = app.staticTexts.elementMatchingType(.Any, identifier: labelIdentifier)

  self.expectationForPredicate(testPredicate, evaluatedWithObject: object, handler: nil)

  // Act on the UI to change the state
  //
  app.buttons["Press me and I'll do something, eventually"].tap()

  // Wait and see...
  //
  self.waitForExpectationsWithTimeout(10, handler: nil)
}
```

That's it. I wouldn't go so far as saying _as simple as that_, because there is a bit of setup to do in order to run the assertion.

If you would like to see more examples of this kind of test, or would like to share your implementations please leave a comment below, or tweet me [@mokacoding](https://twitter.com/mokacoding).

_Leave the codebase better than you found it._
