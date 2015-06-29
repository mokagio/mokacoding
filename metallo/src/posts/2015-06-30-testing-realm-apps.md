---
layout: post
title: Testing Realm apps
description: "Realm is a mobile database that, unlike CoreData, is easy to test. In this post we will discuss some ideas on how to test an app using Realm as its database."
tags:
- Testing
---

In this post we will consider a couple of different approaches to testing an app's data layer using [Realm](https://realm.io), looking at the design of the components involved, and doing a simple benchmark of the in-memory vs on-disk approach.

The purpose of this post is not to discredit the approach suggested by [the documentation](https://realm.io/docs/swift/latest/#testing), but rather open a discussion around it.

## Realms, and pizza

In case you don't know about it, [Realm](https://realm.io) is a database designed for mobile devices. It has [open source binding for iOS and OS X](https://github.com/realm/realm-cocoa/), and [Android](https://github.com/realm/realm-java). It's pretty neat, and works well with Swift.

We won't go in the details of Realm here, but you should really have a look at [their docs](https://realm.io/docs/swift/latest/api/index.html).

Now, let' imagine a very simple all, PizzaApp 🍕. With PizzaApp you can track your favourite pizzas offline, so even when there's no connection you can always browse them.

This is how a pizza model looks like:

```swift
import RealmSwift

class Pizza: Object {
  public dynamic var name = ""
  public var ingredients = List<Ingredient>()
}
```

And this is how we can store a pizza in the database, or in other words adding it to the realm:

```swift
func save(pizza: Pizza) {
  let realm = Realm() // <- the default realm
  realm.write {
    self.realm.add(pizza)
  }
}
```

## Writing tests

One simple way to start testing the `save` code is to assert that after it has been called the count of `Pizza` objects in the realm is increased by 1.

```swift
class PizzaControllerInMemorySpec: QuickSpec {
  override func spec() {
    describe("PizzaController") {
      beforeEach { /* code to setup a test realm */ }

      afterEach { /* code to tear down a test realm */ }

      it("adds the Pizza to the Realm") {
        expect(testRealm.objects(Pizza).count).to(equal(0))

        let p = Pizza()
        p.name = "Margherita"
        sut.addPizza(p)

        expect(testRealm.objects(Pizza).count).to(equal(1))
      }
    }
  }
}
```

The [testing documentation](https://realm.io/docs/swift/latest/#testing) suggests two way to test the code that interacts with a realm.

The first is to change the `Realm.defaultPath` to one used only for testing. The problem with this approach is that it assumes that we are always going to use the default Realm, while this may not be the case. We might for example spin up a temporary realm, persist changes on that, and only merge on the main realm if the user confirms the changes.

The second approach solves this issue by suggesting to pass a realm instance to every method that needs to interact with it. Our `save` method would then have to be changed in `save(pizza: Pizza, onRealm realm: Realm)`. That would mean that the consumer of such API would always need to be aware of the realm. We can do better.

A possible alternative is to have a realm manager/controller/service that can be initialized with a realm instance, and only works with it.

```swift
import RealmSwift

class PizzaController {
  let realm: Realm!

  init(realm: Realm) {
    self.realm = realm
  }

  init() {
    self.init(realm: Realm())
  }

  func addPizza(pizza: Pizza) {
    realm.write {
      self.realm.add(pizza)
    }
  }
}
```

With this we have the best of both worlds. The _normal_ consumer doesn't need to know about Realm, and can use the `PizzaController()`. _Special_ consumers, like the unit tests or contexts in which a secondary realm need to be put in place, can use `PizzaController(realm: Realm)`.

When looking at the interface of `PizzaController()` we immediately see it depends on `Realm`, there are no hidden dependencies, no surprises. This is one of the simplest form of [dependency injection](http://martinfowler.com/articles/injection.html).

Let's now look at how to use an **in-memory realm** to speed up the unit tests.

```swift
import Quick
import Nimble
import RealmSwift
import testing_realm

class PizzaControllerInMemorySpec: QuickSpec {
  override func spec() {
    describe("PizzaController") {
      var testRealm: Realm!
      var sut: PizzaController!

      beforeEach{
        testRealm = Realm(inMemoryIdentifier: "pizza-controller-spec")
        sut = PizzaController(realm: testRealm)
      }

      afterEach {
        testRealm.write {
          testRealm.deleteAll()
        }
      }

      it("adds the Pizza to the Realm") {
        expect(testRealm.objects(Pizza).count).to(equal(0))

        let p = Pizza()
        p.name = "Margherita"
        sut.addPizza(p)

        expect(testRealm.objects(Pizza).count).to(equal(1))
      }
    }
  }
}
```

_Note:_ the test above is far from being comprehensive, the point we're trying to make is on the setup.

## Benchmark: on-disk vs in-memory

Now you could argue that there is no big difference between the test above and one using a realm on disk dedicated to testing.

Let's look at a simple benchmark. On MacBook Pro 2.8 GHz Intel Core i7, 16 GB 1600 MHz DDR3, Flash Storage, running the test suite on an iOS Simulator we get these results:

* **100 accesses** in memory ~0.05 seconds vs on disk ~0.08 seconds
* **1000 accesses** in memory ~0.20 seconds vs on disk ~0.41 seconds
* **10000 accesses** in memory ~1.72 seconds vs on disk ~4.66 seconds

Where 1 access = setup the realm, do one write to the realm, tear down the realm.

So as you can see, the difference in the time becomes relevant only when dealing with more than hundreds of _accesses_ to the realm when testing, which is probably not a realistic scenario.

Nevertheless, since every fraction of second matters, we'd recommend to go with the in-memory realm.

## Conclusion

We've seen different approach to designing and testing a component responsible of persisting data on a Realm, and how designing it in a way to accept an in-memory Realm not only allows for faster unit tests, but to more flexible use too.

You can find the example code for [PizzaApp on GitHub](https://github.com/mokacoding/unit-test-in-memory-realm-example). Please reach out if you find different results while running the benchmark.

I hope you enjoyed this post, if you have any comments, correction or suggestion please use the form below or tweet me [@mokagio](https://twitter.com/mokagio).

Finally I really want to thanks the [Realm](https://realm.io) team for the amazing software they are building, the example they are setting as an open source by default company, and the work they're doing in the community, hosting events and sharing the videos so that everyone can enjoy them. Thanks!

_Happy coding, and leave the codebase better than you found it._
