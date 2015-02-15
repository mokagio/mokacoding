---
title: 5 habits that will make you a better software developer
description: By implementing these 5 small habits you'll kickstart your 2015 and become a better software developer.
tags:
- Productivity
---

New year, new you. What a better time that the first week of 2015 to blog about self improvement? There you go: 5 habits that will make you a better software developer.

> Habit:

> - a long, loose garment worn by a member of a religious order.

> - a settled or regular tendency or practice, especially one that is hard to give up.

We'll focus on the second.

Habits are very powerful things. A bad habit like smoking is likely to decrease the length of your life, while a good one like walking 10,000 steps a day is likely to increase it.

The bigger power of habits is that we don't make any effort to do them. You don't have to think about brushing your teeth in the morning, you just do it in autopilot.

So if we there is a behaviour that improves us in some way and we are able to cement into an habit, our overall quality will improve.

I'd like to share 5 little habits that can make us better software developers. The list is not ordered.

## 1. Always have a plan

Before starting to write code stop an make sure you have a plan, don't just write you're way through a feature or a bugfix. Use pen an paper, whiteboard, [talk with your rubber duck](http://en.wikipedia.org/wiki/Rubber_duck_debugging), and come up with a plan, a series of sequential steps to take to complete the task.

This might seem like common sense, but I found many developers, including myself, too often just think "_I know how to do this_", and end up with a poor quality result.

I'm sure that all of you guys are making a development plan before starting the development of big pieces of code, but what I'm saying here is **always** make a plan. There is a lot of value to be gained from just thinking things through for a bit, no matter how small they are.

Given that we all agree that having a plan is good, if you have the _habit of making a plan_, then when starting the development of anything your brain will automatically and with no extra mental cost start making a plan. Big gain, for free.

To build this habit make sure to always have pen and paper next to your keyboard. If you find yourself coding stuff without having made a plan first, stop, make a plan, and start again.

## 2. Commit often, commit atomically

There's plenty of literature on why making **small atomic commits** is a good idea, so I'll cut it short. Small atomic commits make the development safer, are simpler to merge and revert, and make the task of tracking the source of bugs easier. You can start reading more about the topic [here](http://www.barneyb.com/barneyblog/2006/01/27/atomic-commits-to-version-control/) and [here](http://www.conifersystems.com/2008/11/05/the-benefits-of-small-commits/).

Treating your source control this way is not easy at the start, but the benefits are huge.

To build this habit you'll have to be disciplined in all your projects, even if you're working solo or its a personal one.

Habits are built through committed repetition. _Did you get the pun?_

Power tip: `git commit -p` lets you interactively stage hunks, even single lines of code.

## 3. Write tests

2014 has been pretty controversial regarding tests, starting with [DHH's talk at Rails Conf](https://www.youtube.com/watch?v=9LfmrkyP81M), [Gary Bernardt's spicy followback](https://www.destroyallsoftware.com/blog/2014/tdd-straw-men-and-rhetoric), and a very insightful series of [hangouts](http://martinfowler.com/articles/is-tdd-dead/) were DHH, Martin Fowler, and Kent Beck discuss on the topic.

Mine and many other's opinion is that writing tests first is useful and results in better software. That's why:

* They provide another client for your code.
* If something is hard to test it's most likely to be hard to work with, and you can make it simpler now, before actually having to interact with it "for real".
* They give you confidence when refactoring.

To implement this habit, **overload it**. Write tests for everything! No line of code should be written without a test. Test everything, even stuff that could seem silly to test, like constants values, colors, methods that do simple stuff. The point here is entering in the test mindset. Once you'll automatically write tests for everything you'll be able to take a step back and test only what actually matters.

## 4. Learn a new keyboard shortcut a day

What if I told you you could make 2015 366 days long? 

Say that your IDE has a feature you use 60 times a day, and by using a keyboard shortcut instead of the mouse you can save 1 second each time. That's 1 saved minute per day. Over one calendar year of, let's say, 47 working weeks of 5 days each it's 235 saved minutes. 

Almost 4 hours, with only one keyboard shortcut!

Get into the habit of looking up a new keyboard shortcut as the first thing you do in your working day.

Do you already know all the shortcuts of your favourite IDE? What about making aliases for the most used shell commands, like `gp` for `git push`, creating snippets of the most used bits of codes, automating repetitive tasks? The possibilities are endless!

## 5. Stay focused

We all know that software developers work better over long uninterrupted periods of time. That is due to the famous "context switching" cost, and the fact that our job consists in keeping a lot of little details alive in our short term memory, and evaluating all at the same time. 

If you check every email, mention, like, and text you receive you'll have to "pay" the context switch cost every time. By staying focused and batching all the social updates and email checking at the end of a coding session you'll gain productivity. And guess what? Because you don't have to spend time to go _back in the zone_, you'll get your tasks finished faster.

Some tips to stick to this habit: use the famous [Pomodoro Technique](http://pomodorotechnique.com/), consider turning the phone in airplane mode when working on important tasks, and rate your focus level during the day, tracking what makes you loose focus in order to avoid it.

## Conclusion, but this is just the beginning

These 5 habits might not be the absolute very best ones, but they're working out very well for me and I wanted to share them.

Building habits is something that takes commitment, but surely pay in the long run. It takes between one and two months to cement a new habit, and it's better to focus on a just a small number of habits at a the time, in order not to drain the willpower necessary to implement them. 

You can leverage on the power of habits on almost every aspect of your life. Being a better developer is just the beginning!
 
Have you got some good habits that make you a better software developer? [Tweet me](http://twitter.com/mokagio) about them!
