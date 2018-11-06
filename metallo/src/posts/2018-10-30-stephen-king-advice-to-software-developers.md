---
title: "Stephen King's Advice To Software Developers"
description: 'In "On Writing" Stephen King shares invaluable lessons for aspiring novelists which can be applied to software development too.'
tags:
  - Books
  - Quotes
  - Productivity
---

If you have ever read a book by [Stephen King](https://twitter.com/stephenking) you'll know he's a master story teller. His books are page turners, you can't get your nose out of them. The characters grow under your skin and keep following you way past the end of the book.

King published [On Writing](https://amzn.to/2JoNgzh) in 2000. Subtitled "a memoir on the craft", the book is part autobiography part manual on the art of writing.

While most of the content is targeted to aspiring fiction writers, there is a lot that can be applied to software development too.

## Read A Lot, Write A Lot

The first advice to aspiring writers is to read a lot and write a lot.

> If you want to be a writer you must to two things above all others: read a lot and write a lot. There's no way around those two things that I'm aware of, no shortcut.

Stephen King recommends to read more than your write, in a 10:1 ratio. Read a lot of anything, he says.

Reading provides many benefits to the writer. It improves the vocabulary, gives inspiration, and allows them to compare with other authors.

This advice applies to software developers as well. To become good at writing code you need to read a lot of code, and a lot of resources about code. How to do this? Here's some ideas:

- Look into the source code of the open source libraries you use the most.
- Participate in code reviews across your company, even when you're not asked to review, even for teams other than your own.
- Read blogs like this one. Don't know where to start? Google your programming language of choice + weekly newsletter, pick one that sounds interesting, and browse through the latest issues.
- Read books. Don't know where to start? Checkout [Clean Code](https://amzn.to/2JoOj2b), [The Pragmatic Programmer](https://amzn.to/2D9CLzw), or [7 Programming Languages in 7 Weeks](https://amzn.to/2yHDT9E)

You need to feed your mind with food for thought. New techniques, different opinions from your own, concepts that you might find hard to grasp. This will keep you learning and nimble.

Now that we got the reading sorted, how about the writing? Sorry to break it to you, but if you want to get good only writing code at work won't cut it.

The main reason is when working you seldom have the time to stretch outside of your comfort zone, and really try new things.

If you want to master a design patter like [Clean Architecture](http://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) or a workflow like [Test Driven Development](https://www.mokacoding.com/blog/red-green-and-dont-forget-refactor) you need to [practice deliberately](http://calnewport.com/blog/2010/01/06/the-grandmaster-in-the-corner-office-what-the-study-of-chess-experts-teaches-us-about-building-a-remarkable-life/) at it.

Some techniques are:

- Rewriting the same application a number of times with slight variations of the architecture, concept, or workflow you are trying to learn.
- Practicing [code katas](http://codekata.com/) or following tracks on [Exercism.io]()https://exercism.io).
- Reimplementing the work of other people to learn from them.

Read a lot, write a lot. This is the foundation on which to build a great career as a software developer.

## Avoid distractions

Stephen Kings works in a methodical and regular way.

> My own schedule is pretty clear-cut. Mornings belong to whatever is new -the current composition. Afternoons are for naps and letters. Evenings are for reading, family, Red Sox games on TV, and any revisions that just cannot wait.

He is not the only creative mind that does this. Many boast the benefit of having fixed times in which to do things.

> Your job is to make sure the muse knows where you're going to be every day from nine 'til noon or seven 'til three.

He recommends having a dedicated space where to write, and to be ruthless about fending any possible distraction.

> If possible, there should be no telephone in your writing room, certainly no TV or videogames for you to fool around with. If there's a window, draw the curtains or pull down the shade unless it looks out at a blank wall.

In today's working environment distractions are the norm. Often we revert to working in a reactive mode. We start doing something, then someone asks for attention and we give it to them, then someone else, then someone else.

There are two big disadvantages in this process.

- By constantly shifting your attention you prevent yourself from reaching a state of deep focus, paying a mental context switching cost every time.
- By always reacting to others' requests and priorities you loose control over your own. You are letting other people decide what's important for you.

Granted, Stephen King has complete control over his time. You and I have a boss and a team to answer to. But you can still have some control over your schedule.

Every morning look at your calendar and identify the times where there are meetings. You can't do anything about them but you do have control over the rest of the day. Make a point of setting aside at least 2 uninterrupted hours to focus on doing the work that is most important for you.

If you have a shared calendar block that time in there. Try to finding a remote corner of the office, or café or library if you have the privilege to be able to work outside your office, to help isolating and reaching a better state of focus.

## Door shut, door open

When describing his writing process Stephen King splits it in two main parts. First with the door closed, then with the door open.

Writing with the door closed is the first step in the creation of every story.

> The closed door is your way of telling the world and yourself that you mean business; you have made a serious commitment to write and intend to walk the walk as well as talk the talk.

> With the door shut, downloading what's in my head directly in the page, I write as fast as I can and still remain comfortable.

The safety of the door close means the author can be unrestrained, focusing only on putting words on page. With the door closed you can build the skeleton of the story and refine it till it can "stand on its own". Once this is done the office door can be opened and the story can be shown to the world.

Writing with the door open is the refinement process, one in which the story gets streamlined, removing all the unnecessary parts to make it focus only on what really matters.

When writing code you can go through a similar process. Writing code with the door closed means messing around, making hacks, using suboptimal solutions. What matter first is to get to an implementation that works, so you can go through the learning of seeing it working end to end.

Once this is done it's time to refine the code. This might very well mean rewriting big chunks of it. It's time to make it fit in the context of your codebase, removing the hacks, thinking about maintainability.

It's does take as long as it might seem. When practicing TDD you can go from defining the rough skeleton of your code to refining it removing hacks in a few minutes. It all happens at the scale of single functions or objects.

Finally you can open the doors, sharing your code with the rest of the team through the code review process. Hopefully your team mates will suggest improvements and refinements. That's good. Code reviews with a "✅LGTM" and no comments are a wasted opportunity to make the code better and learn something.

## Kill your darlings

Stephen King describes how he aims to make the second draft of his stories 10% shorter than the first, and to keep shortening the story with each revision.

This often requires getting rid of sentences, paragraphs, scenes, or even characters the author loved and thought necessary for the story, but early readers or the editor revealed being unnecessary.

> Kill your darlings, kill your darlings, even when it breaks your egocentric little scribbler’s heart, kill your darlings.

In the article [you are not ruthless enough](http://playswithfire.com/blog/2012/02/19/you-are-not-ruthless-enough) [Chris Parker](https://twitter.com/ctp) shares a similar view on how software developers should treat their code.

Software developers are often proud of what they write. Maybe you've been particularly clever in solving a problem, only to learn there's no need for it anymore. Or you've been working a lot on a feature that has been revealed unnecessary. It's tempting to hang on to these darlings, but the best thing to do is to get rid of them.

Code is liability. The more code you have the higher the chances of bugs coming out of it. Code needs to be maintained. Migration to new framework or language versions can be painful. Don't forget that Git will remember your code existed anyway. You'll always be able to find it if you'll need it in the future.

## It takes time

Stephen King started toying around with writing stories at age 6. In his teens he started submitting stories to magazines.

> By the time I was fourteen the nail in my wall would no longer support the weight of the rejection slips impaled upon it. I replaced the nail with a spike and went on writing.

At 16 he was still being rejected, but the rejections started having positive comments and encouragement to keep going.

For years years he received nothing but rejections, yet he kept going. Refining his skills, while keeping reading books and comics, and watching horror movies at the cinema.

Mastering software development in a given programming language or framework takes time too. There are no shortcuts or hacks. You can't expect to become proficient in a few weeks, and this should not discourage you.

---

As software developers you should aim to write a lot of code deliberately, and read more code and resources than that. Cut out time away from distraction to focus on your craft. Be ruthless in your work, code is a liability, strive for simplicity. Remember this is a journey, it takes time, enjoy every step of it.

Every software developer should read [On Writing](https://amzn.to/2JoNgzh). You might not be interested in writing fiction, or event blog posts, but as Stephen King would say "you could do worse" than following his journey to mastery and reading his advise on how to work in a structured, focused, and deliberate way will still.

Let me leave you with one final quote from Stephen King:

> But if you don't want to work your ass off, you have no business trying to write well.

_If you enjoyed this post with key takeaways from On Writing you'll like my [monthly newsletter](https://mokacoding.us10.list-manage.com/subscribe?u=45a265e2a9d2b9dbec5f98d51&id=325d8c0fd4) where I share lessons learnt and food from thought from the books I've been reading. [Subscribe here](https://mokacoding.us10.list-manage.com/subscribe?u=45a265e2a9d2b9dbec5f98d51&id=325d8c0fd4).
