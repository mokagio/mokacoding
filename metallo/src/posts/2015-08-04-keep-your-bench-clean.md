---
layout: post
title: Keep Your Bench Clean
description: "Like good chefs keep their benches clean to make delicious dishes all day long in the restaurants' kitchens, so good developer keep their codebase clean. It all comes down to little habits, the result of which when summed up together is a tidy, clean and easy to maintain software."
tags:
- Productivity
---

Last week the grand finale of [MasterChef Australia](http://tenplay.com.au/channel-ten/masterchef) went on air. Don't worry, mokacoding.com hasn't been hacked and turned into a kitchen blog. We are not going to talk about delicious food, unfortunately some of you might think, but of something [Heston Blumenthal](https://en.wikipedia.org/wiki/Heston_Blumenthal) said to one of the finalist, Georgia:

> If you are not careful you're gonna end up be so cluttered that in the end you'll get caught up.

Spoiler alert, Georgia didn't win the MasterChef.

Earlier on in the season [Anna Poloyviou](http://annapolyviou.com/) said something similar during her _pressure test_ challenge to a contestant, Fiona, when explaining why she should clean her bench:

> It's not for me is for you because it will affect your end product. 

Fiona then justified herself like this:

> Of course my bench is a mess but I don't really have time to clean, I need to assemble the cake.

Fiona lost the challenge and went home.

![A messy codebase is like a dirty bench](https://s3.amazonaws.com/mokacoding/2015-08-04-dirty-bench.png)

The **keep your bench clean** rule is as valid in the kitchen as it is when making software. If your codebase and you workstation are messy and cluttered being productive is going to be haarder and harder. You will need to spend time browsing through folders, deciphering unreadable code, scrolling through files full of commented code and unused methods. Your productivity is inversely proportional to, among other things, the clutter of your codebase and machine.

But how to keep our benches and workspaces clean? The answer is made up of little small habits. Here's some.

## Remove unused code when you find it

Unused code slows you down. Keeping unused code does to your project the same thing never throwing away anything does to your house, it makes it a messy place. As soon as you notice unused or unneeded code you should delete it. This is sometimes referred to as [**the boy scout rule**](http://programmer.97things.oreilly.com/wiki/index.php/The_Boy_Scout_Rule), "_Always leave the campground cleaner than you found it._" If you find a mess on the ground, you clean it up regardless of who might have made the mess. Notice how this rule works for unused code, but extends easily to messy code. When you remove unused code or clean messy methods and classes you should commit this edit in its own dedicated commit, which brings us to the next tip.

## Make small atomic commits

An atomic commit is a commit that does one single thing. We [already talked](https://mokacoding.com/blog/5-habits-that-will-make-you-a-better-software-developer/) about the value of small atomic commits. Small atomic commits tell the story of the codebase in a clear sequential way, they are easy to follow, and more importantly easy to revert.

## Never commit commented code

Like unused code, commented code is a smell in your codebase, it clutters your files for no reason. "_But I might need it later!_" some developer say. First of all, that turns out be true not so often, and apart from that **git remembers everything**. We just touched on how useful small atomic commits are, and this is yet another proof of that. Instead of commenting code, **delete it in a single commit**, give it a clear title and explain why you deleted it in the message. If you really feel like you will need to look at this code again [tag the commit](https://git-scm.com/book/en/v2/Git-Basics-Tagging), or write its [SHA](https://schacon.github.io/gitbook/1_the_git_object_model.html) somewhere.

## Keep your classes and methods short

In the Ruby world good developers tend to write very short methods. [Sandi Metz](http://www.sandimetz.com/) defined a [set of rules](https://robots.thoughtbot.com/sandi-metz-rules-for-developers) around this best practice, the first two say that a class cannot have more than 100 lines, and a method no more than 5.

It is not necessary to go as far as the rubyist, but by writing small classes, methods and functions [that do one single thing](https://en.wikipedia.org/wiki/Single_responsibility_principle) we can make the code easier to _reason about_ and maintain. Writing code will become easier because of the smaller scope, and goes for reading it, with less things to keep in your brain at the same time.

## Use a style guide

Having the code follow a style guide makes it easier to both write and read. Developers don't have to think about things like where to put braces, or how many newlines should be used to separate blocks of code. All the code will look the same, and the reader's brain will be able to focus on what matters, what the code does, without having to than deciphering its structure. 

---

The list could go on, but in my opinion these are the most simple yet effective ways to keep your codebase clean.

Each of the practices listed above is simple and not hard to apply, so my best suggestion is to pick one, and try to stick with it for at least a week. Consistency is important here. The same way if you spend 10 minutes every day cleaning you house you will hardly ever have to do _a big clean_, if you remove old and commented code, make changes in little atomic commits, keep your methods and classes short, you rarely will have to stop and spend days cleaning up the codebase. There is much to gain for such a little investment, you work smoothly, get stuff done quick, and will not need to explain you manager or clients that you need to day to sort out the code because it has became too messy. 

If you want to share your best practices to keep the codebase clean hit me up on Twitter [@mokagio](https://twitter.com/mokagio), or leave a comment below. And if you need help refactoring a messy codebase or want a deeper look at how to use tools like git to work in a cleaner way, [get in touch](mailto:gio+refactoring@mokacoding.com), I'm always happy to help.

_Leave the codebase better than you found it._

