---
title: "Boring Iterations. Interesting Steps."
description: 'Camille Fournier encourages us to "Make Boring Plans" and move in small iterations.'
tags:
- Strategy
- TDD
---

[Camille Fournier](https://www.camilletalk.com/), author of [_The Manager's Path_](https://geni.us/6fyA), argues that software teams should [make boring plans](https://skamille.medium.com/make-boring-plans-9438ce5cb053).

Here's how a platform team can implement a boring plan to migrate the company from on-premise infrastructure to the cloud:

> They start with a small proof of concept, migrating perhaps a single application and learning in the process.
> Then they do the work of looking across other applications on the old platform, to see which ones are similar to the one that is now in the cloud.
> They work with those users to get them migrated and running, all the while gaining comfort with this new environment and uncovering the interesting gotchas.

A boring plan is predictable and well defined.
There are no surprises for users and stakeholders.
It's not a big bang release but a steady iterative rollout.

She continues:

> They write down what they’re learning, so that each new step in the migration builds on the last, and others can be pulled in without a huge knowledge transfer.

Moving in small steps helps you learn from the work you're doing and use those learnings to inform the next step you'll be taking.
You'll learn about the problem you're trying to solve, the design it requires, and the tradeoffs you'll need to make.

Each iteration is an experiment.
If it's successful, you can build on top of it.
If it isn't, you only need to one little step back and try something different.

The team is not trying to pull a cloud setup that will fit their company's needs out of a hat.
Instead, they start by figuring out a good setup for a single app, then refine it to work for two apps, then three, and so on.
The best setup _reveals_ itself along the way, emerging from the refinements each iteration introduces.

Fournier goes on to uncover a byproduct of boring iterative plans:

> The team focuses on the hard parts of the moment, whether they are figuring out data mirroring, or fixing a bug in a popular open source project, and they are free from the anxious overhead of wondering what is happening tomorrow.

Moving in small, self-contained, and incremental steps frees you.
It frees you not only from "the anxious overhead of wondering what is happening tomorrow" but from the overwhelming feeling of a project where the end is never in sight and from the burden of coming up with an optimal solution from the get-go.

Focusing on one thing at a time allows you to give your full attention to the task at hand, and that's the best way to get it done well and on schedule.

Kent Beck puts it succinctly: "[_Make it work, make it right, make it fast._](https://wiki.c2.com/?MakeItWorkMakeItRightMakeItFast)"

As I was reading the post, I couldn't help but finding similarities with the kind of feeling I get when I practice Test-Driven Development.
Iteration is at the core of TDD: write a failing test, make it pass, refactor the code, rinse and repeat.

When you zoom in from the macro-scale of a full project to the micro-scale of writing a new method, moving in small iterative steps is still incredibly valuable.

TDD helps you split the process of writing code that works first and make it right after.
You can start by writing code that merely works, committing any kind of programming sins along the way.
Once you have a green test, you can then shift your attention from solving the problem to making the code clean, in line with the codebase standards, and performant.
It's liberating: you can now focus on one thing at a time and think more clearly as a result.

Granted, you could do the same without an automated test, but launching the app and navigating through its UI to verify every change is painstakingly slow.

The speed at which you can know if a little change was successful is empowering.
It's easier to try things out because you'll know if they work immediately and, if they don't, you're just a `git checkout -- <file>` away from the working state.

Making boring plans and moving in small iterations won't make your job boring.
Quite the opposite, it will build a scaffold on which to focus on the exciting parts.

Boring iterations. Interesting steps.

_Enjoyed this post?_
_Want to know more about how to apply TDD to move iteratively?_
_You might like my book_ [Test-Driven Development in Swift with SwiftUI and Combine](https://tddinswift.com).
