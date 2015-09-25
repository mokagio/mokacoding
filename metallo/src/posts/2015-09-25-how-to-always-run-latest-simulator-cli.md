---
layout: post
title: How to always use the latest Simulator with Xcodebuild
description: There is a simple keyword you can use in the destination option of an xcodebuild command to always run the most recent Simulator version.
tags:
  - Xcode
  - Automation
  - Espresso
---

Does your script running `xcodebuild` break every time you update Xcode because the Simulator version you were pointing at is not there anymore? No worries, there is a simple keyword you can use in the `destination` option to always run the most recent Simulator version.

```
xcrun xcodebuild \
  -workspace Bench.xcworkspace \
  -scheme BenchUITests \
  -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest' \
  -sdk iphonesimulator \
  test
```

`OS=latest` does the trick 👍.

_Happy coding, and leave the codebase better than you found it._
