---
title: Writing unit tests fast-tracks your learning curve
tags:
- Testing
- Learning
---

Recently, I had the privilege of [taking part]() in a Q&A session on testing with a class from the [Ray Wenderlich iOS bootcamp]().
We talked about the value of testing, code coverage, unit vs. UI testing, and Test-Driven Development.

Afterwards, I felt like I didn't do as good a job as I ought to have at explaining two core concepts: why writing unit tests is a critical advantage when learning a new technology and where to get started.

## Testing is the secret weapon of the learner
## _need better title_

When you are learning a new programming language and getting familiar with its ecosystem of libraries, writing unit tests will boost your learning pace.
The reason for that has all to do with **the speed at which you get feedback** on the code you write.

When it comes to iOS programming in particular, there is often a lot of boilerplate you need to write before being able to actually write the code for the concepts you are learning about.

For example, if you are learning how to use `URLSession` to fetch JSON data from an API and parse it using the `Decodable` protocol, you might need a list view to display the data on screen.
You _could_ write all the code in the `UIApplicationDelegate`, of course, and then use `print` statements to verify the result, but the long console logs are hard to read.
<!--
Using Playgrounds only gets you so far, too.
It's good for isolated components, but as the domain of your app grows, going back and forth between a Playground and your codebase becomes time consuming.
-->

If you start with unit tests instead, you don't need to write a single line of UI code, and can jump straight into experimenting with the code you actually want to learn about.

This is true when working on an existing app as well.
Rarely the feature you work on is part of the first screen in the app.
If you rely only on the UI to test your code, for every change, you'll need to launch and interact with your app until you hit the code path you are working on.
This is time consuming and, if you're like me, you'll quickly get frustrated after navigating through five different screens only to realize you made a mistake in the code.

If you use unit tests as your feedback mechanism while implementing your features, you'll save a lot of time.
You'll only need to go through the UI at the very end of the process, for the final safety checks.

But why am I making such a big deal about the speed at which you get feedback on the correctness of your code?
At the end of the day, what matters is eventually having code that works, right?
What difference does it make if you get a lot of incremental feedback as you go, or only once when the feature is done?
As it turns out, a lot.

### Feedback speed matters

The late [Anders Ericsson]() was one of the world's authorities on the science of learning and dedicated his career to studying how people learn and how to become a top performer.
In his book [Peak: Secrets from the New Science of Expertise]() he and coauthor Robert Pool dive deep into the key role of feedback in the learning process.

In the book, Ericsson takes a look at how radiologists interpret X-rays.
The problem with X-ray diagnosis is that the radiologists performing them seldom have the chance to learn whether they were right or wrong.
To compensate for this lack of feedback in real-world diagnosis, doctors have built training software with digital libraries of X-rays for which the outcome is known.
Trainees are presented with an X-ray to diagnose and immediately discover whether they were correct.
The software can also load cases with features similar to the ones each trainee got wrong, to drill into the diagnosis areas in which they are weaker.
[A study](https://journals.lww.com/academicmedicine/Fulltext/2011/06000/How_Much_Practice_Is_Enough__Using_Learning_Curves.25.aspx) shows that the accuracy of the trainees diagnosis demonstrably increases as they go through this kind of libraries, and the data trend suggests it would keep increasing with bigger libraries.

If getting feedback fast and in great quantity is a key part of effective learning, and unit testing is the best way to do so in the context of software, where do you begin writing tests?

## Where to begin writing tests

Writing unit tests can be a daunting task for beginner and experienced developers alike.
It's not always clear which code to test or where and when to start writing tests.

The good new is, **to learn the craft of testing, quantity matters more than quality**.
It doesn't matter if you write your tests after the fact or if you use Test-Driven Develpoment, or whether you start testing new code or add tests to code that was already in the codebase.
The learning comes from the act of writing the test itself.

In their book [Art and Fear]() David Bayles and Ted Orland tell the story of a ceramics class divided in two groups:
one group would be judged on the quantity of pots they made, literally using a scale measure, the other would have to deliver only one pot and would be judged on its quality.
Something surprising happened, the best pots all came from the students judged on quantity.
While the quantity group churned out work, always experimenting and learning from their mistakes, the quality group had sat theorizing and in the end had little to show for their efforts than "grandiose theories and a pile of dead clay".

Over time, quantity produces quality —specially when you pair each implementation with feedback on its quality, which is exactly what writing tests does.

When writing tests for your code, notice how much setup you need to do before exercising it, whether or not you can verify the behavior with a single assertion, and how hard it is to identify which assertions to write.
The more you can perform these tasks with ease, the better you are getting at writing unit tests and testable code.

### Code that is simple to test

If you want down-to-earth advice, start writing tests for those pieces of code that are [pure functions](), functions where the output depends only on the input.
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

Because the behavior of `formatBold(_:)`, wrapping the given string in `**`, depends only on its input, with no extra sources of information affecting it, such as shared instances, a database, or time affecting it, writing a test is rather straightforward.
Arrange the system under test and the input, act on it to generate the output, then assert the output is what you expected.

---

The speed at which you get feedback _does_ make a difference in the speed at which you learn a new programming language or framework.
Writing tests allows you to get faster feedback than if you were to build and navigate through an app's UI.

Testing might seem like a daunting task to get started with, there are a lot of unknowns and it may feel like you are not writing useful code, code that actually goes into your app.
The good news is that to learn about testing you just have to get started.
Don't worry about the quality of the tests itself.
It might feel awkward and hard in the beginning, but that's just the reality of learning a new skill.
The more tests you write and the more you listen to the feedback they give you, the easier it will become to write them.

This is a flywheel, a positive loop that feeds itself making it easier and easier to keep going.
All you need to do is get the wheel spinning.

_If you want to chat about where to start writing tests, reach out on Twitter [@mokagio](https://twitter.com/mokagio)._
_[Subscribe](#subscribe) to never miss an articles on testing and productivity, and to learn about my **upcoming book on TDD in Swift**._
