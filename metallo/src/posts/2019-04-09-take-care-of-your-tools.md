---
title: Take care of your tools
description: '"You take care of your tools, your tools take care of you."'
tags:
- Productivity
---

In this scene from the science fiction book [Tiamat's Wrath](https://geni.us/W3BUuU), Teresa finds her space mechanic friend who lives off the grid in a cave doing maintenance on one of his machines.

> His food recycler was in pieces laid out on a blanket, [...] He rolled a bright silver cone about the size of a thumb in his palm and scowled.
> "What is it?" she asked.
> "Injector's getting a little ragged at the mouth is all," Timothy said. "I can touch it up. Just means I'll be drinking my yeast patties more than eating them."
> "You spend a lot of time with that thing."
> "You take care of your tools, your tools take care of you."

Timothy takes care of his food recycler because his survival depends on it.
Our survival as software developers depends on how well we care for our codebase and the tools with use in it.

Software developers have many tools.
Our IDEs and text editors of choice, the programming languages we are using, the application framework on which we're building, the third party libraries we're using to outsource solving coding problems outside our domain, the linters and helpers that run as part of our build and deployment processes.
The list could go on.

## How to take care of your software tools

To take care of our tools, we don't necessarily need to take them apart and inspect them like Timothy.
The most important parts of the maintenance process are taking care of warnings, ensuring we're up to date with the latest versions of our tools, and removing anything that is not used.

### Address warnings as soon as you see them

Whether you work with a language that has a compiler or rely on linters and runtime monitoring, address warnings and violations as soon after you see them as possible.

Imagine you did a blood test and some of the resulting values had a warning sign on them.
Would you go to the doctor as soon as possible to know more about it, or would you wait till next Monday and see if you can shift something in your roadmap during planning to find the time to get them checked out?

Warnings during a build or deployment might seem harmless if the process was successful, but they are there for a reason.
Some warnings will actually become errors in future releases.

Having any number of warnings higher than zero means that when a new one pops up you won't notice it.
It might be the warning that spirals out into a critical failure for your product.

### Keep your tools up to date

Each new version of an IDE, text editor, plug-in, or library brings performance enhancements and some times security improvements you don't want to miss out on.
When a new version of a programming language is released, you can expect new features that will make your coding easier.

Case in point, Swift 4 introduced [`Codable`](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types), a type-safe and elegant way to encode and decode types, and provided a default implementation for translating JSON.
This removed the need to use a third-party library to decode API responses, getting rid of a lot of overhead, and opinionated discussions on which library was best to use.

After each update **read the release notes**. You never know, you might find there's a new feature that solves exactly the problem you've been working on for the past two days.

Tip: For your open source tools living on GitHub you can subscribe to the RSS feed of their releases. You'll find it adding `/releases.atom` to the URL of your project. For example [github.com/apple/swift/releases](https://github.com/apple/swift/releases.atom).

### Remove unused code

Unused code clogs your software and makes everything slower.

If you have a language that compiles, then you'll be wasting compilation time on code that will never run.
If you have tests covering unused code, then you're making the feedback loop slower for no reason.
If you have tools that perform static analysis, then they're spending time looking into files with code that won't be used.

Get rid of dead code as soon as you can to keep your project lean and nimble.

## Later is never

A common thread in these recommendations is that the sooner you act on them, the better.

Later is never.
There will always be other things that seem more important than looking after your tools.
If you don't take action while you can, you'll end up paying the consequences.

Waiting to upgrade or cleanup also has a hidden cost.
If we agree that activities like keeping your tools up to date and removing unused code are beneficial for your codebase, the longer you wait to take action on those activities, the longer your software won't be as good as it can be.
If the latest version of a library makes it work faster, the longer you wait to upgrade, the longer you'll software will be slower than it needs to be.

Finally, it's best to take care of upgrades and maintenance on your own schedule, not when you are rushing to do something else.
There is nothing worse than being unable to ship a bug fix because upstream requires a later version of some component than what you have, and the upgrade process is not straightforward, or because that API you'd been using is now deprecated.

## Update fatigue

Let's be honest though.
Sometimes looking after the tooling of a software project can be a full-time job.
In fact, more and more companies have infrastructure, tools, and developer experience roles and even teams.

If you work on a small company or as a solo, it can be challenging to stay on top of the latest versions of all of your tools, frameworks, and libraries.

In such cases, you might want to introduce operating procedures such as only upgrading to new [minor versions](https://semver.org/).
Write these rules down in your `README.md` and make it clear you are making an intentional compromise to avoid spending a disproportionate amount of time upgrading dependencies.

Spending a lot of time looking after your tools might also be a signal that you have too many of them, or that some are not stable enough.
Every dependency comes with a maintenance overhead.
Is that cost worth the benefit the dependency brings?
If the answer is no, then you might be better off ripping it off and implement a custom solution for it.

---

If you are committed to building a software project for the long run, a codebase you'll still enjoy working in six months, one year, two years from now, then you need to invest time looking after it and its tooling.

Notice the word invest.
This is not bikeshedding, or the geeky need to always be on the latest version of everything because it's shiny.
Keeping the codebase and its tools in the best shape you can is a matter of efficiency.
It's an investment time now that will pay off by saving time later.

_"You take care of your tools, your tools take care of you."_
