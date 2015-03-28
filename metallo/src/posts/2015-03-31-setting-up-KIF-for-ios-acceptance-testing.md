---
layout: post
title: Setting up KIF for iOS acceptance testing
description: "A guide on install and use the KIF framework for iOS acceptance testing."
tags:
- Acceptance Testing
- KIF
---

Acceptance testing in iOS is a field that is gaining more interest, but with still a lot of work to do, and culture to be defined.

[UIAutomation](https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/UsingtheAutomationInstrument/UsingtheAutomationInstrument.html), the framework provided by Apple, is not easy to use and this discourages many developers. Fortunately the open source community has come up with a number of other tools we can use to make sure our apps behave like intended. We've introduced some of those in last week's post ["The state of iOS testing in 2015"](http://www.mokacoding.com/blog/ios-testing-in-2015), and in this post we're gonna take a look at one of them, [KIF](https://github.com/kif-framework/KIF).

## Keep It Functional

> KIF, which stands for Keep It Functional, is an iOS integration test framework. It allows for easy automation of iOS apps by leveraging the accessibility attributes that the OS makes available for those with visual disabilities.

Probably KIF's strongest point is the fact that it performs tests using a standard Xcode test target, and that tests can be written in Objective-C (or Swift) as normal `XCTest` subclasses.

As you can read in the [README](https://github.com/kif-framework/KIF#kif-ios-integration-testing-framework), a KIF test runs on the main thread, and use a `KIFUITester` instance to simulate the user interaction by accessing the UI through the accessibility elements.

While I personally don't think that having to know another language, be it Javascript for UIAutomation or Ruby for [Calabash](http://calaba.sh/) is a big issue, it's undeniable that having to run the tests outside of Xcode is annoying and doesn't suit well in a process of fast feedbacks, _unless we're talking of the [terminal](http://www.mokacoding.com/blog/running-tests-from-the-terminal/) 😜_) .

One other thing to keep in mind when using KIF is that it works by leveraging **private APIs**, so you need to be careful not to include it in the App Store build.

Another downside is that seems like the maintainers don't have enough time to invest in the project, and some issues and PR can stay open for a long time. But let's remember that this is an open source project and that, as far as I know, it's not backed by any company, so all the work put into KIF's development is for free.

Adding and using KIF in your project is a simple process:

1. Create a new test target for the acceptance tests
2. Create a new scheme to run the acceptance tests
3. Add KIF
4. Write tests 😎

## Enter Bench

To play around with KIF we'll use [Bench](https://github.com/mokacoding/Bench), which is a silly little app made for the occasion, you can [find it on GitHub](https://github.com/mokacoding/Bench) and it has the setup and code that we'll see in a moment.

[Bench](https://github.com/mokacoding/Bench) stands for benchmark, and we'll use it in the next weeks to compare testing frameworks.

## Create a target for KIF

As we said, KIF tests are nothing more than `XCTest` tests, and therefore we need a test target for them.

The reason I'm suggesting to create a dedicated test target is because we want to keep our acceptance tests separated from the unit tests. Running the acceptance tests is time consuming, we don't want them to get in the way of our fast feedback loop while developing business logic guided by unit tests.

To create a new test target in Xcode 6 just go to the project page, select the plus in the bottom, and then Other > Cocoa Touch Test Bundle in the window that will appear.

![How to add a test target in Xcode 6](https://s3.amazonaws.com/mokacoding/2015-03-31-add-target.gif)

## Create the scheme

The second step is creating a scheme to run the acceptance tests only, the reason we want to do this is to keep the unit testing feedback loop quick, avoiding to run the longer acceptance tests suite while in development.

To create a new scheme in Xcode 6 select the schemes navigator, then click "Edit Schemes...", select the application scheme, and the press "Duplicate Scheme".

![How to add a scheme in Xcode 6](https://s3.amazonaws.com/mokacoding/2015-03-31-add-scheme.gif)

You'll probably want to share the scheme as well, in order for it to be tracked in the source control and be available by the other members of the team, and the CI machine. You can do that from the "Edit Scemes..." window.

## Add KIF with CocoaPods

Now that the preparation work is done we can install KIF. [CocoaPods](http://cocoapods.org/) is the tool of choice.

```ruby
target 'BenchKIF', exclusive: true do
  pod 'KIF', '~> 3.2.0'
end
```

Notice the `exclusive: true`, KIF uses private APIs an we don't want it to leak into the production build! Also since it's not needed by the main target there's no reason to add it there.

Now let's run `pod install` and get ready to write our first test.

## The first test

The simplest thing we can test is the state of the UI, let's make sure that the elements in the view are showing the text we're expecting.

```objc
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF.h>

@interface MainScreenTest : XCTestCase

@end

@implementation MainScreenTest

- (void)testUI {
  [tester waitForViewWithAccessibilityLabel:@"Bench"];
  [tester waitForViewWithAccessibilityLabel:@"say hello"];
  [tester waitForViewWithAccessibilityLabel:@"show elements"];
  [tester waitForViewWithAccessibilityLabel:@"mokacoding.com"];
}

@end
```

Some things to note here:

* `tester` is a syntactic sugar provided by KIF to access it's set of APIs to drive the UI and make assertions on it.
* the **wait** part of `waitForViewWithAccessibilityLabel:` method. When dealing with a real application we need to take in consideration the time it takes for the UI to update, for example performing an animated push transition to the next screen. KIF solution is to waiting for the requested elements to be present in the view hierarchy, and it's a good way to make up for the intrinsic delays of an animated UI.

## More useful tests

Let's be honest, the test we just wrote is not very useful. One could actually argue that if that's what we mean with acceptance testing it's actually a waste of time. So let's try to test something that actually makes sense, let's see if the app is behaving as it should.

Bench does two things, shows a greetings alert to the user, and a list of the elements of the periodic table.

```objc
/**
 *  When I tap the "say hello" button, I see a greetings alert, so that I can be happier :)
 */
- (void)testSayHello {
  [tester tapViewWithAccessibilityLabel:@"say hello"];

  [tester waitForViewWithAccessibilityLabel:@"Hello"];
  [tester waitForViewWithAccessibilityLabel:@"Sup?"];
  [tester waitForViewWithAccessibilityLabel:@"Dismiss"];

  [tester tapViewWithAccessibilityLabel:@"Dismiss"];

  [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Hello"];
  [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Sup?"];
  [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Dismiss"];
}

/**
 *  When I tap the "show elements" button, I see a listt of elements, so I can expand my knowledge
 */
- (void)testShowElements {
  [tester tapViewWithAccessibilityLabel:@"show elements"];

  [tester waitForViewWithAccessibilityLabel:@"Elements"];
  [tester waitForViewWithAccessibilityLabel:@"[H] Hydrogen (1)" ];
  [tester waitForViewWithAccessibilityLabel:@"[Uuo] Ununoctium (118)"];
  [tester waitForViewWithAccessibilityLabel:@"Back"];

  [tester tapViewWithAccessibilityLabel:@"Back"];

  [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Elements"];
}
```

Notice how in both tests we're bringing the app back to it's original state, that's an important thing to keep in mind when writing acceptance tests.

## What's next

This post was focused on how to get started with KIF, and the tests written above are very simple cases. If you'll decide to use KIF as your acceptance tests framework of choice there's gonna be other more advanced things you'll need to do, like

* Running the tests in a CI environment.
* Perform more complex interaction with the UI, like typing, swiping, moving sliders and toggles.
* Mock any web server that your app contacts, in order to decouple the tests from the state of the server
* Mock the device location
* Use KIF together with test frameworks like [Specta](https://github.com/specta/specta) or [Quick](https://github.com/Quick/Quick), to get a nicer syntax.

We'll covert those topics in the next posts, so make sure to [subscribe](#subscribe) to the newsletter to stay up to date. You can tweet [@mokacoding](https://twitter.com/mokacoding) with any feedback and request for posts, or use the comment section below.

_Happy coding, and leave the codebase better than you found it._
