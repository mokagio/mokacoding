---
title: NSDateFormatter format for JSON dates
description: How to configure NSDateFormatter to work with JSON API dates.
tags:
- Swift
- Foundation
- JSON
- Espresso
---

_I always had to look this up, so I though I should write a little memo post about it_ 😊.

As mobile developer we often have to work with JSON APIs, and they often have
dates.

JSON itself doesn't have a date type, so dates are represented as strings. The
standard way to formate date strings in JSON is to use the same format as
Javascript's `Date`
[`toJSON`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toJSON)
method, whic is [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) compliant.

```
2016-05-11T19:02:16.238Z
```

Here's how to configure `NSDateFormatter` to handle this date format:

```swift
import Foundation

extension NSDateFormatter {

  static func formatterForJSONDate() -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return formatter
  }
}
```

And here's a test for it:

```swift
func testProperty() {
	let now = NSDate()
	let nowToJSON = sut.stringFromDate(now)
	XCTAssertEqualWithAccuracy(sut.dateFromString(nowToJSON)!.timeIntervalSince1970, now.timeIntervalSince1970, accuracy: 0.001)
}
```

_Leave the codebase better than you found it._
