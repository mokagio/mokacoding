---
title: Writing unit tests fast-tracks your learning curve
tags:
- Testing
- Learning
---

Recently, I had the priviledge of [taking part]() into a Q&A about testing with a class from the [Ray Wenderlich iOS bootcamp]().
We talked about the value of testing, code coverage, unit vs. UI testing, and Test-Driven Development.

Afterwards, I felt like I didn't do as good a job as I ought to have at explaining two core concepts: why writing unit tests is a critical advantage when learning a new technology and where to get started.

## Testing is the secret weapon of the learner

When you are learning a new programming language and getting familiar with the ecosystem of frameworks it offers, writing unit tests boosts your learning pace.
The reason for that has all to do with **the speed at which you get feedback** on the code you write.

In particular iOS programming, there is a lot of boilerplate you need to write before being able to interact with the code your are learning about.

For example, if you are learning how to use `URLSession` to fetch JSON data from an API and parse it using the `Decodable` protocol, you might need a list view to display the data on screen.
You _could_ write all the code in the `UIApplicationDelegate`, of course, and then use `print` to verify the result, but the long console logs are hard to read.
<!--
Using Playgrounds only gets you so far, too.
It's good for isolated components, but as the domain of your app grows, going back and forth between a Playground and your codebase becomes time consuming.
-->

If you start with unit tests instead, you don't need to write a single line of UI code, and can jump straight into experimenting with the code you actually want to learn about.

This is true when working on an existing app, too.
Rarely the feature you work on is part of the first screen in the app.
If you rely only on the UI to test your code, for every change you make you'll need to navigate through the UI to reach the point in which your code is used.
This is time consuming, and if you're like me, you'll quickly get frustrated when you navigated through five different screens only to realize you made a mistake in the code.

If you use unit tests as your feedback mechanism while implementing your features, you'll save a lot of time.
You'll only need to go through the UI at the very end of the process, for the final safety checks.

But why am I making such a big deal about the speed at which you get feedback on the correctness of your code?
At the end of the day, what matters is eventually having code that works, right?

What difference does it make if you get a lot of incremental feedback as you go, or only once when the feature is done?
As it turns out, a lot.

### Feedback speed matters

The late [Anders Ericsson]() was one of the world's authorities on the science of learning and dedicated his career to studying how people learn and how to become a top performer.
In his book [Peak: Secrets from the New Science of Expertise]() he and coauthor Robert Pool dive deep into the importance feedback has in the learning process.

One of the example they bring is a study done on radiologists.
...

Training radiologist in interpreting mammograms more effectively.
Didn't have the chance to "practice their readings over and over agan, getting accurate feedback with each attempt."
Build a digital library of mammograms to work as test question on whether a cancer is present or not to give trainees to work through.
If the trainee gave a wrong answer, the training program could display images with similar caracteristics, so that the doctor could drill on their weaknesses.

If getting feedback fast and in great quantity is a key part of effective learning, and unit testing is the best way to do so in the context of software, where do you begin writing tests?

## Where to begin writing tests

Writing unit tests can be a daunting task for beginner and experienced developers alike.
It's not always clear which code to test or where and when to start writing tests.

The good new is, **to learn the craft of testing, quantity matters more than quality**.
It doesn't matter if you write your tests after the fact or if you use Test-Driven Develpoment, nor whethere you start testing new code or add tests to code that was already in the codebase.
The learning comes from the act of trying to write a test itself.

In his book [Atomic Habits]() James Clear tells the story of ...

Over time, quantity produces quality —as long as you pair each implementation with feedback on its quality, which is exactly what writing tests does.

When writing tests for your code, notice how much setup code you had to write, whether or not you could verify the behavior with a single assertion, and how hard was it to identify which assertions to write.
The more you can perform these tasks with ease, the better you'll be getting at writing unit tests and testable code.

### Code that is simple to test

If you really want down to earth practical advice, start writing tests for those pieces of code that are [pure functions](), functions where the output depends only on the input.
Here's an example:

```swift
struct MarkdownFormatter {

  func formatBold(_ string: String) -> String {
    return "**\(string)**"
  }
}
```

```swift
import XCTest

class MarkdownFormatterTests: XCTestCase {

  func testFormattingStringBoldWrapsItInStars {
    // Arrange
    let formatter = MarkdownFormatter()
    let string = "any string"

    // Act
    let formatted = formatter.formatBold(string)

    // Assert
    XCTAssertEqual(formatted, "**any string**")
  }
}
```

Because the behavior of `formatBold(_:)`, wrapping the given string in `**`, depends only on its input, with no extra sources of information affecting it, such as shared instances, databases, or time affecting it, writing a test for it is rather straightforward.
Arrange the system under test and the input, act on it to generate the output, then assert the output is what you expect.

---

The speed at which you get feedback _does_ make a difference in the speed at which you learn a new programming language or framework.
Writing tests allows you to get faster feedback than if you were to build and navigate through an app's UI.

Testing might seem like a daunting task to get started with, there are a lot of unkwnowns and it feels like you are not writing useful code, code that actualy goes into your app.
The good news is that to learn about testing you just have to get started.
Don't worry about the quality of the tests itself.
It might feel awkward and hard in the beginning, but that's just the reality of learning a new skill.
The more tests you write and the more you listen to the feedback they give you, the easier it'll become to write them.

This is a flywheel, a positive loop that feeds itself making it easier and easier to keep going.
All you need to do is get the wheel spinning.

_If you want to chat about where to start writing tests, reach out on Twitter [@mokagio](https://twitter.com/mokagio)._
_If you want more posts on testing and productivity, and to learn about **my upcoming book on TDD in Swift**, hit [subscribe](#subcribe)._
_[Subscribe to my email list](#subscribe) to get more articles on testing and productivity, and to learn about my **upcoming book on TDD in Swift**._
