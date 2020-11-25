---
title: When experiments go wrong
description: "Scientist can learn a lot from failed experiments. To do so, they must be methodical and collect all sorts of information. Softwar developers can learn a lot from failures, too. What are the practicies that can make learning easier?"
og_description: "Scientists can learn a lot from failed experiments. So can software developers. Here's how."
og_image: https://s3.amazonaws.com/mokacoding/2020-11-25-experiment-gone-wrong.png
tags:
- Books
- Testing
- Learning
---

The other night, I was reading a new [question and answers lift-the-flap book](https://geni.us/req1) to my almost 4-year-old when we got to this:

![Picture of the flap in the book](https://s3.amazonaws.com/mokacoding/2020-11-25-experiment-gone-wrong.png)

> **Question** Do experiments ever go wrong?
>
> **Answer** Yes, often! That's why scientists must label everything, measure amounts carefully and take notes. A scientist can learn a lot from an experiment that goes wrong.

_A scientist can learn a lot from an experiment that goes wrong._
That reminded me of what Michael Feathers writes in his post [_Testing Yourself_](https://michaelfeathers.silvrback.com/testing-yourself):

> We should know that our tests will pass before we run them. We should be right most of the time. The times when we are wrong? Well, we should really stop then and figure out what we were missing. Where did our mental model of the behavior of the code diverge from the actual behavior of the code? That's the space where bugs happen.

The times when our tests fail or pass unexpectedly, when something that's not supposed to work does, [when we say "That's funny..."](https://mokacoding.com/blog/thats-funny-moments-are-learning-opportunities/).
Those are the moments when we can learn the most, when we can refine our mental representation of the software we are working with.

My son's book also says that because experiments can go wrong, scientists "must label everything, measure amounts carefully and take notes."
That way, they give themselves the best chance to learn from those experiments.

What's the equivalent for software developers?
What can we do to give ourselves the best chance to learn about our systems when they behave unexpectedly?

Here's a few ideas:

- **Move in small, atomic commits**. Whenever something goes wrong, you'll have a small diff to look at, and it should be simpler to understand why.
- **Write [good commit messages](https://thoughtbot.com/blog/5-useful-tips-for-a-better-commit-message)**. Make sure to explain why the change in the commit was necessary, not only what it does.
- **Write tests**. They'll help you pinpoint the source of the issue.
- **Practice Test-Driven Development**. When you start with tests first, you get to verify your assumptions on the code's behavior more often.
- **Add events logging to your apps and use real-time monitoring tools**. Failures often happen when the software is out in the wild. You need to be able to track them down and identify their source to fix them and understand why they occurred.

What do you think?
What other practices can help us be methodic like scientists and, when our software surprises us, make it easier to understand why?

Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).
