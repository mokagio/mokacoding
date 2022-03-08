---
title: The case for creating a merge commit
description: 'My current thoughts on which merge strategy to use on GitHub. "Create a merge commit" will help you make sense of how code changed over time without removing the option for a high-level overview of the changes on the main branch.'
og_description: This GitHub merge strategy will help you make sense of how code changed
tags:
  - git
  - github
  - processes
---

Of the three merge options that GitHub offers, "Create a merge commit" is my current favorite.

"Which merge strategy to use" has become as classic debate in the software development circles, much like "Tabs vs. Spaces" or "Vim vs. Emacs."
I was recently involved in one such conversation.
It wasn't the first time, and it certainly won't be the last.
The following is the result of that conversation, a note for my future self on where my thinking was in 2022.

## Why "Create a merge commit" is the best

My whole argument rests on the value of having a tidy Git history and small, atomic, well-crafted commits.
I won't delve much into that, but I added some links at the end of the post that argument its value.

Assuming we agree on the benefits of a tidy Git history, then "Create a merge commit" is the best strategy because **it makes it easier to understand how individual pieces of code changed**.

When you "Squash and merge," you compress the many small steps that comprise your PR into a single commit, losing nuance.
"Rebase and merge" keeps all the small steps, but the `git log` on your main branch becomes overwhelming.

"Create a merge commit" is the best of both worlds.
It maintains the small changes while allowing for 30,000 feet view of the history via `git log --first-parent`.
The `--first-parent` flag makes the log show only the merge commits, simulating the history that would result from the "Squash and merge" approach.

Software development is mostly editing existing code.
We spend lots of time optimizing for readability.
It also makes sense to **optimize for understanding how the code came to be in its current state**.

A common counterargument is that the GitHub PR will still contain all the commits, plus the valuable code review discussion.
Using "Squash and merge" won't delete that information, so why not make the Git history on the main branch more condensed while allowing for noisy commits in feature branches?

I find it's better to have all that information already available in Git without going to search for it on GitHub, regardless of how advanced GitHub searching capabilities are.

Other points in favor of keeping your small commits in the main branch are that it makes bisecting and reverting easier, even though both are admittedly not frequent—_maybe because we don't make small enough commits?_

## Actually, it depends

Software development is a game of tradeoffs.
In the same way that the answer to "Should I go native or cross-platform?" is "It depends," choosing which merge strategy to use requires considering many factors.

I already mentioned my assumptions on working in a certain way: small steps, small commits, tidy Git history.
That is _my_ favorite way of working.
It's also a strategy that smarter folks than me recommend.
See for example [Kent Beck's SB chages](https://medium.com/@kentbeck_7670/bs-changes-e574bc396aaa) and [GeePaw Hill's MMMSS](https://www.geepawhill.org/2021/09/29/many-more-much-smaller-steps-first-sketch/).

But _my_ favorite way of working is not _the best™_ way.
I've seen plenty of successful products with what I would call poor Git and GitHub hygiene.
They were generating revenue and their teams were still able to add features and fix bugs.
At the end of the day, what matters is to find a workflow that suits your team well and lets you deliver.
Don't worry about the approval of internet pontificators such as myself.

A good case for "Squash and merge," for example, is in long-lived codebases with many contributors.
Trading granularity to contain the explosion in commits in the history is beneficial there.

A small team of developers all comfortable with using [interactive rebase](https://thoughtbot.com/blog/git-interactive-rebase-squash-amend-rewriting-history) to tidy up their branches before finishing up a PR might opt for "Rebase and merge" so that the history on the main branch is linear.

Again, it depends.

---

One of the few benefits of getting older is that you gain perspective.
I clearly remember a younger version of me arguing that "Rebase and merge" was the best strategy, the one true way.

It's entirely possible I'm wrong today.
Maybe my future self will have battle scars that will make him recoil at the thought of using "Create a merge commit."
Let's all be mindful of the [_end-of-history illusion_](https://en.wikipedia.org/wiki/End-of-history_illusion) and open to the possibility that our opinions might, and most certainly will, change in the future.

## Further Readings

To learn more about the value of small, atomic commits and having a tidy Git history, see:

- https://mislav.net/2014/02/hidden-documentation/
- https://mokacoding.com/blog/better-merging-for-github-pull-requests/
- https://mokacoding.com/blog/your-git-log-should-tell-a-story/
- https://thoughtbot.com/blog/5-useful-tips-for-a-better-commit-message
