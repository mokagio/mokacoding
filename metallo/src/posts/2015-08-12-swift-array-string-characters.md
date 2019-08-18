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

To do so you can do:

```swift
"foo bar".map { String($0) }
```

or if you are into point free notation:

```swift
"foo bar".map(String.init)
```

There you go. 😎

---

For the record, this post dates back to Swift version 2. If you're into programming language archeology, checkout the original version [here](https://github.com/mokagio/mokacoding/blob/9430f994697210856e421d92e9e9652ed09da11e/metallo/src/posts/2015-08-12-swift-array-string-characters.md).
