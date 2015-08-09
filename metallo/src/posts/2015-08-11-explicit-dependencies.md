---
layout: post
title: Explicit Dependencies for Code with No Surprises
description: "Sometimes the idea we get when reading a class interface is different from what is actually going on inside its implementation, for example there could be several hidden dependencies. Making a class dependency explicit in its interface isa useful technique to make the code simpler to understand, and easier to test."
tags:
- Testing
- Objective-C
- Software-Design
---

Imagine you go back to your childhood bedroom, and find a cardboard box with "Marvel Comics" written on its lid, in fat black marker. You open the box and what you find is your collection of Spiderman, Daredevil, X-Men comics, but also your old Game Boy, a crayon, your sister's favourite Barbie, and a bag of lollies that is clearly past its due date. That is not what you were expecting. Inside that box there were a lot of hidden, and in case of the lollies disappointing, surprises.

Like that box, our classes, and structs, can expose deceivingly simple interfaces, while hiding a blob of spaghetti code, complexity and dependencies in their implementations.

![What lies under the hood of your interface](https://s3.amazonaws.com/mokacoding/2015-08-11-mistrey-box-implementation.jpg)

In this post we are going to see how to make an object's dependencies _explicit_, why it is a good idea, and the trade-offs we make when choosing such a design.

Consider this interface:

```objc
typedef void (^Completion)(NSArray *products, NSError *error);

@interface ProductsService: NSObject

- (void)allProducts:(Completion)completion;

@end
```

It looks fairly simple, right? Let's have a look at the implementation:

```objc
@implementation ProductsService

- (void)allProducts:(Completion)completion {
    User *user = [[AppStateService sharedInstance] currentUser];
    [NetworkService sharedInstance] getAllProductsForUser:user withSuccess:^(NSDictionary *responseDictionary) {
      Parser *parser = [Parser alloc] init];
      NSArray *products = [parser parseProducts:responseDictionary];
      completion(products, nil);
    } failure:^(NSError *error) {
      completion(nil, error);
    }];
}

@end
```

See what's going on in there? Apart from the disgusting `sharedInstance`s, the `-allProducts:` method is using other three objects in its internals: `AppStateService`, `Parser` and `NetworkService`.

Now, there is conceptually nothing wrong with this. You could say that `ProductsService` is acting as a [facade](https://en.wikipedia.org/wiki/Facade_pattern) and that is the embodiment of the [information hiding principle](https://en.wikipedia.org/wiki/Information_hiding). And you would be right.

However, there is a high _surprise effect_ between what the interface exposes and what the implementation does. Hiding all the components involved in the process can make it harder to see all the moving parts of the system, reason about it, and understand how to make changes safely.

## How to make dependencies explicit

Making a class's dependencies explicit is quite simple. Let's look at the `ProductService` from above.

```objc
@interface ProductsService: NSObject

- (instancetype)initWithParser:(Parser *)parser
                  stateService:(AppStateService *)stateService
                networkService:(NetworkService *)networkService;

//...

@end

@implementation ProductsSevrice

- (instancetype)initWithParser:(Parser *)parser
                  stateService:(AppStateService *)stateService
                  networkService:(NetworkService *)networkService {
  self = [super init];
  if (!self) { return nil; }

  self.parser = parser;
  self.stateService = stateService;
  self.networkService = networkService;

  return self
}

//...

@end
```

And we can then rewrite `allProducts` like this:

```objc
- (void)allProducts:(Completion)completion {
    User *user = [self.stateService currentUser];
    [self.networkService getAllProductsForUser:user withSuccess:^(NSDictionary *responseDictionary) {
      NSArray *products = [self.parser parseProducts:responseDictionary];
      completion(products, nil);
    } failure:^(NSError *error) {
      completion(nil, error);
    }];
}
```

The idea is simple, instead of instantiating the objects used in the method's internals, we simply pass them as `init` arguments, that will be stored in instance properties.

## The benefits of explicit dependencies

**Dependencies are clear in the interface.** By exposing all the objects our class needs in its internals either in the `init` or as method parameters we provide readers of the interfaces all the information and all the context around the class.

**Testability.** This is probably the bigger advantage of explicit dependencies. By doing this we provide what [Michael Feathers](http://objectmentor.com/omTeam/feathers_m.html) calls _seams_ in <a href="http://www.amazon.com/gp/product/0131177052/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0131177052&linkCode=as2&tag=mokacoding09-20&linkId=N5TQLGWRTPQNXM7B">Working Effectively with Legacy Code</a><img src="http://ir-na.amazon-adsystem.com/e/ir?t=mokacoding09-20&l=as2&o=1&a=0131177052" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important; display: inline;" />. We can now use mocks or fakes when testing, therefore controlling the inputs our class receives and making sure the test is deterministic.

## When to use this approach

Software development is all about tradeoffs, as [Kent Beck](https://twitter.com/kentbeck) reminds us:

![Kent Beck tradeoffs gif](https://s3.amazonaws.com/mokacoding/tradeoffs.gif)

We already touched on the fact that by making all the dependencies explicit we lose some of the benefits of information hiding, and our code takes more time do deal with, we have to instantiate or pass around all those instances. What we lose from that side we gain in clarity, flexibility, and testability.

So the question is when to choose which?

My rule of thumb is that when working with _application code_, code that implements the functionality of the product, that is strictly related to the problem space the app is addressing, and that is not intended to be used in other projects, all the dependencies should be explicit. This makes it easier to put into context, and marries well with a test driven development style.

When instead the code is for a library, or when there is the need to add a layer of abstraction, for example to provide a simpler set of APIs, _hiding_ complexity, than that's a good case for hiding dependencies.

## There is a middle ground

Turns out you can have your pie and eat it too when it comes to explicit dependencies and simple interfaces.

For example you can make the dependencies explicit in the [designated initializer](https://developer.apple.com/library/mac/documentation/General/Conceptual/CocoaEncyclopedia/Initialization/Initialization.html#//apple_ref/doc/uid/TP40010810-CH6-SW3), and provide a convenience factory method that does all the hard work for you.

```objc
@interface ProductsService: NSObject

- (instancetype)initWithParser:(Parser *)parser
                  stateService:(AppStateService *)stateService
                networkService:(NetworkService *)networkService NS_DESIGNATED_INITIALIZER;

//...

@end

@interface ProductsService (Convenience)

+ (instanceType)productsService;

@end
```

I personally like to put factory methods in a category extension, just to make the separation from the core code of the class clearer.

When designing code is important to remember that being too smart is not a clever idea. Code that does too much, with side effects, or with implementations that don't behave as one would expect when looking at the interface are dangerous. When writing code we should think of our readers and apply the [principle of least astonishment](https://en.wikipedia.org/wiki/Principle_of_least_astonishment), everything should behave as the they would expect. Making the dependencies of your classes explicit is one good technique to make sure that once the interface lid is lifted and we take a look at the implementation there are no surprises.

_Leave the codebase better than you found it._
