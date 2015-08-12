---
layout: post
title: Swift array of characters from String
description: "How to get an array of single characters String from a multiple characters String. From foobar to [f, o, o, b, a, r]."
tags:
- Swift
- Espresso
---

Sometimes you might need to get an array of characters out of a String, for example:

```
"foo bar" => ["f", "o", "o", " ", "b", "a", "r"]
```

This used to be trivial in Swift 1.x, but became slightly more tedious in Swift 2:

```swift
"foo bar".characters.map { String($0) }
```

There you go. 😎
