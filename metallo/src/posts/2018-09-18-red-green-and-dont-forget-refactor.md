---
title: "Red, green, and don't forget refactor"
description: "Test driven development works at its best when you refactor as you go. Write the failing test, write just enough code to make it pass, then and only then focus on making that code good."
tags:
  - TDD
---

When learning about test driven development you'll soon come across the "**red, green, refactor**" mantra. It's TDD in a nutshell. Write a failing test, write the code to make it pass, make the code better.

The refactor set is often skipped though. People write the failing test, they write the code to make it pass, and move on to the next test.

Skipping the refactor step means you're not taking full advantage of what the TDD process has to offer. Having green lets you change your code with confidence. Don't pass on this opportunity.

![Diagram representing the red, green, refactor cycle](https://s3.amazonaws.com/mokacoding/2018-09-18-red-green-refactor.jpg)
_The red, green, refactor cycle, by [Nat Pryce](http://www.natpryce.com/articles.html)._

## The good code delusion

One reason why people forget the refactor step is trying to write the best possible code on the first go. This is great. You care about your code, strive to make it good. It's also a short-sighted approach.

I don't know about you, but I've never written a piece of code that couldn't be improved.

The TDD process as Kent Beck describes it [Test Driven Development by Examples](https://amzn.to/2NtIQeS) starts by writing a failing test, then "just enough code to make it pass".

If you allow yourself to write crappy code good enough to make your test pass you split the development process in two pieces. Make it work first, make it good later.

Here's another Kent Beck quote. "[Make it work. Make it right. Make it fast](http://wiki.c2.com/?MakeItWorkMakeItRightMakeItFast)."

## Split "what it does" from "how it does it"

There's something to be said about this intentional split between making the test pass and cleaning up the code.

First you focus on what the code should do, by making the test pass. Once the test is green you have the freedom to focus entirely on how the code looks and feels, and how it fits in the rest of your codebase.

Because you have a suite of succeeding tests you can refactor and reshape your code with the confidence you won't break its behaviour.

Making the code work and making the code right are two different problems. Being able to solve only one of those at a time is liberating. Our brain is not made for multitasking.

## Keep up the pace

The "red, green, refactor" dance helps you keep a steady development pace. Make a change, run the tests. Make a change, run the tests. Make a change, run the tests.

Do this long enough without interruptions and you'll reach a state of [flow](https://amzn.to/2pd9drU). Time will fly and you'll be achieving top results. It's an addictive game, where the goal is to make tests green and keep them green while making changes.

## Sofware that's easier to change

Failing to make time for refactoring is one of the reasons code quality deteriorates. Communicating the value and need for refactoring to non-tech people is hard. There's always a pressing deadline, or another important™ thing to work on.

Practicing "red, green, refactor" makes improving the code part of the development process. It's something you do as you go, a little bit every time.

Yes, there will be the need for big refactors from time to time. They won't be as hard to do though, as the code on which you'll have to work will be clean and tidy.

## Summing it all up

As your product grows and evolves the software powering it will need to change. The easier software is to change the better your job will be. Dancing the "red, green, refactor" dance is a way to keep software easy to change.

By taking the time to look at the code you just wrote and ask the question "how can this be improved" you'll end up with a better implementation than if you'd tried to get it right from the start. "Red, green, refactor" produces a development pace to helps keeping focus and momentum. By cleaning up as you go you'll set yourself up for success and reduce the need to spend time on large and complex refactors.

Today when you write tests remember the "red, green, refactor" mantra. Write it on a post-it note under your screen. Stick to it for at least one day. I can guarantee by the end you'll appreciate the difference it makes.
