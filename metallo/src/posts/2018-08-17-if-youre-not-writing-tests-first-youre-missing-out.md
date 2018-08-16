---
title: If you're not writing tests first you're missing out
description: "A look at the benefits of writing unit tests before production code, in other words TDD."
tags:
  - Testing
  - TDD
date: 2018-08-17
---

Most of us developers write unit tests. Only a percentage though writes them before the production code, before the code they're meant to test.

If you are not writing tests first you are missing out on a number of benefits.

## Prevent false positives

If you write your tests after the production code is completed you will only see them pass. If they pass on the first run, how do you know they would fail if the code was wrong?

When writing tests before implementation you start with a failing test, and then you write just enough code to make it pass. This gives you confidence in the ability of your test to fail if the behaviour it's asserting will change in the future.

## Better design

Writing tests forces you to consider how easy it is to initialize and interact with your components.

Tests become a litmus test for how easy it is to use your components. Noticing that a test is hard to setup will work as a warning bell for a design that might need improvements.

The harder it is to setup an object, the harder it will be to write its tests. This friction helps writing small components doing only one thing and easy to compose with others.

A system made of many small, isolated, easy to compose pieces is going to be simpler to understand and to work with than one with big god objects that do many things and are tightly coupled with each other.

## Fast feedback

Writing tests first allows you to verify how your code works earlier and faster. You don't need to write all the code, or set it up in your system. You don't need to run your app and go through the user journey that would hit that code. You only need to run the tests.

In business, companies learning and executing faster than the competition have an advantage. This is the same in software. The faster you can know if what you're writing is right the faster you can act on it.

## Pace

Writing code by alternating tests and implementation is like a game you are playing with yourself. You start with a failing tests you need to make pass. Then you need to make the code you've written better while keeping the test green. Then you add a new test and the cycle re-start.

This is fun! Making a test go from red to green is like winning against a boss in a videogame. The rhythm keeps me engaged and focused.

---

I have seen the benefits that the practice of writing tests first in my work and that of colleagues. I'm encouraging you to give this a try. If you are not writing tests first you are missing out.

If you need help with writing tests or want to bounce ideas hit me up on Twitter [@mokagio](https://twitter.com/mokagio), or leave a comment below.

_Leave the codebase better than you found it._
