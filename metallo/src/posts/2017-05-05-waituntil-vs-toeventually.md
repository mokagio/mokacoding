---
layout: post
title: "Nimble: when to use waitUntil or toEventually"
description: "The Nimble matchers framework provides two ways assert expectations on asynchronous code, this post explores when to use one or the other."
tags:
- Testing
- Nimble
- Swift
---

[Nimble](https://github.com/Quick/Nimble) provides two ways to assert code that runs asynchronously, `toEventually` and `waitUntil`. In this post we  look at them in more details, and understand when to use one or the other.

## `toEventually`

You can use `toEventually` to write expectations that should be tested at some point in the future.

Its [documentation](https://github.com/Quick/Nimble/blob/514358cadbe7012a3e870eb700ec626a486fae52/Sources/Nimble/Matchers/AsyncMatcherWrapper.swift#L111-L117) reads:

> Tests the actual value using a matcher to match by checking continuously at each pollInterval until the timeout is reached.

It can be used like:

```swift
expect(foo).toEventually(equal("something"))

expect(array).toEventually(beEmpty())
```

`toEventually` is very nice because it allows us to write expectations that read like english. "_Expect value to eventually be this_".

Having code, whether it is production or test, that reads well makes working in the codebase easy.

## `waitUntil`

`waitUntil` is not a matcher or an expectation, but just an utility function provided by Nimble.

Its [documentation](https://github.com/Quick/Nimble/blob/514358cadbe7012a3e870eb700ec626a486fae52/Sources/Nimble/DSL%2BWait.swift#L89-L96) reads:

> Wait asynchronously until the done closure is called or the timeout has been reached.

It can be used like:

```swift
waitUntil { done in
  service.asynMethodWithCallback { value in
    // some expectation(s)
    // ...

    done()
  }
}
```

If `done` is not called the test will fail, _so remember that will ya_?

## When to use which

When testing that a certain condition should be met as a result of the invocation of async code `toEventually` is your go to API.

Here's a more detailed example, which you can find in full [on GitHub](https://github.com/mokacoding/nimble-waitUntil-vs-toEventually).

Imagine we have an `AsyncService`, with a method that changes the value of a property on its delegate.

```swift
protocol AsyncServiceDelegate: class {
  var aProperty: String { get set }
}

class AsyncService {

  weak var delegate: AsyncServiceDelegate?

  func callThatResultsInSideEffect() {
    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) { [weak self] in
      self?.delegate?.aProperty = "bazinga"
    }
  }
}
```

A good way to test the implementation of `callThatResultsInSideEffect` is to create a fake delegate, pass it to the service, call the method, and finally verify that the value _eventually_ matches our expectation.

```swift
class FakeDelegate: AsyncServiceDelegate {
  var aProperty: String = "unset"
}

func testToEventually() {
	let delegate = FakeDelegate()
	let service = AsyncService()
	service.delegate = delegate

	service.callThatResultsInSideEffect()

	expect(delegate.aProperty).toEventually(equal("bazinga"))
}
```

Let's now add a new asynchronous function to our service. One that takes a callback as input and will call it once the async work is done. For the sake of the example let's imagine that this async work is fetching a certain `String`, and the callback receives a `Result` type (_have a look at [this library](https://github.com/antitypical/Result) for a proper implementation_).

```swift
extension AsyncService {
  func doStuff(_ completion: @escaping (Result<String>) -> ()) {
	DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) {
      completion(Result<String>.success("bazinga"))
    }
  }
}
```

To test that `doStuff(_ completion:)` behaves properly using `toEventually` we could writing something like:

```swift
func testDoStuffWithToEventually() {
  let service = AsyncService()

  var callbackValue: String? = .none
  service.doStuff { result in
    switch result {
    case .success(let value): callbackValue = value
    case .error(let error): fail("Expected call to doStuff to succeed.")
    }
  }

  expect(callbackValue).toEventually(equal("bazinga"))
}
```

There are two issues with this test.

The first is that it requires a bit of extra setup, in the form of the variable `callbackValue`. This is not a big deal, but we should strive to keep our tests as lean as possible.

In our case the callback has only one parameter, but it is not uncommon to have async callbacks with more than that. For example `URLSession`'s [`dataTask(with:completionHandler:)`](https://developer.apple.com/reference/foundation/urlsession/1407613-datatask) has three.

Using this technique we might have to define a number of variables to contain the values received by the callback. This extra work makes the test harder to write and maintain.

The second problem is that the test doesn't read well. "_setup, define a variable, make async call with callback that says to copy the received value, expect copy of received value to eventually equal 'bazinga'_".

In a case like this using `waitUntil` results in a better test, where with better we mean with less setup needed, and reading closer to natural language.

```swift
func testAsyncCallResult() {
  let service = AsyncService()

  waitUntil { done in
    service.doStuff { result in
      switch result {
      case .success(let value):
        expect(value) == "bazinga"
        done()
      case .error:
        fail("Expected call to doStuff to suceeded, but it failed")
      }
    }
  }
}
```

This code, while having a bit more indentation, reads better. "_setup, wait until async call returns a result, expecting the returned value to equal 'bazinga'_". More straightforward and self explanatory, and arguably cleaner than having to copy received values.

---

To recap, when the behavior to test is simply the fact that the a value will change as the result of an async call, or that the given callback is actually exectuted, toEventually provides a clean API, that reads like english.

When the behaviour to test is more complex, for example involving asserting the value provided to the callback, or the fact that the success/failure one is called rather than the other, then waitUntil is most suited.

Get in touch oun Twitter [@mokagio](https://twitter.com/mokagio) or leave a comment below if you have any question regarding this post, or if you want to share your strategy for testing asynchronous code using Nimble.

Until next time:

_👋 Leave the codebase better than you found it._