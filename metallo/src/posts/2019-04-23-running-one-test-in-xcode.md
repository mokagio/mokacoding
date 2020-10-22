---
title: How to run a single test in Xcode
description: A collection of ways to run a single test or a subset of tests using Xcode.
tags:
- Xcode
- Testing
- Productivity
og_image: "https://s3.amazonaws.com/mokacoding/tets-succeeded.png"
---

When building software, you should try to optimize the speed of your feedback loop.
The faster you can learn if your code works and how, the better you'll be at delivering value to your users.

When it comes to testing and TDD, a fast feedback loop means a test suite that runs in no more than a few seconds.
If I stare at a progress bar for more than a few seconds, my mind will start getting distracted.
At that point, I'll have to expend a lot of mental energy not to set off to do something else and disrupt my concentration.

Having a test suite that runs in a few seconds is hard though, especially as our codebases grow.
A technique to speed up the feedback loop when working in a codebase with a long-running test suite is to **only run a subset of the tests**.

By running only the tests relevant to the code you're changing, you can significantly speed-up the suite execution time, increasing the speed of our feedback loop.

Xcode offers a few different ways to run a subset of the tests.
Let's take a look.

## From the gutter

You can run a single test class or a single test method by clicking the corresponding test diamond in the gutter.

<video autoplay="true" muted="true" loop="true" poster="https://s3.amazonaws.com/mokacoding/2019-04-23-single-test-from-gutter.png">
<source src="https://s3.amazonaws.com/mokacoding/2019-04-23-single-test-from-gutter.mp4" type="video/mp4">
<source src="https://s3.amazonaws.com/mokacoding/2019-04-23-single-test-from-gutter.gif" type="gif">
</video>

## With a keyboard shortcut

Hit `^ ⌥ ⌘ U` to run the tests for the cursor's _context_.

If you are inside a test method, like in the example below, the context will be that method.
If your cursor is in a test class, but outside a method, the context will be that test calls; all its tests will run.

<video autoplay="true" muted="true" loop="true" poster="https://s3.amazonaws.com/mokacoding/2019-04-23-single-test-from-keyboard.png">
<source src="https://s3.amazonaws.com/mokacoding/2019-04-23-single-test-from-keyboard.mp4" type="video/mp4">
<source src="https://s3.amazonaws.com/mokacoding/2019-04-23-single-test-from-keyboard.gif" type="gif">
</video>

I [love keyboard shortcuts](https://xcodetips.com), and this is [my favorite testing shortcut](https://mokacoding.com/blog/xcode-testing-shortcuts/). I use it many many times every day.

## From the scheme

Another way to run a subset of tests is to select them in the scheme configuration.

![Image showing a scheme configuration with a subset of tests selected](https://s3.amazonaws.com/mokacoding/2019-04-23-scheme.png)

I can only think of a handful of cases when you might want to use this approach.
For example, you might have a long-running integration suite that would slow down your continuous integration pipeline.
You could create a new scheme with only the core tests in the suite and run only those on CI for every repository check-in while keeping the long-running suite as something you run every night.

I'm wary of this approach.
These configurations are buried in the scheme settings; it's far too easy to forget about them.
You might disable some tests and accidentally check-in the change to the scheme, and suddenly find yourself missing an important part of your unit tests suite.

## From the terminal

If you are running your tests from the terminal, you can use the `-only-testing` `xcodebuild` flag to run a subset of tests.

```
xcodebuild test \
  -scheme YourScheme \
  -project YourProject.xcodeproj \
  -destination 'platform=iOS Simulator,name=iPhone Xs' \
  -only-testing YourTests/YourClassTests/testSomething
```

You can add as many `-only-testing` as you want.

The option supports different granularities of identifiers: `TestTarget[/TestClass[/TestMethod]]`.
This means that in the example above you can run all the tests in `YourClassTests` by using `-only-testing YourTests/YourClassTests`.

Worth noting that you can also run all the tests other than a subset, using the `-skip-testing` option instead.

## Bonus: Focused tests in Quick

If you are using the testing framework [Quick](https://github.com/Quick/Quick) to enjoy a more descriptive way of defining your tests you might notice that Xcode doesn't add the diamonds in the gutter.

You can still run a subset of tests by [_focusing_](https://github.com/Quick/Quick/blob/0b4ed6c706dd0cce923b5019a605a9bcc6b1b600/Documentation/en-us/QuickExamplesAndGroups.md#temporarily-running-a-subset-of-focused-examples) them.
This can be done by adding an `f` in front of on an example or group: `fit`, `fcontext`, `fdescribe`.

```swift
fit("is loud") {
  // ...only this focused example will be run.
}

it("has a high frequency") {
  // ...this example is not focused, and will not be run.
}
```

## A word of caution

Running one test or a subset of tests will make your feedback loop faster, but will also reduce the confidence in your change not breaking any part of the codebase.

My recommendation is to run the subset of tests for the code you are working on only during the intermediate steps of development.
Once you're done implementing the change, fix, or feature, run the whole test suite.
Develop the habit of always running the tests before committing, and never make a commit if the tests are not passing.

---

What do you think of these methods to run a single test in Xcode? Do you know any other?

I'd love to hear from you, get in touch on Twitter [@mokagio](https://twitter.com/mokagio) or leave a comment below.
