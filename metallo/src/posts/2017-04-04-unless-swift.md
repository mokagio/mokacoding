---
layout: post
title: "Unless.swift"
description: "Porting Ruby's unless operator into Swift via a function."
tags:
- Swift
- Espresso
---

[Ruby](https://www.ruby-lang.org/en/) is a programming language that prides itself of being [optimized for developer happiness](http://rubyonrails.org/doctrine/#optimize-for-programmer-happiness). Part of this optimization is on how close to natural language, or at least natural english, you can get when writing Ruby code.

One of my favourite features is `unless`.

```ruby
unless condition do
  something()
end
```

One could be tempted to say that Swift's `guard` is the same thing as Ruby's `unless`, but that's not the case.

```swift
guard condition else {
  something()
  return
}
```

`guard` is not simply a `if condition == false`, but a tool to **enforce early returns**. A `guard` statement will not compile without a `return`.

For this reason I hacked together a Swift version of unless. As you can imagine the code is pretty simple:

```swift
func unless(_ condition: () -> Bool, do closure: @escaping () -> ()) {
  guard condition() == false else {
    return
  }

  closure()
}
```

You can find the whole code [on GitHub](https://github.com/mokagio/Unless.swift).

I made it as a Swift Package, but I would advise against using it that way. After all, what's the point of having syntax sugar that should make your job easier if you have to `import` it for every file?

Much better to simply copy the code, **and [its tests](https://github.com/mokagio/Unless.swift/blob/master/Tests/UnlessTests/UnlessTests.swift)** so that it's part of your Swift module.

Get in touch on Twitter [@mokagio](https://twitter.com/mokagio) if you have any feedback, are using this little piece of code, or want to chat about syntax sugar and how it can make our code more readable and us more productive.

_Leave the codebase better than you found it._
