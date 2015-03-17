---
layout: post
title: Specta global before and after each hooks
description: An interesting and powerful, yet not at all documented feature of Spetca are global beforeEach and afterEach hooks. In this post we'll see how to configure them, and how to blacklist classes from running them.
tags:
- Testing
- Specta
---

[Specta](https://github.com/specta/specta) is one of the best xSpec style testing library for Objective-C.

One of the reason I like it is the modular approach it takes, you can plug in Specta your favourite expectation library, matcher library, and mocking library. It doesn't make any assumptions and the only things it focuses on is providing a nice DSL to write expressive tests, and to run them leveraging XCTest.

Last week Specta 0.4 has been released. One of the [new features added](https://github.com/specta/specta/blob/master/CHANGELOG.md) is:

> Makes it easy to skip the beforeEach/afterEach functions for specific classes

So as of Specta 0.4 we can now skip the global `beforeEach` and `afterEach` hooks for a class. There is an [example project](https://github.com/mokacoding/specta-global-before-after-each) to check out and to use to play around with this feature.

Before looking into how to skip global hooks, let's see what they are, and how to set them.

## Before and after each hooks

Say that we have a `Banana` class, and that we want to test it's _looks yellow_ behaviour. We get a banana from the fruit bowl, and wherever we put it it should still look yellow.

Unfortunately our `Banana` is a stateful fruit, so to make the test accurate we have to put it back in the fruit bowl every time.

A Specta spec to describe this behaviour might look like this:

```objc
describe(@"Banana", ^{
  it(@"should look yellow when put on the table", ^{
    [banana removeFromTheFruitBowl];
    [banana putOnTheTable];
    expect([banana looksYellow]).to.beTruthy();
    [banana putInTheFruitBowl];
  });

  it(@"should look yellow when put on the snack bag", ^{
    [banana removeFromTheFruitBowl];
    [banana putInTheSnackBag];
    expect([banana looksYellow]).to.beTruthy();
    [banana putInTheFruitBowl];
  });
});
```

This spec looks a bit dense, and [wet](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself#DRY_vs_WET_solutions). Thanks to the `beforeEach` and `afterEach` hooks we can write it in a clearer and drier way:

```objc
describe(@"Banana", ^{
  beforeEach(^{
    [banana removeFromTheFruitBowl];
  });

  it(@"should look yellow when put on the table", ^{
    [banana putOnTheTable];
    expect([banana looksYellow]).to.beTruthy();
  });

  it(@"should look yellow when put on the snack bag", ^{
    [banana putInTheSnackBag];
    expect([banana looksYellow]).to.beTruthy();
  });

  afterEach(^{
    [banana putInTheFruitBowl];
  });
});
```

## Configuring a global hook in Specta

Now, not only our `Banana` is stateful, but also is an hidden dependency in several other pieces of the system. Let's for a moment forget that the best thing to do in this case would be to do some good old refactoring to extract that dependency, and imagine that the only thing we can do is call the `removeFromTheFruitBowl` and `putInTheFruitBowl` methods in every test.

This option is quite annoying isn't it? Our specs shouldn't have to care about setup and tear down operations that are at the system level. Plus it's easy to forget about this step.

Specta takes care of this problem for us. Before running the suite it will inspect the run time for classes with `beforeEach` and `afterAll` class methods, and run them before and after each example in the suite.

```objc
@interface BeforeAfterEachHelper : NSObject
@end

@implementation BeforeAfterEachHelper

+ (void)beforeEach {
  // this code will run beforeEach example
  //...
}

+ (void)afterEach {
  // this code will run afterEach example
  //...
}

@end
```

Pretty handy, isn't it?

## Disabling a global hook

For some reason you might have a class that already has a `+ afterEach` method, and you don't want it to run as global hook in the tests. As mentioned at the start the latest release, version 0.4, makes it easy to skip classes that have before or after each hooks.

It's simply required to conform to the `SPTExcludeGlobalBeforeAfterEach`.

```objc
@interface BeforeAfterEachHelper : NSObject <SPTExcludeGlobalBeforAfterEach>`
@end

@implementation BeforeAfterEachHelper

+ (void)beforeEach {
  // this code will NOT run beforeEach example
  //...
}

+ (void)afterEach {
  // this code will NOT run afterEach example
  //...
}

@end
```

---

One could argue that a suite that needs to run code before and/or after each test has some intrinsic problem, and that time should be spent to improve the architecture of the system under test. Regardless of that I think this option offered by Specta is interesting and powerful.

Have a look at the [example project](https://github.com/mokacoding/specta-global-before-after-each) to see global hooks in action, or check out the video below, and feel free to leave a comment or tweet me at [@mokagio](https://twitter.com/mokagio).

<iframe width="640" height="480" src="https://www.youtube-nocookie.com/embed/CAZEUa55Ceg?rel=0" frameborder="0" allowfullscreen></iframe>

_Happy coding, and leave the codebase better than you found it._
