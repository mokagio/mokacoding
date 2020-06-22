---
layout: post
title: Xcode keyboard shortcuts for testing
description: "Keyboard shortcuts are easies way to start increasing your productivity. Let's look at how to run tests in Xcode without ever touching the mouse."
tags:
- Testing
- Xcode
- Productivity
---

The number one secret of productive developers is the mastery of their tools. From the text editor to the frameworks most unknown method, the more you know on a tool, the more way to use it effectively you'll find.

Keyboard shortcuts are one of the easiest way to gain massive productivity improvements, with the least effort. I'll go as far as to say that to [you should learn a keyboard shortcut a day](https://www.mokacoding.com/blog/5-habits-that-will-make-you-a-better-software-developer/).

So let's see how we can be more productive when running tests from Xcode by avoiding to the mouse, ever.

## Run the test - ⌘ U

"Command-U" is the shortcut to run all the tests in the current scheme. If you need help memorizing it imagine a teenager sending a text message to Xcode saying "_I command u 2 run the unit tests"_.

## Run only one test - ctrl ⌥  ⌘ U

By mashing "Control-Option-Command-U" you can run the test method in which your cursor is. This is quite useful when you're iterating on a single test and only want to run that one. You can remember it by imagining the same teenager having a _control_ panel, with _one option per test_, that they can use to send Xcode a text message saying "I command u 2 run this test".

## Re-run the previous set of tests - ctrl ⌥  ⌘ G

With "Control-Opion-Command-G" you can re-run the last test method executed. That is if you run only one test, that test will run again, if you run the entire suite, all the tests will be executed again. Like "Control-Option-Command-U" this is useful when iterating on a single test. For example if you're refactoring and are in the file you're working on, instead of having to go back to the test method, or, _heaven forbid_, moving your hands from the keyboard to touch the mouse, you can simply re-run the last test action, and be proud of yourself.

To remember this one think about the teenager saying Xcode _"Gee Xcode, I don't remeber... just do the last thing I told you again!"_.

There you go, these simple keyboard shortcut will save a lot of time over the course of the work week, and making them muscle memory will be a matter of days.

An alternative way to run tests is from the terminal, if you're curious on how or why to do it check out [this post](https://www.mokacoding.com/blog/running-tests-from-the-terminal/).

_Happy coding, and leave the codebase better than you found it._
