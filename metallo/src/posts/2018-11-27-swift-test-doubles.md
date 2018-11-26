---
title: "Test doubles in Swift: dummies, fakes, stubs, and spies."
description: "An overview of the different kind of doubles we can use in our tests, and how to write them in Swift."
tags:
  - Testing
  - Swift
---

Eskimos have [many words for snow](https://www.washingtonpost.com/national/health-science/there-really-are-50-eskimo-words-for-snow/2013/01/14/e0e3f4e0-59a0-11e2-beee-6e38f5215402_story.html). _Aqilokoq_ is the softly falling snow and _piegnartoq_ is the snow that is good for driving sled.

Languages evolve their vocabularies to serve the needs of their speakers. Being able to differentiate between snow that is fresh and soft and snow which is good to drive a sled with a single word makes you communicate with your Eskimo friends more efficiently.

Having words to call things and concepts by provides us with the foundation to understand them. It allows us to think about them at a deeper and more specific level.

When writing tests we often have to reach for _test doubles_. These are copies of the inputs of our system under test written in such a way to make it easier to verify certain behaviours. Like Eskimos, we software developers need a rich vocabulary to distinguish between test doubles based on what they do, in order to have better conversations about them.

I like to refer to the test doubles catalogue from [Martin Fowler](https://martinfowler.com/bliki/TestDouble.html) and the [xUnit Patterns](http://xunitpatterns.com/Mocks,%20Fakes,%20Stubs%20and%20Dummies.html). Here's how those concepts look like in Swift.

## Dummy

A dummy is a test double that **doesn't do anything**.

You might use this as a placeholder for an input parameter of the system under test when it doesn't interact or affect the behaviour you are testing.

```swift
struct DummyPizzaGetter: PizzaGetter {

    func getPizza(_ completion: (Result<[Pizza], PizzaAPIError>) -> Void) {
      // does nothing
    }
}
```

## Fake

A fake is test double **returning the same value or performing the same behaviour all the time**.

You might want to use this when the behaviour of the system under test has something your component does as a pre-requisite, regardless of its outcome.

For example when writing an integration test you might want to provide a different implementation of the storage layer, say an in-memory one rather than one writing to disk. Your integration test depends on the storage behaving properly and consistently, but you never need to look into the it as part of what you're testing.

## Stub

A stub is a test double you can use to **control the input provided to the system under test**.

When the behaviour you are testing depends on what an input does you should use a stub for that input in your tests.

A common use case for stubs is to allow testing how objects behave depending on the success or failure of an operation.

My favourite use case for stubs is when testing the behaviour of objects consuming a service making a request that can succeed or fail. We can write a stub in which we control whether the request succeeds or fail, and this allows us to test the behaviour of our component in both scenarios.

Say we have a `PizzaPresenter` charged with providing view controllers the logic to fetch pizzas from the server and transform them into objects that can be displayed. We can test how it behaves if the request succeeds or fails using a stub.

```swift
func testSuccessfulLoad() {
    let presenter = PizzaPresenter(
        pizzaGetter: PizzaGetterStub(pizzas: [.margherita, .pepperoni])
    )

    waitUntil { done in
        presenter.load { result in
            switch result {
            case .success(let displayablePizzas):
                // expectations on the received displayable pizzas
            case .failure(let error):
                fail("Expected to succeed, failed with \(error)")
            }
        }
    }
}

func testFailedLoad() {
    let presenter = PizzaPresenter(
        pizzaGetter: PizzaGetterStub(error: .offline)
    )

    waitUntil { done in
        presenter.load { result in
            switch result {
            case .success(let displayablePizzas):
                fail("Expected to fail, succeeded with \(dispayablePizzas)")
            case .failure(let error):
                // expectation on the received error
            }
        }
    }
}
```

This is how the stub looks like:

```swift
class PizzaGetterStub: PizzaGetter {

    private let result: Result<[Pizza], PizzaAPIError>

    init(pizzas: [Pizza]) {
        self.result = .success(pizzas)
    }

    init(error: PizzaAPIError) {
        self.result = .failure(error)
    }

    func getPizzas(_ completion: (Result<[Pizza], PizzaAPIError>) -> Void) {
        completion(result)
    }
}
```

## Spy

A spy is a test double you can use to **inspect the output produced by the system under test**.

Spies are the opposite of stubs. When the system under test performs a side effect on a dependency you can use a spy to record the effect and then verify it matches the expected behaviour.

For example, every one is implementing Dark Mode in their iOS apps nowadays. Say you want to test `SettingsController`, the component which your settings view controller uses to relay the user interaction with the UI.

```swift
class SettingsController {

    // ...

    func set(darkModeEnabled enabled: Bool) {
        if enabled {
            layoutManager.paintDarkMode()
        } else {
            layoutManager.paintLightMode()
        }

        settingsStorage.set(darkModeEnabled: enabled)
    }
}
```

The behaviour you want to test is that `SettingsController` correctly stores the dark mode preference. You can provide a spy for the storage layer, and make sure the right value is put there.

```swift
class SettingsStorageSpy: SettingsStorage {

    private(set) var darkModeEnabled: Bool?

    func set(darkModeEnabled enabled: Bool) {
        self.darkModeEnabled = enabled
    }
}
```

Notice how `darkModeEnabled` is an `Optional` `Bool`. This will allow you to test whether the value is set at all. If your test will read a `.none` for `darkModeEnabled` you'll know your code didn't call `set(darkModeEnabled:)`.

This is how to use the spy:

```swift
func testSettingDarkMode() {
    let spy = SettingsStorageSpy()
    let controller = SettingsController(
        layoutManager: LayoutManagerDummy(),
        settingsStorage: spy
    )

    controller.set(darkModeEnabled: true)

    expect(spy.darkModeEnabled) == true
}
```

Notice how we passed a dummy for the `LayoutManager` input parameter. `SettingsController` needs a `LayoutManager` value to initialize, but our test doesn't care about how it interacts with it, so we can pass a dummy.

## What about mocks?

If you are reading about unit testing sooner or later you'll come across the "mock" word. Mock is a word bloated with meaning in the testing vocabulary.

Martin Fowler [refers to mocks](https://martinfowler.com/bliki/TestDouble.html) as doubles that are "pre-programmed with expectations which form a specification of the calls they are expected to receive. They can throw an exception if they receive a call they don't expect and are checked during verification to ensure they got all the calls they were expecting."

If you are working on a dynamic language chances are there's a mocking framework for it. Objective-C has [OCMock](http://ocmock.org/), JavaScript has [Mocha](https://mochajs.org/) and [Sinon](https://sinonjs.org/), Ruby has [rspec-mock](https://github.com/rspec/rspec-mocks), just to name a few. All these frameworks are powerful and flexible, they provide a way to build not only mocks, but stubs, fakes, and spies too.

I would **discourage you from using mocks**, and this is why I won't provide a code example for them.

With mocks you write tests for whether or not your object class certain methods of the mocked one. This kind of testing focuses on implementation rather than behaviour. It can be handy while TDDing certain components, or when you're dealing with massive legacy code you can't refactor yet, but in the long run it will make your tests rigid. Every time you'll change that method signature you'll have to update all the mock usages, not to mention the tests you'll have to rewrite if you'll remove the method.

I hope you don't think I'm a snob, throwing shit on the work of people using mocks. They're great tools, I just think there's a limited range of scenarios where they're the best one to use.

## Conclusion

To summarise:

- Use a **dummy** when you need a placeholder.
- Use a **fake** when you need the behaviour it provides for the test to run, but it doesn't affect the particular behaviour your are testing.
- Use a **stub** to control the input to the system under test so you can test how the behaviour changes according to it.
- Use a **spy** to record the output or effect produced by system under test on the double so you can verify it behaves as you'd expect.
- Try not to use mocks.

Being able to name things clearly gives us the power to talk about them more effectively. Using the appropriate name for your test doubles will make it easier for readers of your code to understand what the test is about.

If you want to talk more about test doubles in Swift [get in touch on Twitter](https://twitter.com/mokagio/) or leave a comment below.
