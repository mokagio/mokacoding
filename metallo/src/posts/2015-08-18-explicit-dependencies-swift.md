---
layout: post
title: Explicit Dependencies, Swift Edition
description: "A look at how to write classes and structs that expose their dependencies as initialization arguments in Swift."
tags:
- Testing
- Software Design
- Swift
---

In [last week's post](https://mokacoding.com/blog/explicit-dependencies/) we talked about [explicit dependencies](https://mokacoding.com/blog/explicit-dependencies/).

To make a struct or class dependencies explicit means to pass all the objects needed as initialization parameters. By doing so a reader of the code, and let's remember that we all spend more time reading code than writing it, can contextualise the class simply by looking at the interface, there are no surprises in the implementation. Testability also becomes easier, we can simply pass mocks or fakes, and be sure that the system under test internals are not going to instantiate other objects.

The [post](https://mokacoding.com/blog/explicit-dependencies/) is written in Objective-C to stress the separation between interface and implementation. It is easier to visualise when they are in two different files!

Unlike Objective-C, Swift's code is all in one file, interfaces and implementation are merged together, except when looking at a compiled framework. Nevertheless everything we said for Objective-C explicit dependencies is true for Swift as well.

Here's how a class that exposes its dependencies might look like in Swift:

```swift
class ProductService {
    let parser: Parser
    let appStateService: AppStateService
    let networkService: NetworkService

    init(appStateService: AppStateService, networkService: NetworkService, parser: Parser) {
        self.parser = parser
        self.networkService = networkService
        self.appStateService = appStateService
    }

    convenience init() {
        self.init(appStateService: AppStateService.sharedInstance(),
            networkService: NetworkService.sharedInstance(),
            parser: Parser())
    }

    // MARK: -

    func allProducts(completion: ([Product]?, ErrorType?) -> ()) {
        let currentUser = appStateService.currentUser()
        let success: ([String: AnyObject]) -> () = { response in
            completion(self.parser.parseProducts(response), .None)
        }
        let failure: (ErrorType) -> () = { error in
            completion(.None, error)
        }
        networkService.getAllProducts(currentUser, success: success, failure: failure)
    }
}
```

Let's appreciate the fact that by declaring `parser`, `appStateService`, and `networkService` as class properties we see them at the very top of the code. _This is just a convention, the same code with the properties defiend at the very bottom would sitll compile._

Another little detail to underline is the use of the `convenience` keyword. That make is clear to the reader, and the compiler, that that initializer is not the _proper_ one, but a more convenient one to use.

I am a bit conflicted on the use of that one in place of a convenience factory method:

```swift
static func configuredService() -> ProductService {
    return ProcutService(appStateService: AppStateService.sharedInstance(),
        networkService: NetworkService.sharedInstance(),
        parser: Parser())
}
```

What do you think about it? Convenience initializer or factory method? Hit me up on Twitter [@mokagio](https://twitter.com/mokagio), or leave a comment below.

_Leave the codebase better that you found it._
