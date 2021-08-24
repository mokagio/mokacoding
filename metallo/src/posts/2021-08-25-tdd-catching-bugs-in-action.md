---
title: A real-world example of TDD catching bugs
description: I published a YouTube video with a tutorial on implementing the FizzBuzz algorithm using Test-Driven Development. While recording, I made a couple of thinking or coding mistakes, and, sure enough, the tests immediately pointed them out.
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

I published a [video tutorial](https://www.youtube.com/watch?v=AHsnHL6HOdI) showing how to implement the infamous [FizzBuzz](https://en.wikipedia.org/wiki/Fizz_buzz#Programming) using Test-Driven Development, an example coming from my book [_Test-Driven Development in Swift_](https://tddinswift.com).

Aside from the tutorial, what's truly interesting in the video is that it shows how fast TDD can reveal a mistake and help you learn from it.

## How TDD reveals coding mistakes

After completing the implementation, I decided to refactor the ugly code I wrote to make the test pass as soon as possible into something I liked more.

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
More time for sure, as I would have had to manually launch the app or script that uses `fizzBuzz(_:)` feed it an input like `3` and _notice_ the output was not correct.
Apart from the overhead of launching the app and navigating its UI, which might be negligible in some cases, manually verifying code uses our _biological hardware_, which is liable to all sorts of distractions and hiccups.

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

Looking at the code, I expected it to return `"buzz"` and the test to fail.
Can you see where I was wrong?

The test did fail indeed, but the value it received was `"fizz"` instead.
I didn't realize that because 15 is divisible by both 3 and 5, the code would have gone in the `divisibleBy3 == true` branch.

Always guess what the tests will do before running them.
When the result you get is not what you expect, you can [update your mental representation](https://mokacoding.com/blog/thats-funny-moments-are-learning-opportunities/) of the system.

Here's the full video:

<!-- YouTube embed code -->
<!-- Thanks https://jameshfisher.com/2017/08/30/how-do-i-make-a-full-width-iframe/ for the aspect-ratio with YouTube iframe code -->
<div>
  <div style="position:relative;padding-top:56.25%;">
    <iframe style="position:absolute;top:0;left:0;width:100%;height:100%;" src="https://www.youtube-nocookie.com/embed/AHsnHL6HOdI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
  </div>
</div>

---

I could have easily edited those mistakes from my YouTube video, but I decided to leave them.
I hope they serve as a good showcase of the teaching power of Test-Driven Development.

You don't have to be a genius to write great software.
You only need to discover your mistakes fast enough to learn from them and iterate.
