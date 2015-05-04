---
layout: post
title: Writing an Expecta custom matcher
description: "Not only Expecta is a simple to use library that allows us to write highly readable code, but it can also be extended by the users with custom matchers. Let's see how to write a custom matcher to gain readability and reuse code in our test suites."
tags:
- Specta
- Expecta
---

In the last post we looked at [Expecta, a matcher library that speakes English](http://www.mokacoding.com/blog/expecta/), and we noticed how easy it is to use it to write test expectations that explain themselves.

We can bring clarity one step forward. Expecta, in fact, allows users to write _custom matchers_, we can extend Expecta with our very own `expect().to.beSomethingSomething()`. The reasons you might want to do that could be:

* DRYness of your test, if there's some complex expectation that you find yourself using multiple time in a test you can encapsulate it in a custom matcher
* Readability, `.beAnApple` reads better than `.beKindOf([Apple class])`
* Power, you might need assertions that are more powerful or refined than the default ones, for example `expect(arrayInstance).to.haveSameSecondObjectAs(anotherArrayInstance)`.

### How to write a custom matcher

Writing a custom matcher is a simple task, since the library is open source we can have a look at how the default matchers are implemented, and the README [provides guidance too](https://github.com/specta/expecta#writing-new-matchers).

Now let's imagine that for some reason a big part of the system we're developing has to do with generating fruit at runtime and that in our tests suites we find ourselves writing `expect(something).to.beKindOf([Fruit class])`  many times. To make the tests both more readable and DRY we'd like to add a matcher that look like `.beAFruit()`.

The first step is creating an `EXPMatchers` category named after the new matcher: `EXPMatchers+beAFruit`.

We are now going to look at the code step by step, you can always check the example repo to see the entire [header](https://github.com/mokacoding/expecta-plugin-example/blob/6f18f0ea17976e376fa55feea2006bb52b3671dd/expecta-plugins-exampleTests/EXPMatchers%2BbeAFruit.h) and [implementation](https://github.com/mokacoding/expecta-plugin-example/blob/6f18f0ea17976e376fa55feea2006bb52b3671dd/expecta-plugins-exampleTests/EXPMatchers%2BbeAFruit.m).

In the `.h` we'll define the signature of our matcher using the `EXPMatcherInterface` macro, which expects the matcher name and a list of arguments.

```objc
#import "Expecta.h"

EXPMatcherInterface(beAFruit, (void))
```

Notice the `(void)` as the second argument to state that our matcher is not using any parameters.

Than we are going to write the matcher's implementation, by providing code to run for the blocks making up the matcher.

```objc
#import "EXPMatchers+beAFruit.h"
#import "Fruit.h"

EXPMatcherImplementationBegin(beAFruit, (void)) {
```

The matcher has access to the object in the `expect( )` through `actual`. Since we're going to need to check for it's `nil` state more than once in the implementation we should put that value in a variable.

```objc
  BOOL actualIsNil = actual == nil;
```

The first block to implement is `prerequisite`, this can be used to perform pre-checks and make the test fail. In the library's [`beCloseTo`](https://github.com/specta/expecta/blob/master/Expecta/Matchers/EXPMatchers+beCloseTo.m#L5) if `actual` is not an `NSNumber` there is no point in comparing it, so the test can fail already. In our case if `actual` is nil the is certainly not a `Fruit`, so we can fail straightaway.

```objc
  prerequisite(^BOOL {
    return !actualIsNil;
  });
```

Then there is `match`, which is where we can perform all the logic to determine whether our expectation is met.

```objc
  match(^BOOL {
    return [actual isKindOfClass:[Fruit class]];
  });
```

Finally there are two blocks that print the error message for the normal and negated (`.toNot`) failure scenarios.

```objc
  failureMessageForTo(^NSString * {
    if (actualIsNil) {
      return @"the actual value in nil/null";
    }

    return [NSString stringWithFormat:@"expected: kind of %@, got: an instance of %@", [Fruit class], [actual class]];
  });

  failureMessageForNotTo(^NSString * {
    if (actualIsNil) {
      return @"the actual value in nil/null";
    }

    return [NSString stringWithFormat:@"expected: not kind of %@, got: an instance of %@", [Fruit class], [actual class]];
  });
```

The last thing left to do is do declare that the implementation is finished.

```objc
EXPMatcherImplementationEnd
```

You can see `beAFruit` implementation all in one file, as well as it's usage in a test case, in the [example repo](https://github.com/mokacoding/expecta-plugin-example).

In case you want to write a matcher that uses an argument, like `expect(@42).to.beLessThan(@100)`, you can specify it in the matcher interface and implementation definition blocks like this:

```objc
EXPMatcherInterface(beLessThan, (id expected));
```

Note that `expected` is the naming convention used by all the matcher in the library, so you should use it too.

### Custom matchers in the wild

So nice people in the open source community have already written some custom matchers for Expecta. The most interesting ones are:

* [Expecta+Comparison](https://github.com/kylef/Expecta-Comparison) that provides comparison matchers for `NSArray`, `NSDictionary` and `NSSet`, and has a more informative failure message than the default comparison matcher.
* [Expecta+OCMock](https://github.com/dblock/ocmock-expecta) which maps some of the expectations on mock and stubs made using [OCMock](http://ocmock.org/), making for better readability and consistency in the test.
* [Expecta+Dates](https://github.com/foulkesjohn/Expecta-Dates) that adds a `beSameDay` matcher for `NSDate`s.
* [Expecta+ReactiveCocoa](https://github.com/kylef/Expecta-ReactiveCocoa), set of matchers for using Expecta to test [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)'s signals.

---

In these last two posts we've seen how nice and powerful Expecta is. In an inspirational moment I would go as far as to say that we as developer should try to structure our code as Expecta, simple to use, very well readable, and extendable.

If after reading this you'll write an amazing custom matcher pleas let me know by tweeting [@mokagio](https://twitter.com/mokagio), and don't forget to make it open source and publish it on CocoaPods.

