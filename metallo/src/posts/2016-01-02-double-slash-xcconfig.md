---
layout: post
title: How to use a double slash in xcconfig files
description: "A short post showing how to use a double slash in xcconfig files, for example to write URLs like http://mokacoding.com"
tags: [ Xcode, Espresso ]
---

_This is the first Espresso post of 2016 🎉_

If you are not using [xcconfig files](https://pewpewthespells.com/blog/xcconfig_guide.html) to manage your configurations you are missing out. They greatly simplify configuration management, are easy to in a `git diff`, and you can also specify which xcconfig to use as a parameter when using `xcodebuild`.

There is a problem though, the syntax in which to write xcconfigs files is not very powerful.

A common issue is being unable to write URLs due to the double slash in "http://" being interpreted as a comment.

This is my solution:

```
SLASH = /
URL = https:$(SLASH)/mokacoding.com
```

It looks ugly and silly, but it does work.

Let me know if you have better options, or how this approach works out for you.

_Leave the codebase better than you found it._
