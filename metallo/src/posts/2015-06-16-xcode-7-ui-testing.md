---
layout: post
title: Xcode 7 UI testing, a first look
description: "How to get started with UI testing in Xcode 7, recording tests and using the new APIs to assert the state of the application under test."
tags:
- Acceptance Testing
- UI Testing
- Xcode
---

_**Note:** the code below uses Xcode 7 Beta 1, and Swift 2.0. I'll do my best to keep it up to date with the new release, but if I miss something please leave a comment below._

WWDC '15 might not have been as full of surprises as the previous one, but it certainly brought us good news. In [The state of iOS testing in 2015](https://www.mokacoding.com/blog/ios-testing-in-2015/) I wrote:

> While in the past two year unit testing for iOS and OS X has become better and better, the acceptance testing side of things hasn't made any improvements.

Well, the situation regarding acceptance testing has changed with Xcode 7, and for the better!

This new IDE release introduces a "UI Testing Bundle" that we can use to write and run our acceptance tests.

But there is more. The infamous [UIAutomation](https://developer.apple.com/library/ios/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/UsingtheAutomationInstrument/UsingtheAutomationInstrument.html) has been dropped, _although it is still available from Instruments, and we now have a new set of APIs to do UI testing.

These APIs have nice Swift interfaces and plug-in into XCTest, so we can run our acceptance tests with a simple ⌘U.

The new tests that we're going to write are based on the same principles as the _old_ ones we wrote with [KIF](https://github.com/kif-framework/KIF), [Calabash](http://calaba.sh/), [Appium](http://appium.io/) and so on... They will interact with the app like the user would, and do that leveraging on iOS' [Accessibility](https://developer.apple.com/accessibility/), which has been improved in iOS 9.

## First look at Xcode 7 UI testing

Before we get started, at the cost of being called captain obvious, I'd like to remind you that to use these features you need Xcode 7 and a project targeting iOS 9.

In this post we will re-write the existing acceptance tests we have in [Bench](https://github.com/mokacoding/Bench/tree/xcode-7) using the UI testing framework. If you want to know more about the process of writing those test checkout [these](https://www.mokacoding.com/blog/setting-up-kif-for-ios-acceptance-testing/) [two](https://www.mokacoding.com/blog/job-stories-acceptance-tests-with-kif-and-specta/) posts.

The first thing we need to do is add a new test target. You'll be pleased to see that Xcode 7 finally has a dedicated section for the test targets 🎉

![Adding a UI test target - Screenshot](https://s3.amazonaws.com/mokacoding/2015-06-16-xcode-7-add-test-target.png)

The target can be in Objective-C or Swift. Since this is a completely new API I feel like this could be the perfect way to try out Swift if you haven't yet, so we'll choose that.

The boilerplate code that has been generated for us doesn't do anything, but it suggest to "_use recording to get started writing UI tests_".

"Recording" is an interesting option provided by Xcode 7 that will write most of the testing code for us. Simply move the cursor inside any `test...()` method, hit the record button in the bottom corner, and interact with the app, you'll see code magically appear.

![Record UI test code animate GIF](https://s3.amazonaws.com/mokacoding/2015-06-16-xcode-7-record-test.gif)

The first acceptance criteria we outlined for Bench is "_When I tap the 'say hello' button, I see a gretings alert_".

The code that gets generated for that interaction is:

```swift
testSayHello() {
  let app = XCUIApplication()
  app.buttons["say hello"].tap()
  app.alerts["Hello"].collectionViews.buttons["Dismiss"].tap()
}
```

As you can see the syntax is pretty straightforward. If we now run the test we'll have an output like this in the Console:

```
Test Case '-[BenchUITests.BenchUITests testSayHello]' started.
2015-06-15 19:36:13.494 XCTRunner[3123:9611325] Continuing to run tests in the background with task ID 1
  t =     1.60s     Wait for app to idle
  t =     1.81s     Tap the "say hello" Button
  t =     1.81s         Wait for app to idle
  t =     1.81s         Find the "say hello" Button
  t =     1.84s         Dispatch the event
  t =     2.08s         Wait for app to idle
  t =     2.10s     Tap the "Dismiss" Button
  t =     2.10s         Wait for app to idle
  t =     2.56s         Find the "Dismiss" Button
  t =     2.57s         Dispatch the event
  t =     2.81s         Wait for app to idle
Test Case '-[BenchUITests.BenchUITests testSayHello]' passed (3.215 seconds).
```

The output reports the action taken on the UI and their time delta since the start of the test case. This could become really useful while inspecting failures in apps in which time matters, like an egg counter for example.

You can access this from the test reporter as well, and if you click on the inspector icon you'll see a screenshot of the state of the app when the test failed.

![Test reporter screenshot](https://s3.amazonaws.com/mokacoding/2015-06-16-xcode-7-test-report.png)

You might also have noticed that this test _isn't testing anything_ apart from the fact that some elements are in the screen.

## Asserting the app state

Bench's second acceptance criteria, in the form of a [job story](https://medium.com/the-job-to-be-done/replacing-the-user-story-with-the-job-story-af7cdee10c27), is "_When I tap the 'show elements' button, I see a list of elements_".

The recorded code for this test is:

```swift
func testShowElements() {
  let app = XCUIApplication()
  app.buttons["show elements"].tap()
  app.tables.staticTexts["[N] Nitrogen (7)"].swipeUp()
  app.tables.staticTexts["[Ir] Iridium (77)"].swipeUp()
  app.tables.staticTexts["[Tl] Thallium (81)"].swipeUp()
  app.tables.staticTexts["[Uut] Ununtrium (113)"].swipeUp()
}
```

This again is not very useful, and quite coupled with the formatting of the cell content.

We can edit this test by simply making it verify that the screen presented when tapping "show elements" has one and only one table, and that the table has exactly 118 elements. Unless some major breakthrough in physics the number of elements in the period table will remain 118 for a while, which makes this test more deterministic than just relying on something as unstable as your designer or copywriter mood.

Let's write the test again step by step. The start of the test will be the same, simply press the "show elements" button to load the next screen.

```swift
let app = XCUIApplication()
```

`XCUIApplication` is a proxy to the running app, and is what we can use to query and interact with it.

```swift
app.buttons["show elements"].tap()
```

`.buttons["show elements"]` is a `XCUIElementQuery` provided by the `XCUIApplication` instance. We can combine it with subscripting to look for a button named "show elements", it will fail unless one and only one button matching that name is found. If a single button is found the query will return a `XCUIElement` proxy to that button. We can then tap the button through it's proxy with the `tap()` method.

`XCUIApplication`, `XCUIElementQuery`, and `XCUIElement` are the three APIs that make UI testing possible. You can find out more about them looking at their headers through Xcode.

What we want to do next is making sure that the screen is showing one and only one table.

```swift
XCTAssertEqual(app.tables.count, 1)
```

We can combine the new UI testing APIs with the usual `XCTAssert...` ones. 

Having made sure that we have only one table, we can reliably move on and assert that the number of cells in the table matches the expected number of elements.

```swift
let table = app.tables.elementAtIndex(0)
XCTAssertEqual(table.cells.count, 118)
```

And that's it for our first UI tests with Xcode 7.

This test function all together look like:

```swift
func testShowElements() {
  let app = XCUIApplication()
  app.buttons["show elements"].tap()

  XCTAssertEqual(app.tables.count, 1)

  let table = app.tables.elementAtIndex(0)
  let expectedNumberOfElements: UInt = 118
  XCTAssertEqual(table.cells.count, expectedNumberOfElements)
}
```

I'm am personally very pleased by the framework so far, and I'm looking forward to use it to test _real_ apps. I think the message Apple is sending is very clear, they care about testing all across the spectrum, and so should we as developers!

## What's next

First of all it would be nice to try out this new framework with more complex scenarios, the acceptance criteria that we set for Bench so far are very simple, and served us only to see how to _setup_ a testing framework, not how to _harness its power_.

Tests that we could find in real world application will have to include some form of decoupling form the network, taking animations into account, handling the app state between launches, and a deeper use of assertions.

Other interesting things to explore would be how UI testing behaves when launched from the command line, and in CI environments.

For this and much more keep an eye on this blog, as we will try to cover those topics in the next weeks. _Tip: you can subscribe to the [newsletter](#subscribe) or to the [RSS feed](https://www.mokacoding.com/feed.xml).

_Happy coding, and leave the codebase better than you found it._
