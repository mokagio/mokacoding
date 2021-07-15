---
title: Test-Driven Development in Swift is now available
description: My book, Test-Driven Development in Swift, is now available in online bookstores everywhere. You'll learn Test-Driven Development writing a real-world SwiftUI application, including events-flow management with Combine, networking, local storage, and third-party libraries.
og_description: Learn TDD by building a real-world SwiftUI application
tags:
  - Books
  - TDD
  - Swift
  - XCTest
og_image: https://s3.amazonaws.com/mokacoding/tdd-in-swift-promo.jpg
---

**[_Test-Driven Development in Swift_](https://tddinswift.com) is now available on [Apress](https://www.apress.com/gp/book/9781484270011), [Amazon](https://geni.us/I3rxSNk), and anywhere else you get your books.**

![A picture of the paperback version of the book](https://s3.amazonaws.com/mokacoding/tdd-in-swift-promo.jpg)

[_Test-Driven Development in Swift_](https://tddinswift.com) is the culmination of a decade of practicing, researching, [writing](https://mokacoding.com/archive), and [speaking](https://gio.codes/talks) about TDD.
It's the book I wish I had when starting out: a practical, step-by-step course on how to write iOS applications using Test-Driven Development.

But don't take it from me! Here's what early readers are saying about the book:

> Structured in just the right way to help you grasp the complicated topic of Test-Driven Development. With detailed descriptions of concepts and ideas alongside coding examples, it gives you everything you need to grow your testing skills.

<!-- > – Charlie Scheer, iOS Developer @ [Automattic](https://automattic.com) -->

> If you’re unfamiliar with Test-Driven Development, this book is a great introduction, building up one clear example at a time. If you are familiar with TDD, the book will teach you the testing toolkit you should be using in Swift.

<!-- > – [Adam Johnson](https://adamj.eu/), Python Testing Expert -->

> As I was working through the book, one of the things it taught me very early on, which I realized that I had been kinda doing, but I was just failing because I wasn't thinking about it the right way, was how to break things down into small chunks of solvable problems.

<!-- > – Peter Witham, [Compile Swift](https://www.compileswift.com/podcast/s03-e03/). -->

What makes this book unique is that it approaches TDD in **SwiftUI and Combine**.

You'll learn why the best way to test a SwiftUI app is _not to_ test SwiftUI code and what to do instead. (Hint: put all the logic into a pure Swift object and use TDD on it).

You'll see how to leverage the synergy between SwiftUI and Combine to offload all the heavy lifting of keeping views in sync with dynamic data, and how to test the thin code layer that transforms backend data into presentation data.

You'll discover the different kinds of Test Doubles, test-specific equivalent of production code dependencies, and when and how to use them.

If you're like me, you like to sample before committing.
On the publisher's [site](https://www.apress.com/gp/book/9781484270011), you can get a preview of the first pages of each chapter, and all the code from the book is available [on GitHub](https://github.com/Apress/Test-Driven-Development-in-Swift).

Each chapter answers a practical question, such as "How do you use Test-Driven Development for the view layer when there is no straightforward way to test SwiftUI views?", "How do you write tests for code interfacing with the network?" and "How do you apply TDD to change the behavior of existing code?" in the concrete landscape of a real-world application.

And even though the book focuses on writing tests for a SwiftUI application with vanilla XCTest, it comes with appendixes on how to apply the same concepts to tests written [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble) or UIKit applications.

I'm super excited to finally be able to share [_Test-Driven Development in Swift_](https://tddinswift.com) with you.
I hope you'll check it out and can't wait to hear what you think!
Get in touch by leaving a comment below or via Twitter at [@mokagio](https://twitter.com/mokagio).
