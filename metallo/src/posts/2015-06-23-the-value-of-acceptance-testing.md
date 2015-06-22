---
layout: post
title: The value of acceptance testing for mobile projects
description: "Companion blogpost for Gio's talk \"Talking myself into the value of acceptance testing\" at Melbourne CocoaHeads meetup"
tags:
- Acceptance Testing
---

_This post might be a bit different from the usual ones on this blog, less technical and more hand wavy. I hope you won't mind._

Last week I gave a, short, talk at [Melbourne's CocoaHeads](http://www.melbournecocoaheads.com/) titled: **"Talking myself into the value of acceptance testing"**. In this post I will go through the contents of the talk.

We will talk about the problems that make acceptance testing hard, the scenarios in which they can really add value to your projects, and we will close with some tips on how to get started.

[Melbourne CocoaHeads](http://www.melbournecocoaheads.com/) being an iOS and Mac developer meetup I didn't specify that these consideration are related **only to the mobile world**. I have very little experience with acceptance testing outside iOS, and I cannot express informed opinions for acceptance testing in the web world.

You can see or the original web version [here](http://mokagio.github.io/acceptance-tests-cocoaheads-talk/#/). The video should come out, eventually.

## Before we begin

Before we start talking about acceptance testing there are two things that need to be made clear.

### Acceptance test != Unit test

An acceptance test asserts a specific acceptance criteria, or user story, or job story, a well defined behaviour that the app is supposed to have.

A unit test on the other hand asserts the behaviour of a give class or module, the `sut`, _system under test_.

The scope and the design of these two tests are completely different, and it is also important to say that they don't replace each other. A 100% coverage and green unit test suite doesn't necessarily mean that the acceptance tests will pass, and vice versa.

Unit tests are very important, and [you should write them](http://mokagio.github.io/acceptance-tests-cocoaheads-talk/#/4).

### Acceptance test != Automated test

An acceptance test doesn't have to be automated by definition. Having the intern make sure that when logging in with Facebook the profile picture is set as the same on of the Facebook profile is an acceptance test. But it is definitely not automated.

At the same time, having Travis CI running the unit tests for the project after every push to the repo is a way of running tests automatically, but those are not acceptance tests.

This post (and talk) is about **automated acceptance tests**. For the rest of the post we will omit the automated part of the name.

## The problems

There are three big pain points when attempting to do acceptance testing.

![Acceptance test are long to write](https://s3.amazonaws.com/mokacoding/2015-06-23-long-to-write.png)

The tests are **long to write**, even now that we have Apple's new UI testing framework with the recording feature, it still takes time to write a test.

![Acceptance tests are slow to run](https://s3.amazonaws.com/mokacoding/2015-06-23-slow-to-run.png)

They are then **slow to run**, as the test goes at more or less the same speed as the user, and it most likely has to perform extra setup and tear down interaction between every scenario.

![Acceptance tests are expensive to maintain](https://s3.amazonaws.com/mokacoding/2015-06-23-acceptance-tests-expensive-to-maintain.png)

Not only that, acceptance tests are also **expensive to maintain**. Being so tied with the UI and UX of the app, every time a new screen is added to the flow, a button change name, or the interaction becomes different the tests need to be updated. And as we just saw, it takes time to do so.

There are some best practices that we can take to minimise this cost, for example centralising the value of the accessibility labels and identifiers behind a constant, or use the [screen/page object pattern](https://www.kidozen.com/mobile-testing-page-object-pattern-with-multilayer-design/). But the cost of keeping the test suite up to date is relevant.

Let's not talk about how hard it is to keep the tests from being brittle and unreliable.

On top of those problems there is the fact that you **still need QA**. We are not ready yet to replace humans with AIs that can make sure the app is actually behaving as intended, and there are things like the camera interaction that are hard to test in an automated way.

## When acceptance tests become valuable

At this point you might be thinking that there is no point at all in trying to do acceptance testing, it's just a wast of time. That is not true, there are projects and types of apps for which investing time in writing acceptance tests will reward you very well.

### Apps with many possible state combinations

![Apps with many state combinations](https://s3.amazonaws.com/mokacoding/2015-06-23-useful-with-state.png)

Some apps are simple, the user can take only a couple of paths through them. They do one thing, and hopefully they do it well. There are other apps on the other hand that have UI full of switches and pickers and buttons, in which every action the user takes multiply the number of possible outcomes by at least 2.

In such cases even components that have been thoroughly unit tested can fall short, and be used in an unexpected combination.

Investing time into writing acceptance tests for all the possible scenario is gonna give you an extra degree of confidence. It will also save a lot of QA time, the test will cover all the edge cases, the humans will then be able to verify only the most important ones.

### Refactoring legacy spaghetti code

![Refactoring legacy spaghetti code](https://s3.amazonaws.com/mokacoding/2015-06-23-useful-with-refactoring.png)

Some authors define legacy code _any code that doesn't have test coverage_. It could happen that you inherit a project from another team, or are hired to fix one. This project is most likely gonna be complex, and the quality of the code is gonna be... arguable (otherwise why would you be there?).

In such cases every change you make makes you uncomfortable. In [Working Effectively with Legacy Code](http://www.amazon.com/Working-Effectively-Legacy-Michael-Feathers/dp/0131177052) Michael Feathers suggest to add a unit test before making a change, and to slowly use the reliability generate by the test to refactor the project.

But sometimes the code is such a mess, such a bowl of spaghetti, that finding a plaec where to start refactoring is a mission. If that's the case then investing some time in writing an acceptance tests suite to assure that no matter what internal change, refactor, or rewrite, you made the app is still behaving as expected could give you the confidence to tackle the project and eat the spaghetti.

### Dealing with "Agile" clients

![Dealing with "Agile" clients](https://s3.amazonaws.com/mokacoding/2015-06-23-useful-with-client.png)

You all know that kind of client that wants to be Agile without really knowing that it means. They have the JIRA board, the sprint planning, probably a PM or scrum master, and user stories bloated with acceptance criteria. And once you've committed to a certain amount of points for the sprint there's nothing to do about it, you have to deliver!

It can be useful to interact with these stubborn clients _one acceptance criteria at the time_, making sure that everything they ask is implemented, and being able to demonstrate it. And what better tool that a suite of automated acceptance tests?

## Who should write acceptance tests

We saw that yeah, acceptance testing on iOS projects has some pitfalls, but there are scenarios in which it can actually be a very useful and powerful tool. Who should write acceptance tests?

In my opinion you should consider writing acceptance tests if:

* You are in a medium-big team, where some developer time can be directed towards acceptance testing without impacting the overall _velocity_.
* The project has clear requirements and specifications. Since updating acceptance tests is painful you don't want to have to do it once a week.
* The project doesn't have a strict deadline. If you're writing test code you are clearly not writing production code. But while in most cases writing unit tests is a good use of time because the resulting software design is better, and on the long run unit tests will allow you to make changes more quickly, the same might not be true for acceptance tests. Don't run acceptance tests if you are in a rush.

## I want to write acceptance tests, where do I begin?

![Where do I begin?](https://s3.amazonaws.com/mokacoding/2015-06-23-where-to-start.png)

Getting started with acceptance testing on iOS is becoming easier and easier. Apple [just released a new UI testing framework](http://www.mokacoding.com/blog/xcode-7-ui-testing/) which allows you to automagically write tests cases simply by running the app on the Simulator and interacting with it. It is fully integrated with `XCTest`, and being completely detached, is on another target, from your Release code, is a safe way where to write some Swift code without the problems of Objective-C interoperability.

For the past years [KIF](https://github.com/kif-framework/KIF) has been one of the best open source frameworks to use to write tests for the behaviour of your apps. The community around it is pretty active, and I'm looking forward to see how we're gonna be able to leverage the new APIs provided by UI testing to make KIF an even better framework.

Finally if you're working with a cross platform app, or you have a full time tester, you might want to have a look at [Calabash](http://calaba.sh/) and [Appium](http://appium.io/).

## Your first test

If you're sold on your framework of choice but don't know where to start you could:

* Identify the most important feature or user's path through your app, and write a test for that. How do you get money from your app? Is the login always working? What cannot absolutely break in your app? Find that out and write a test for that.
* Write an acceptance test for a bug that you need to fix, write the fix, and use the test to verify that it is actually valid.

## Conclusion

Acceptance testing is a practice that can increase the quality of your process, prevent you from shipping bugs, and give you more confidence when making changes on the codebase. There are although a number of factors that make it hard, and sometimes you could invest your time in more productive activities. In this post we saw some of the tradeoffs of acceptance testing, and some valid use cases. As with everything else the best way to find out if this is something valuable for your team and your project is **trying it out** and measure what happens.

I hope you found this post interesting and informative. If you have any experience to share on acceptance testing going well or incredibly wrong, please tweet me [@mokagio](https://twitter.com/mokagio) or leave a comment below.

This blog has other articles regarding more practical aspects of acceptance testing for iOS, [check them out](http://www.mokacoding.com/tag/Acceptance-Testing/index.html).

_Happy coding, and leave the codebase better than you found it._
