---
title: A real-world example of TDD catching code regressions
description: I published a YouTube video with a tutorial on how to implement the FizzBuzz algorithm using Test-Driven Development. In a couple of occasions while recording, I made a thinking or coding mistake and, sure enough, the tests immediately pointed it out.
twitter_title: How tests reveal coding mistakes FAST
og_description: While recording a FizzBuzz TDD tutorial, I made some mistakes that my tests immediately noticed
tags:
  - swift
  - testing
  - tdd
  - xcode
  - refactoring
og_image: https://s3.amazonaws.com/mokacoding/2021-08-25-tdd-fizz-buzz.jpg
---

I published a [video tutorial](https://www.youtube.com/watch?v=AHsnHL6HOdI) showing how to implement the infamous [FizzBuzz](https://en.wikipedia.org/wiki/Fizz_buzz#Programming) using Test-Driven Development.

The example comes from my book [_Test-Driven Developmen in Swift_](https://tddinswift.com) but what's particularly interesting in the video is that it shows how fast TDD can reveal a mistake and help you learn from it.

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/AHsnHL6HOdI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## How TDD reveals coding mistakes

After completing the implementation, I decided to refactor the ugly code I wrote just to make the test pass into something I liked more.

I went from this:

```swift
func fizzBuzz(_ input: Int) -> String {
    let divisibleBy3 = input % 3 == 0
    let divisibleBy5 = input % 5 == 0

    if divisibleBy3 && divisibleBy5 {
        return "fizz-buzz"
    } else if divisibleBy3 {
        return "fizz"
    } else if divisibleBy5 {
        return "buzz"
    } else {
        return "\(input)"
    }
}
```

To this:

```swift
func fizzBuzz(_ input: Int) -> String {
    let divisibleBy3 = input % 3 == 0
    let divisibleBy5 = input % 5 == 0

    switch (divisibleBy3, divisibleBy5) {
    case (false, true): return "fizz"
    case (true, false): return "buzz"
    case (true, true): return "fizz-buzz"
    case (false, false): return "\(input)"
    }
}
```

Can you spot the error I made?
The tests [revealed it](https://youtu.be/AHsnHL6HOdI?t=816) as soon as I run them.

In my copy-pasta, I used the code to check for "fizz" to print "buzz" and vice versa.

How long do you think it would have taken me to notice that mistake if I'd been relying solely on manual testing?
Definitely more time, as I would have had to manually launch the app or script that uses `fizzBuzz(_:)` feed it an input like `3` and _notice_, something is not always guaranteed it to occur, the output was not the correct one.

## How TDD reveals incorrect mental models

That refactoring mistake is not the only one I made in the screencast.
[Earlier on](https://youtu.be/AHsnHL6HOdI?t=491), the tests failed in a way that I was not expecting.

I the production code was in this incomplete state:

```swift
func fizzBuzz(_ input: Int) -> String {
    let divisibleBy3 = input % 3 == 0

    if divisibleBy3 {
    } else if divisibleBy3 {
        return "fizz"
    } else {
        return "buzz"
    }
}
```

I had just added a test for the `"fizz-buzz"` scenario:

```swift
func testDivisibleBy15ReturnsFizzBuzz() {
   XCTAssertEqual(fizzBuzz(15), "fizz-buzz")
}
```

Looking at the code, I was expecting it to return `"buzz"` and the test to fail.
Can you see where I was wrong?

The test did fail indeed, but the value it received was `"fizz"` instead.
I didn't realized that, because 15 is divisible by both 3 and 5, the code would have gone in the `divisibleBy3 == true` branch.

This is why it's useful to always make a guess on what the tests will do before running them.
When the result you get is not what you expect, you can [update your mental representation](https://mokacoding.com/blog/thats-funny-moments-are-learning-opportunities/) of the system.

---

I could have easily edit those mistakes out of my YouTube video, but I decided to leave them.
I hope they serve as a good showcase of the teaching power of Test-Driven Development.

You don't have to be a genius to write great software.
You only need to discover your mistakes fast enough to learn from them.
