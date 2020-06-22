---
title: How to choose what to refactor
description: 'A way to identify the areas of code to refactor with the highest return of investment using the "focusing question" technique.'
date: 2018-09-04
tags:
  - Refactoring
  - Books
  - Productivity
---

In his book [The ONE Thing](https://geni.us/tgjnLb) author Gary Keller defines a technique for identifying the most valuable work called _focusing question_.

> **What is the one thing you can do right now for `<x>` that will make everything else easier or unnecessary?**

It's a simple yet powerful tool. You can use it to discover the best thing to work on next. It's an exercise that makes you re-frame your list of possible tasks in the context of **how actionable they are right now, and what impact they'll have**.

You can read more about how to apply the focusing question in [this post](https://www.mokacoding.com/blog/the-focusing-question/). This technique is also valuable when thinking about **refactoring**.

When starting to work on a new feature or task look at the code you have and ask yourself if there is **something that if improved would make the rest of the work for this project easier or unnecessary**.

Have a look at the areas of code that you will be interacting with.

- Is everything you'll need available already? You might need to [extract a method](https://refactoring.com/catalog/extractMethod.html), or [a class](https://refactoring.com/catalog/extractClass.html), or make a parameter injectable.
- Is there some duplication that could be removed so it doesn't get in your way?
- Is the type signature of the components involved strong enough?
- Are there unit tests in place that will ensure your changes won't accidentally break the components involved?

When applying the focusing question to identify refactoring opportunities it is important to remember the "for `<x>`" part. Don't look for generic improvements, only for changes making the execution of the project you are working on easier.

I'm not trying to discourage you from improving your codebase. "Leave the codebase better then you found it", right? I want you to stay focused on the job ahead though. Don't write code for code sake, there needs to be purpose behind what you do. You can collect all the other improvement ideas in your project's issue tracker or in a Trello board.

Once you have implemented the changes identified with the focusing question, submit them in a **dedicated PR**. It will help your team review them, and ensure they are real refactors, that is, changes to the code implementation that don't affect its behaviour.

Remember Kent Beck's advice: first make the change easy (warning: this might be hard), then make the easy change.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">for each desired change, make the change easy (warning: this may be hard), then make the easy change</p>&mdash; Kent Beck (@KentBeck) <a href="https://twitter.com/KentBeck/status/250733358307500032?ref_src=twsrc%5Etfw">September 25, 2012</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

---

It's easy to get lost and sidetracked while refactoring. We always want to make things better, and there is always room for improvement. A pragmatic developer is one able to identify those improvements that will deliver value right now from the vanity ones.

Is the refactoring work you are about to begin going to benefit the customers? Will it make working on the project easier? Or are you just updating some part of the codebase that no one touches because it doesn't look right?

Asking yourself "what can I do right now that will make working on my next task easier or unnecessary" will help you understand which refactoring ideas are valuable and which are less so.

Have you got some refactoring experience that you'd like to share? Need some help with reshaping some code? Get in touch on Twitter [@mokagio](https://twitter.com/mokagio), or leave a comment below.

_Leave the codebase better than you found it_
