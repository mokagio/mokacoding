---
title: "How XcodeGen reduced the TDD in Swift codebase by 58,000+ lines"
description: "A code generation story."
og_image: https://mokacoding.s3.amazonaws.com/2024-10-03-xcodegen-diff.png
tags:
  - Swift
  - Xcode
  - Books
---

I'm in the middle of tidying up the [_Test-Driven Development in Swift_][tddswift] chapters [sources](https://github.com/Apress/Test-Driven-Development-in-Swift).

One of the first things I did was set up [XcodeGen](https://github.com/yonaskolb/XcodeGen).
Thanks to it, I removed more than 58,000 lines between Xcode project files, `xcschemes`, and duplicated sources.

Needless to say, I'm very pleased to see all that cruft go.
Here's what I did, and while few projects are set up like a book's chapters sources repository, I think my experience will show the benefits of using a tool to generate the Xcode project and of code-generation more broadly.

## Twenty-seven projects to update

A lot has changed in Apple development since _Test-Driven Development in Swift_ hit the shelves in 2021.
SwiftUI has matured.
Async/await has replaced Combine to manage most asynchronous or concurrent operations.
Apple released a new Swift-native testing framework, which is a pleasure to use.
_Xcode's Vim mode finally supports relative line numbers and the `.` operator!_

With all this novelty, it might be time to dust off the [book's examples code](https://github.com/Apress/Test-Driven-Development-in-Swift) and see how much they can improve.

The core twelve chapters of _Test-Driven Development in Swift_ chronicle the development of a quasi-real-world app.
Each chapter builds on top of the code implemented in the previous one.
For each, the chapter sources repo offers a "start" and "end" project.
Readers can use the start project to code along or jump straight into the end project to explore the result.

There are also sources for the three appendixes, for a total of twenty-seven Xcode projects.

When I created the repo, I went through each project starting from scratch like a reader would.
It made sense while writing the book, but the thought of updating them all now made me shiver.

If only there was a way for each project to inherit the code it needs from the previous ones...
Enter [XcodeGen](https://github.com/yonaskolb/XcodeGen).

# XcodeGen

XcodeGen lets you describe an Xcode project in a YAML file, much like you define a Swift package in `Package.swift`.
You can then run `xcodegen generate` to generate the `xcodeproj` folder with `project.pbxproj`, `xcshareddata`, and everything else your software needs to run.

The best thing is, given the project folder is code-generated based on the YAML configuration, you don't need to check that monster of a file into Git!
This reduces diff sizes, highly reduces the chance of merge conflicts, such as when both your branch and the main one add files to the project, and overall makes the project structure much easier to understand.

Here's the config file for the project at the beginning of the book:

```yml
# 04-tdd-in-the-real-world/1-end/project.yml

name: Albertos
options:
  bundleIdPrefix: com.mokacoding.Albertos
targets:
  Albertos:
    type: application
    platform: iOS
    sources: [Albertos]
    info:
      path: Albertos/Info.plist
      properties:
        UILaunchScreen:
          UIRequiredDeviceCapabilities: [armv7]
    scheme:
      testTargets: [AlbertosTests]
  AlbertosTests:
    target: Albertos
    type: bundle.unit-test
    platform: iOS
    sources: [AlbertosTests]
    settings:
      CODE_SIGNING_ALLOWED: NO
    dependencies:
      - target: Albertos
```

Those twenty-three lines are all we need to generate the eight-hundred-plus `project.pbxproj` file plus the `xcscheme` to run it.

Notice the `sources` node is an array: You can add as many paths or folders as you need.
Plus, `xcodeproj` supports splitting configurations into multiple files and inheriting options, which is great for organizing projects with many targets.

Thanks to XcodeGen, the projects for each chapter can specify the Swift files for the parts of the app and tests they changed while inheriting the rest from the previous chapters.

Here is the `sources` node for the project after completing Chapter 6:

```yml
# 06-testing-static-swiftui-views/1-start/project.yml

sources:
  # Use the MenuGrouping implementation from Chapter 4.
  - ../../04-tdd-in-the-real-world/1-end/Albertos/MenuGrouping.swift
  # Use the same menu dummy value as defined at the start of the chapter.
  - ../0-start/Albertos/Menu+Dummy.swift
  # All the other sources are custom and live in the project-specific folder
  - Albertos
```

If the start of a chapter has the same code as the end of the previous chapter, it can inherit the whole project configuration from it.

```yml
# 07-testing-dynamic-swiftui-views/0-start/project.yml

include:
  - ../../constants.yml
  - ../../06-testing-static-swiftui-views/1-end/project.yml
```

<!--
## Code-Generation

Code-generation is a technique to maximize the information-scaffold ratio of your source code.

You don't need me to tell you that not all code is the same.
There's code that _does stuff_, there's code that _tests stuff_.
Some code implements the _how_ of the app, other code the _what_.

The _what_ code is usually configuration code and can have a low information-scaffold ratio.

Imagine an app that displays reviews on the authentication screen.

```swift
extension Review {
  static let all = [
    Review(message: "Awesome", author: "Alice"),
    Review(message: "Brilliant", author: "Bob"),
    Review(message: "Charming", author: "Carol")
  ]
}
```

The information code, in the form of the message-author string pairs, is embedded in as much scaffold code.

By contrast, a CSV with the message-author pairs has maximum information and zero scaffolding.

```CSV
Awesome, Alice
Brilliant, Bob
Charming, Carol
```

With code-generation, we can keep the data in the CSV file and have a script or tool derive the `Review.all` implementation for us at build time.

Now, when you look at the code, you can focus on the information without distracting scaffolding.
-->

Using `xcodegen` to code-generate the many projects and inherit sources from chapter to chapter resulted in a [whopping 58,724 deletions](https://github.com/Apress/Test-Driven-Development-in-Swift/compare/v1.0.0...744697aac33f8ee3d15b5172f4e1df6bfa663e17) from the repository.

And while the Test-Driven Development in Swift chapter sources repo is quite unique, I hope this gives you an idea of the benefits a code-generation tool can bring to your project.

## Code-generate all the things!

If you want to explore the topic more, check out:

- [XcodeGen](https://github.com/yonaskolb/XcodeGen) and [Tuist](https://tuist.io) to code-generate the Xcode project.
- [SwiftGen](https://github.com/SwiftGen/SwiftGen) to code-generate constants for colors, fonts, localizable strings, and more.
- [Sourcery](https://github.com/krzysztofzablocki/Sourcery) to code-generate various types of sources using templates.

[tddswift]: https://tddinswift.com
