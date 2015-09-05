---
layout: post
title: "/dev/world/2015 notes of a testing fanboy"
description: "I attended /dev/world/2015 in Melbourne this week. It has been a great conference, full of very friendly and smart people. Being a test and automation fanboy I attended as many talks related to that topic as I could. These are my notes."
tags:
  - Testing
  - Tooling
  - Automation
  - Conferences
---

I've been at [/dev/world/2015](http://2015.devworld.com.au/) in Melbourne last week. It has been a great conference, full of very friendly and smart people.

Being a test and automation fanboy I attended as many talks related to those topics as I could. These are my notes.

---

The first talk I attended was "**Maintaining Sanity and Code**" by [Bogo Giertler](https://twitter.com/giertler) shared his experience regarding software design and maintainability across several companies of different sizes, Spotify and Dropbox to name a few.

I felt like the talk highlighted three big areas that developers should focus on to keep our projects maintainable and our own sanity: architecture, process, and tooling. The many concepts and idea from Bogo's talk connect with some of the other talks I attended, making it a map of sort to reflect on the entire conference.

### Software Architecture

The way we architect our application matters because otherwise we risk code becoming unmanageable as the codebase grows, and different developers touch it.

But how to do it? As usual there is no silver bullet, but a good rule of thumb Bogo shared is to blackbox as much as the architecture as possible.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/giertler">@giertler</a> blackbox as much as the architecture as possible <a href="http://t.co/z9UmF3Fpmr">pic.twitter.com/z9UmF3Fpmr</a></p>&mdash; Call me Joe (@mokagio) <a href="https://twitter.com/mokagio/status/638147910840922112">August 31, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Black-boxing means having well defined boundaries with between the objects in the system, and only use those boundaries as the interfaces for objects communication.

The advantage of abstraction is the possibility to reason about the system and the problems it is trying to solve at a higher level, and relegate implementation details and complexity at the lower level of the single components.

And talking of architecture, [Jeames Bones](https://twitter.com/jeamesbone)'s talk on practical [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) provided a good example of how certain patterns and programming paradigms can help us writing code that is easier to understand and maintain, and also work well. By using RAC Jeames's team was able to drastically improve the performances of an app using iBeacons.

And guess what? [Judit Klein](https://twitter.com/JuditK) gave a talk about iBeacons! 😎

In his talks "**Manage Your State**" [Mark Aufflick](https://twitter.com/mark_sabbatical) showed another useful architecture pattern, the [Finite State Machine](https://en.wikipedia.org/wiki/Finite-state_machine), which allows to model stateful system in a clear way. State Machines are a formal mathematical model, and thanks to this they are guaranteed to work, which means that they don't need to be tested.

### Process

Another key take away from Bogo's talk was the importance of process in teams. Here's some great tips:

* Headers documentation is a great way to communicate with other developers, specially in async/distributed teams.
* It's important to request colleagues for their opinion regarding software designs decisions.
* Teams need a shared way to track what is getting done. My favourite tool for that is [Trello](https://trello.com), which is very flexible.
* Review PRs quickly, never let them stale, or they will be hared to merge, and the author will get demoralized.
* Enable designers to access the code and make the small UI tweaks they need.

All those, and many more, little things sum up into a great and productive development pipeline.

Did anybody say pipeline? [Matt Delves](https://twitter.com/mattdelves)' talk "**Blissful Build Pipelines**" touched on the importance of automation, and on the tools we can put in place to have a process that releases to the AppStore by pushing to git.

Matt highlighted a number of points in the development process that can be automated.

* Linting, with [OCLint](http://oclint.org/) or [SwiftLint](https://github.com/realm/SwiftLint)
* Code coverage, which is provided by default in Xcode 7, and can be aided by [slather](https://github.com/venmo/slather) and [coveralls.io](https://coveralls.io/)
* Running tests on every push on every related branch with [BuildKite](https://buildkite.com/)
* and finally build an ipa, take screenshots, and submit to TestFlight with [fastlane](https://fastlane.tools/)

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/mattdelves">@mattdelves</a> Should you use Jenkins? Nope! <a href="https://twitter.com/hashtag/DevWorld?src=hash">#DevWorld</a> <a href="http://t.co/8fRjVzFN6k">pic.twitter.com/8fRjVzFN6k</a></p>&mdash; Call me Joe (@mokagio) <a href="https://twitter.com/mokagio/status/638156898508800000">August 31, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

To the question from cheeky guy from the audience (_me_) on whether he tests the scripts for the pipelines he builds, Matt replied that the best way to test them is to run them.

The topic of testing was the focus of a following talk by [Tim Raphael](https://twitter.com/TimRaphael215), "**Testing and Test Methodologies within Xcode**".

Testing your code is important because it can prevent regression, and find bugs systematically. This results in higher quality apps, which make their users happy. And since your app's users are actually your customers, that means that they are going to be more likely to _give you money_.

The talk finished with a discussion with the audience on what's the first thing that you should be testing when working on an existing app that doesn't have tests. One answer was to start with the most unpredictable things, like user interaction, make sure that all the components related to the user interaction are robust. Another answer was to pick the first bug in the backlog, and write a test for the expected behaviour. The test will be failing, because the bug is there. Then fix the bug an see the test pass.

As I side note, I really enjoyed Tim's talk Pokémons theme.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/TimRaphael215">@TimRaphael215</a> tests help to find bugs systematically <a href="https://twitter.com/hashtag/DevWorld?src=hash">#DevWorld</a> <a href="http://t.co/3vanq1IusE">pic.twitter.com/3vanq1IusE</a></p>&mdash; Call me Joe (@mokagio) <a href="https://twitter.com/mokagio/status/638203900416294913">August 31, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

### Tooling

The last core message I brought home for Bogo's talk was on the importance of tooling: "Don't be a tool. Make the tool".

A great way to channel our creativity and problem solving energy is to identify points of friction in the process or in the code and use technology to remove them.

As an example Bogo showed us a simple tool a team he worked with made, an app that allowed designers to edit the JSON used to drive the UI of an iOS app, and reload it live in the Simulator. Thanks to that his team save many hours of back and forth between developers and designers, and the shipped a better app, earlier.

The topics of tooling and process were at the heart of [Patrick Quinn-Graham](https://twitter.com/thepatrick)'s talk "**10,000 Test Cases Pass Before Every Release**", an analysis of the several layers of testing that his company has in place to assure the quality of the software, and the many little tools they built to fit their special needs.

A point both Matt and Patrick touched is that some processes that are slow to run like integration tests have to been automated, otherwise no one will run them.

A nice candy in the talk was the "all test must be fixed within 24 hours" rule that Patrick's company introduced, and that turned out to be greatly beneficial to make test a priority all across the team.

And to close the loop in terms of tools, [Andrew Dekker](https://twitter.com/simultech)'s talk "**Architecting Quickly With Swift**" shared a big bag of tips and trick on how to use Xcode as a prototyping tool.

Andrew's point was that getting the client's feedback early to know if the product is in line with their expectation, and if it actually works, is much more valuable that having a nice and tidy codebase. By working directly in Xcode with Swift Andrew can deliver prototypes in less than a week, instead of the usual 3-4 weeks, and collect important information for the proper development stage.

---

Two talks, unrelated to the testing and automation topic, but still great have been "**Social Interaction Over Shared Devices: Designing Interactive Story Apps for Children**" by [Betty Seargent](https://twitter.com/BettySargeant) sharing her experience making interactive books for kids and rediscovering the importance of having adults and child read books together, and finally [Paul Fenwick](https://twitter.com/pjf) on the future of technology.

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">The awesome <a href="https://twitter.com/pjf">@pjf</a> amazing the masses at <a href="https://twitter.com/hashtag/devworld?src=hash">#devworld</a> with visions of the future <a href="http://t.co/sDO2XyBVsM">pic.twitter.com/sDO2XyBVsM</a></p>&mdash; Developer Steve (@DeveloperSteve) <a href="https://twitter.com/DeveloperSteve/status/638277229630193665">August 31, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

This was my first /dev/world, but it is certainly not going to be the last. I had such a great time, met awesome people, and learnt a lot.

Thanks everybody, in particular to the [AUC](http://auc.edu.au/) team that organized it.

_Leave the codebase better than you found it._
