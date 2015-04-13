---
layout: post
title: Better Cocoa unit testing with Specta
description: "Writing unit tests for our iOS and OS X projects not only is important, but should be always part of the development cycle. As such the way we write the tests is as important, and having the option to write tests that easily explain their purpose can drastically increase the quality of the suite. Specta and Expecta are two libraries that provide a different way to writing tests than XCTest, let's see what we can gain by using such approach."
tags:
- Testing
- Specta
- XCTest
---

In this post we're going to explore an approach to writing unit tests different for the Apple standard, using what can be called _xSpec syntax_, and what advantages it can bring us.

If you've done some kind of Ruby development you'll probably be familiar with [RSpec](http://rspec.info/). The aim of RSpec is to provide a framework for _[Behaviour Driven Development](http://en.wikipedia.org/wiki/Behavior-driven_development)_. Without using buzz words we can say that RSpec allows us to write tests in a way that **focuses on the behaviour of the system under test**, producing more descriptive test cases.

We can refer to this style of testing as to _xSpec_ style.

Languages other than Ruby now have their xSpec frameworks, in "[The state of iOS testing in 2015](http://www.mokacoding.com/blog/ios-testing-in-2015/)" we mentioned [Specta](https://github.com/specta/specta) and [Kiwi](https://github.com/Kiwi-BDD/Kiwi) for Objective-C, and [Quick](https://github.com/Quick/Quick) for Swift.

In this post we're going to use Specta. We'll first write a test in the XCTest way, then rewrite it using Specta, and see the difference.

### The task

Let's go back to [Bench](https://github.com/mokacoding/Bench), our playground app introduced in the "[Setting up KIF for iOS acceptance testing](http://www.mokacoding.com/blog/setting-up-kif-for-ios-acceptance-testing/) post.

Bench shows a list with the elements of the periodic table in a `[symbol] name (atomic number)` format. So far that data has been hardcoded in Bench as an array of string. Yuck! 😨😷

The task for this example will be to read that data from a JSON file, and to then parse each entry, which will be a dictionary, into a string formatted as per specification.

For the sake of brevity we'll skip reading from file part and focus only on the formatting bit.

One way to solve the problem is to have an object that provides a method, which given a dictionary as and input returns a string, given that the dictionary is "valid".

To make the task a bit more interesting let's add these specifications:

* when the input is not valid return `nil`
* if the input is missing the `atomic number` key, omit it in the formatted string

And let's define "valid" like this

* a `nil` input is not valid
* an input dictionary missing the `name` is not valid
* an input dictionary missing the `symbol` is not valid
* any other input dictionary is valid

Given this very simple specification we can make and `ElementFormatter` class, with a `formattedStringForElement:` method.

### The XCTest way

The test for this class, written using XCTest would look something like this:

```objc
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ElementFormatter.h"

@interface ElementFormatterTests : XCTestCase

@property (nonatomic, strong) ElementFormatter *formatter;

@end

@implementation ElementFormatterTests

- (void)setUp {
    [super setUp];
    self.formatter = [[ElementFormatter alloc] init];
}

- (void)testNilArgument {
    XCTAssertNil([self.formatter formattedElementString:nil], @"ElementFormatter did not return nil when given nil data");
}

- (void)testMissingName {
    NSDictionary *data = @{ @"symbol": @"E", @"atomic_number": @"42" };
    XCTAssertNil([self.formatter formattedElementString:data], @"ElementFormatter did not return nil when given element data missing the name");
}

- (void)testMissingSymbol {
    NSDictionary *data = @{ @"name": @"element", @"atomic_number": @"42" };
    XCTAssertNil([self.formatter formattedElementString:data], @"ElementFormatter did not return nil when given element data missing the symbol");
}

- (void)testMissingAtomicNumber {
    NSDictionary *data = @{ @"name": @"element", @"symbol": @"E" };
    XCTAssertEqualObjects([self.formatter formattedElementString:data], @"[E] element", @"ElementFormatter did not format element data missing the atomic number as expected");
}

- (void)testSuccess {
    NSDictionary *data = @{ @"name": @"element", @"symbol": @"E", @"atomic_number": @"42" };
    XCTAssertEqualObjects([self.formatter formattedElementString:data], @"[E] element (42)", @"ElementFormatter did not format valid element data as expected");
}

@end
```

### The Specta way

Now let's add Specta and its expectation and matching library [Expecta](https://github.com/specta/expecta) to our project and write a test, actually a _spec_ using the xSpec terminology, for `ElementFormatter`.

_Note: I don't know why the text highlighting is not working properly. This blog is [open source](https://github.com/mokagio/mokacoding/) though, so if you have a suggestion on how to fix it I'd love a PR._

```objc
#import <Specta.h>
#import <Expecta.h>
#import "ElementFormatter.h"

SpecBegin(ElementFormatter)

describe(@"ElementFormatter", ^{
    __block ElementFormatter *formatter;
    
    beforeAll(^{
        formatter = [[ElementFormatter alloc] init];
    });
    
    context(@"when formatting an element dictionary", ^{
        context(@"when the dictionary is nil", ^{
            it(@"returns nil", ^{
                expect([formatter formattedElementString:nil]).to.beNil();
            });
        });
        
        context(@"when the dictionary is missing the name key", ^{
            it(@"returns nil", ^{
                NSDictionary *data = @{ @"symbol": @"E", @"atomic_number": @"42" };
                expect([formatter formattedElementString:data]).to.beNil();
            });
        });
        
        context(@"when the dictionary is missing the symbol key", ^{
            it(@"returns nil", ^{
                NSDictionary *data = @{ @"name": @"element", @"atomic_number": @"42" };
                expect([formatter formattedElementString:data]).to.beNil();
            });
        });
        
        context(@"when the dictionary is missing the atomic_number key", ^{
            it(@"returns the [symbol] name format", ^{
                NSDictionary *data = @{ @"name": @"element", @"symbol": @"E" };
                expect([formatter formattedElementString:data]).to.equal(@"[E] element");
            });
        });
        
        context(@"when the dictionary contains all the keys", ^{
            it(@"returns the expected string it the [symbol] name (atomic number) format", ^{
                NSDictionary *data = @{ @"name": @"element", @"symbol": @"E", @"atomic_number": @"42" };
                expect([formatter formattedElementString:data]).to.equal(@"[E] element (42)");
            });
        });
    });
});

SpecEnd
```

What do you think about it?

In my opinion the Specta version explains what the system under test is supposed to do better, and is more readable.

Thanks to the `context` and `describe` blocks (they are aliases) we can organize the spec like a book, with chapter and paragraphs. Using the `it` block we can focus only on the expected result, moving any clutter due to setup code in the `context` block. The only way to achieve a similar result with XCTest is to use comments, or multiple files, with Specta we have built in support for clarity.

The fact that `it` and `context` take as their first argument the description of the block itself results in a clearer test. The reader reads what is expected first, and then sees the assertion code.

```objc
// XCTest
XCTAssertNil([self.formatter formattedElementString:data], @"ElementFormatter did not return nil when given element data missing the symbol");

// Specta
NSDictionary *data = @{ @"symbol": @"E", @"atomic_number": @"42" };
expect([formatter formattedElementString:data]).to.beNil();
```

Thanks to Expecta even the syntax used for the assertion is more _human readable_, `expect().to.equal()` instead of `XCTAssertEqual()`.

I think that these details all sum up together to produce tests that are easy to read, understand and write. These test could serve as a first form of documentation, that doesn't take extra time to be written, because it's developed together with the code.

All this is not to say that XCTest is not a good framework. Actually without XCTest Specta couldn't even run! The point is that because code should be written thinking about who will read it using an xSpec approach, that shifts the focus on describing the behaviour rather than just testing a list of expectations, can make working with the tests easier and more productive.

And it doesn't end here! Specta has several other features, like shared examples and local before and after blocks, that make writing specs very easy, while Expecta has a list of [plugins](https://cocoapods.org/?q=expecta) that make writing assertions even more powerful and descriptive.

I'm interested to hear your opinion on the matter, so please use the comments form below, or tweet me [@mokagio](https://twitter.com/mokagio). And if you're curious about how the tests would be in Swift using [Quick](https://github.com/Quick/Quick),  or with another Objective-C library, [subscribe](/#subscribe) to the newsletter because we'll look at it soon.

_Happy coding, and leave the codebase better than you found it._
