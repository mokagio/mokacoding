---
layout: post
title: Getting Started With OHHTTPStubs
description: "Good unit tests are fast and deterministic. Testing code that hits the network could undermine this goal, but using OHHTTPStubs we can take back control of our tests. This post explores the advantages of stubbing the network, and provide a guide on how to do it with OHHTTPStubs."
tags:
- Testing
- iOS
---

In the [previous post](http://www.mokacoding.com/blog/why-hitting-the-network-is-bad-for-your-tests/)
I tried to show the importance and the benefits of decoupling your unit tests
from the network, and suggested ways to achieve that. In this new post of the
Practical Testing in Swift series we'll look at a concrete implementation.

In short, stubbing network requests in your unit tests will provide you with
faster and more reliable tests, make them deterministic, and allow more testing
of error and edge cases.

One option to remove the dependency from the network is to use a network
stubbing library, and among those [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs)
is one the most elegant.

This library developed by [Olivier Halligon](https://twitter.com/aligatr)
allows you to specify criteria on which to match URL requests leaving the app,
and hijack them providing a custom response.

You can integrate OHHTTPStubs in your test target in the usual ways,
[CocoaPods](http://cocoapods.org/), [Carthage](https://github.com/carthage/carthage),
or manually.
_[Let me know](https://twitter.com/mokagio) if you need help with the process_.

## The API

An OHHTTPStubs stub instruction has this structure:

```swift
stub(/* your stub criteria */) { request in
  return /* your response */
}
```

There are two pieces that form the stub instruction, the criteria to use to
evaluate whether or not a request made by the app should be hijacked, and the
stubbed response to return. For example:

```swift
stub(isMethodGET()) { _ in
  return OHHTTPStubsResponse(
    JSONObject: ["key": "value"],
    statusCode: 200,
    headers: [ "Content-Type": "application/json" ]
  )
}
```

Will intercept any GET request and return a simple JSON object `{ "key": "value" }`.
Another example:

```swift
stub(isHost("api.myserver.com") && isPath("/resource")) { _ in
	guard let path = OHPathForFile("success_resource_response.json", self.dynamicType) else {
			preconditionFailure("Could not find expected file in test bundle")
	}

	return OHHTTPStubsResponse(
			fileAtPath: path,
			statusCode: 200,
			headers: [ "Content-Type": "application/json" ]
	)
}
```

Will intercept any request towards `api.myserver.com/resource` and return
the content of the JSON file `success_resource_response.json` located in the
test bundle.

```swift
stub(isPath("/foo/bar")) { _ in
	let error = NSError(
		domain: "test",
		code: 42,
		userInfo: [:]
	)
	return OHHTTPStubsResponse(error: error)
}
```

Will stub any request with path "`/foo/bar`" and make it fail returning an
`NSError` with domain `test` and code `42`.

This last request is very useful when testing that our network logic handles
failures properly. Testing failures is not as simple when interacting with a
real server.

You can read more about the possibilities offered by the library in the
[Usage Examples](https://github.com/AliSoftware/OHHTTPStubs/wiki/Usage-Examples)
Wiki page.

## In Practice

Let's imagine we have an `APIClient` service class with a method
`getResource(withId: String, completion: (resource: Resource?, error: ErrorType?) -> ())`
which would go off to the server and fetch the `Resource` object with the given
id. If the request succeeds the completion function will be executed with the
serialized `Resource` and no error, if it fails the resource will be `.None`,
and the `error` will have the value of the received network or server error.
Pretty standard networking code.

Here's a possible test for the behaviour of `APIClient` when the request
succeeds:

```swift
func testGetResourceSuccess() {
  // Arrange
  //
  // Setup network stubs
  let testHost = "te.st"
  let id = "42-abc"
  let stubbedJSON = [
    "id": id,
    "foo": "some text",
    "bar": "some other text",
  ]
  stub(isHost(testHost) && isPath("/resources/\(id)")) { _ in
    return OHHTTPStubsResponse(
      JSONObject: stubbedJSON,
      statusCode: 200,
      headers: .None
    )
  }
  // Setup system under test
  let client = APIClient(baseURL: NSURL(string: "http://\(testHost)")!)
  let expectation = self.expectationWithDescription("calls the callback with a resource object")

  // Act
  //
  client.getResource(withId: id) { resource, error in

    // Assert
    //
    XCTAssertNil(error)
    XCTAssertEqual(resource?.id, stubbedJSON["id"])
    XCTAssertEqual(resource?.aProperty, stubbedJSON["foo"])
    XCTAssertEqual(resource?.anotherPropert, stubbedJSON["bar"])

    expectation.fulfill()
  }

  self.waitForExpectationsWithTimeout(0.3, handler: .None)

	// Tear Down
	//
  OHHTTPStubs.removeAllStubs()
}
```

The test is split in four steps, we start by arranging the inputs for the test
and configuring the system under test (sut), we then act and assert that the
sut behaved as expected, and finally we tear down any kind of non transient
modification we made.

In the arrange step we use `OHHTTPStubs` to hijack any network request to the
resource API endpoint, and return a dictionary that we previously initialized.

In the assert step we make sure of two things: first that `APIClient` actually
runs the completion function passing a non nil resource object, and a nil
error; second that the receive `Resource` is built using the data from the
network.

Finally in the tear down step we make sure that all the stubs set in this test
are removed, so that the next tests will find a pristine environment.

Manually building the dictionary for the stubbed response in the test is handy
because it makes clearer where the values that we expect our `Resource` to be
initialized with came from, but it might be cumbersome if the properties are
more than a handful.

In such cases I prefer using a `.json` file as the stubbed response, thanks to
the `OHHTTPStubsResponse(fileAtPath:, statusCode:, headers:)` method we saw
before. This approach adds a mental step that the reader of the test has to
make when looking at the assertions on the state of the received object, but
greatly improves the maintainability of the tests.

Other good side effects of this approach are that the same `.json` can be used
multiple times or in multiple tests, and that if you download your JSON stub
files from the server you have a test case that is closer to the "real life".

I will let it up to you to write the failure test using OHHTTPStubs. Or you
can check out the [example project](https://github.com/mokacoding/OHHTTPStubsExample)
to see how I would write it.

---

I hope to have convinced you of the importance of decoupling yourself from the
network in your tests, and showed you how simple it is to do so using OHHTTPStubs.

[OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) is a great library
with a lot to offer, and [very well documented](https://github.com/AliSoftware/OHHTTPStubs/wiki),
you should really try it.

If you need help with your network stubs, or want to talk more about how to
stub the network in your tests [get in touch on Twitter](http://twitter.com/mokagio)
or leave a comment below.

On other news: I started a podcast, is called [TIL](https://www.briefs.fm/til)
and I share daily(ish) tips on testing, automation, and general software
development. I would really appreciate feedback on it, so please head over to
[https://www.briefs.fm/til](https://www.briefs.fm/til) an let me know what you
think.

