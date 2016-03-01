---
layout: post
title: "Using Swift protocols to abstract third party dependencies and improve testability"
description: "Third party code can be hard to test, but you can use Swift's protocols to abstract its details and improve testability"
tags:
- testing
- swift
---

Every application has to deal with third party code sooner or later. Third
party code is code you cannot control, it could be a library used for
analytics, or even a class of Foundation.

The problem with third party code is that it makes writing tests harder.

For example consider [`NSHTTPCookieStorage`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSHTTPCookieStorage_Class/),
this class doesn't provide any initialization method apart from `sharedHTTPCookieStorage()`.
In fact:

> `NSHTTPCookieStorage` implements a singleton object (shared instance) that manages storage of cookies.

How do you test code that depends on this component in isolation?

One option you have is to use the shared instance and always makes sure any
test data you put into it is removed once the tests are finished. This option
is slow and error prone.

A better option is to use a protocol to abstract the dependency and gain more
control on your tests.

```swift
protocol CookieProvider {

	func cookieWithName(name: String) -> NSHTTPCookie?

	func setCookie(cookie: NSHTTPCookie)

	func deleteCookieWithName(name: String)
}
```

The components depending on the cookie storage will now expect an instance
conforming to the `CookieProvider` protocol rather that specifying and actual
class.

```swift
class NetworkClient {

	let cookiesProvider: CookieProvider

	init(cookiesProvider: CookieProvider) {
		self.cookiesProvider = cookiesProvider
	}
}
```

In your tests you can implement a test double cookie provider able to return
a cookie set by you, and to store a cookie in memory so that you can verify
if.

```swift
class CookieProviderTestDouble: CookieProvider {

	var cookies: [NSHTTPCookie]?

	func cookieWithName(name: String) -> NSHTTPCookie? {
		return cookies
			.filter { $0.name == name }
			.first
	}

	func setCookie(cookie: NSHTTPCookie)
		self.cookies.append(cookie)
	}

	func deleteFooBarCoockie() {
		guard let cookie = cookieWithName(name) else {
			return
		}

		deleteCookie(cookie)
	}
}
```

You can then init the `NetworkClient` using the test double:

```swift
let cookiesProvider = CookieProviderTestDouble()
let systemUnderTest = NetworkClient(cookiesProvider: cookiesProvider)
```

This will empower you to test the network client behaviour that depends on the
value of a cookie by simply setting it in your `CookieProviderTestDouble`
instance, as well as testing behaviour that results in a cookie being stored
by checking the values in the `.cookies` property of the test double.

In your production code you will then have to extend `NSHTTPCookieStorage` to
conform to `CookieProvider`:

```swift
let apiURL: NSURL = ...

extension NSHTTPCookieStorage: CookieProvider {

	func cookieWithName(name: String) -> NSHTTPCookie? {
		return cookiesForURL(apiURL)?
			.filter { $0.name == name }
			.first
	}

	// A method called setCookie is already exposed by NSHTTPCookieStorage.
	// Less work :)

	func deleteCookieWithName(name: String) {
		guard let cookie = cookieWithName(name) else {
			return
		}

		deleteCookie(cookie)
	}
}
```

## Pros

This approach simplifies testability, and potentially makes your unit tests
faster in case the third party code you are dealing with performs I/O operations.

Another great benefit you get by using protocols is that you can focus on the
function of the dependency rather that its implementation. For example when
using `NSUserDefaults` to store the theme color preference of the user you can
use a protocol named `ThemeColorProvider`. When reading code using the
`ThemeColorProvider` it will be clear what this component does.

## Cons

An important thing to be aware of is that since you are not using the real
object in your tests, but rather a double that exposes the same interface, you
expose yourself to the risk of bugs in the implementation of the real object.

For this reason I recommend using this approach only when depending on third
party code that you cannot control, and that you are confident is well written
and tested.

_Leave the codebase better than you found it._
