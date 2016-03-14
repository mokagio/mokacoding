---
layout: post
title: Why hitting the network is bad for your test, and what to do about it
description: "In this post we are going to look at why hitting the network from your unit tests is a bad thing, and introduce some way to solve the problem."
tags:
- Testing
---

Most of our iOS application have to interact with at least one server or
service through _the network_. The amount of apps consuming web services is
only bound to grow.

When testing code that hits the network you expose yourself to all sort of
problems, such as delays, timeouts, unexpected failures.

## Why depending on the network is bad

One of the testing mantras is [**FIRST**](https://pragprog.com/magazines/2012-01/unit-tests-are-first).
Tests should be fast, isolated, replicable, self-verifying, timely. Reaching
out to the network goes against some of these principles.

### Slow

Having your tests hit the network adds the network speed as a constraint
to how fast your tests can run, hence how quick your feedback cycle is.

### Nondeterministic

Having your tests hit the network also adds a dependency on the data returned
by the server. You can never be sure that the data returned is actually what
you are expecting, unless you started a dedicated server only for the test
purpose.

These two factors degrade the quality and reliability of your tests. Tests
could time out because the network was particularly congested in that moment,
or return unexpected data because the backend team run a migration on the
staging server without notifying you.

### Harder to test for error scenarios

Let me ask you a question: "how would you go about testing the behaviour of
your networking components in failure scenarios?"

When interacting with a real server is not easy to get a failure. Maybe you can
easily generate a 404, but what about a 500 or other errors? What about
responses with unexpected data?

Testing our components behaviour when dealing with failures and unexpected input
is as important, if not more, as testing the happy path. Depending on the network
makes this task hard to accomplish.

Those are some of the reason why you should always decouple yourself from the
network when writing unit tests. Now let's see how to do it.

## How to decouple from the network in your unit tests

Think of the network as something your system uses, a dependency. As with other
dependencies there are techniques to decouple from it. In the case of the network
you have at least two options: using a stub library, or fake the network yourself.

### Use a library

In the iOS and Mac development world you can use libraries like [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs)
or [Nocilla](https://github.com/luisobo/Nocilla) to hijack network requests
made by your app and prevent them from hit the real server by providing a
stubbed response.

Head over to [the next post](http://mokacoding.com/blog/ohhttpstubs/) for a
deeper look into OHHTTPStubs.

### Roll your own

Another option is to centralise all the network operations behind one single
interface conforming to a protocol, for example:

```swift
protocol NetworkService {
  func performRequest(
		url: NSURL,
		method: Method,
		parameters: [String: AnyObject]?,
		comptletion: ([String: AnyObject]?, NSError?)
  )
}
```

All the components that need to interact with the network should be initialized
with an instance of an object conforming to the `NetworkService` protocol to
use for their requests.

In your tests you can create a [fake](http://xunitpatterns.com/Fake%20Object.html)
network service conforming to `NetworkService` and returning the response data
you want rather than hitting the network.

We'll look more into using a fake in an upcoming post.

---

I hope to have convinced you of the importance of decoupling yourself from the
network in your tests, and intrigued you with the options you have to do so.

If you need help with your network stubs, or want to talk more about how to
stub the network in your tests [get in touch on Twitter](http://twitter.com/mokagio)
or leave a comment below.

On other news: I started a podcast, is called [TIL](https://www.briefs.fm/til)
and I will shared daily(ish) tips on testing, automation, and general software
development. I would really appreciate feedback on it, so please head over to
[https://www.briefs.fm/til](https://www.briefs.fm/til) a let me know what you think.


