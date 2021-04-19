---
title: A World Without Slack
tags:
- books
- productivity
- processes
---

When I first adopted Slack, it was a refreshing change of pace from bloated email threads where information would inevitably get lost.
Nowadays, I dread instant messaging; it's a major source of interruptions and distractions.
That's not directly Slack's fault, rather a byproduct of the frictionless communication it enables.
Is this how work looks like in the 21st century, or is there a way to do better?

[_A World Without Email_](https://geni.us/FylTA1) by Cal Newport, the author ofone of [the must-read books](https://mokacoding.com/blog/top-10-productivity-books/) for knowledge workers, _[Deep Work](https://geni.us/FITEF)_, explores this topic and offers a path forward to minimize unscheduled unstructured communications and maximize focus and productivity.

In this post, I want to share some ideas from the book and some food for thought for how they may apply to the world of software development.

<!--
**TL;DR**

Investing in processes that help people **avoid context switch and unscheduled unstructured communications** can greatly increase a company’s overall productivity _and_ employee’s satisfaction.

Knowledge work is only at the beginning of its optimization journey, experimenting together on our workflows could lead to incredible improvements.
-->


![Picture of the paperback version next to a long black coffee](https://s3.amazonaws.com/mokacoding/2021-04-18-awwe.jpg)

_Reading book to think big thoughts with a coffee to power them – one of my favorite activities._

## The Hyperactive Hive Mind

Let's get something straight: the book title is pure clickbait. Newport doesn’t argue for giving up email as a technology; he uses it as a proxy for the kind of unstructured, real time, communication-driven workflow that seems to power most knowledge businesses. He calls it the _Hyperactive Hive Mind_:

> **The Hyperactive Hive Mind**: A workflow centered around ongoing conversation fueled by unstructured and unscheduled messages delivered through digital communication tools like email and instant messenger services.

Most software shops I worked with ran without much use of internal emails, but they were still prey of the Hyperactive Hive Mind in the form of their IM tool of choice. That’s why, as an homage to the book, I gave my post the similarly clickbait title _A World Without Slack_.

The book is divided into two parts. The first explores the history of email and argues that constant unscheduled communication:

*   _Reduces productivity_, because of the constant context switching.
*   _Makes us miserable_, because of the feeling of being constantly on.
*   _Has a mind of its own_, in that no one decided that we should work in this fashion, it simply something that naturally evolved. He uses [technological determinism theory](https://en.wikipedia.org/wiki/Technological_determinism) to explain this phenomenon, which I found quite interesting.

Part 1 is packed with stories and noteworthy studies, but it’s on part 2, where Newport lays out principles and recommendations to avoid the Hyperactive Hive Mind that I’d like to focus.

## Attention Capital


At the dawn of the 20th century, industrialists like Henry Ford begun to experiment on new processes to improve the productivity of their factories by, among other things, better allocating their capital[<sup id="fn1-back">1</sup>](#fn1). At the time, the main capital of an industry was its materials and equipment. Some ways of deploying this capital yielded better productivity than others, and so Ford ended up with the assembly line.

In the knowledge sector, the biggest capital is the brains of the employees that “add value to information”. This kind of capital is more abstract than that of a factory producing a car, but the same principle holds true: different ways of allocating it yield different productivity outcomes.

> The productivity of the knowledge sector can be significantly increased if we identify workflows that better optimize the human brain’s ability to sustainably add value to information.

The legendary business thinker Peter Drucker said[<sup id="fn2-back">2</sup>](#fn2) that knowledge work is at the state factory work was at the start of the 20th century. We’re just scratching the surface of what our brains can achieve together.

And yet, most of us accept the frustrating background chatter of IM as the status quo, a necessary evil of success in the modern age.

> It’s this mindset that leads to “solutions” like improving expectations around email response times or writing better subject lines. It leads us to embrace text autocomplete in Gmail, so we can write messages faster, or the search feature in Slack, so we can more quickly find what we’re looking for amid the scrum of back-and-forth chatter. These are the knowledge work equivalents of speeding up the craft method of car manufacturing by giving the workers faster shoes. It’s a small victory won in the wrong war.

We need bolder experiments that maximize a company’s attention capital.

One recommendation is to **build structure around autonomy**. Software developers thrive when given autonomy. In his book [_Drive_](https://geni.us/LnEuG), Daniel H. Pink puts it alongside mastery and purpose as the trifecta to keep employees motivated and fulfilled. Still, autonomy's value doesn't mean it's exempt from critical observation.

To explain what it means to put structure around autonomy, Newport defines knowledge work as composed by work execution and workflow.

> **Knowledge work = work execution + workflow**

Work execution is the act of adding value to information: the programmer coding, or the designer synthesizing user reports to adjust the UI. Workflow is how these activities that generate value are “identified, assigned, coordinated, and reviewed.”

We need autonomy in how we execute our work, but we can all do with a clear workflow to structure our efforts and better allocate our attention capital.

> To get the full value of attention capital, we must start taking seriously the way we structure work. This doesn’t stifle the autonomy of knowledge workers, but instead sets them up to make even more out of their skill and creativity.

The way to do this is through processes and protocols.

## Processes & Protocols

> **The Process Principle**: Introducing smart production processes to knowledge work can dramatically increase performance and make the work much less draining.

One process Newport recommends in the book is using Kanban-like task boards. He shares a case study of how the team at [Optimize](https://href.li/?https://www.optimize.me/) produces their weekly videos. The production flow is split in various steps, starting from the first draft of the script and finishing with the upload to their website. Each step is a column in a spreadsheet and each step has an artifact as its outcome, uploaded in a predefined Dropbox folder. The team members look at the spreadsheet and, if there’s an item in a state they can work on, pick it up to transform it into the next artifact.

In my day job as a mobile infrastructure engineer at [Automattic](https://automattic.com/), I’m involved in the mobile apps [release process](https://href.li/?https://mobile.blog/2019/05/06/wordpress-mobile-apps-the-heartbeat-release-process/). At predefined dates, the release manager starts the code freeze and posts the process checklist on a dedicated [P2](https://wordpress.com/p2/). Quality engineers monitor that P2 and know when a build has been shipped and it is time for them to start they exploration and testing.

Whether you use a task board software like [Trello](https://trello.com) or [Asana](https://asana.com/), a spreadsheet like the folks at Optimize, or a post with a checklist like my team does, they key idea is to **describe your workflow as a state machine**: a finite set of states with clear transitions, outcomes, and owners. This way, everyone involved can observe the work progress and interact with it without initiating ad hoc communication.

Processes are excellent when the production of value has a deliverable, a blogpost, a video, a new version in the app stores, but there are many occasions where there is no artifact being produced,  that’s particularly the case for communication. The solution, the author argues, is to define clear “protocols”.

To introduce protocols, Cal Newport uses [Information Theory](https://href.li/?https://en.wikipedia.org/wiki/Information_theory). One of the key insights in Claude Shannon’s seminal work that literally created the whole discipline was the probabilistic nature of communication: certain symbols are more likely to be sent than others. It follows that if we build a code where it’s cheaper to send the more frequent symbols, our communications will be more efficient than if all symbols had the same or random cost[<sup id="fn3-back">3</sup>](#fn3).

Investing time upfront in designing optimized encoding for information pays off in the long run because transmission is more efficient. In the same way, we can greatly benefit from putting in place rules for how communication happens and work.

> **The Protocol Principle**: Designing rules that optimize when and how coordination occurs in the workplace is a pain in the short term but can result in significantly more productive operation in the long term.

One area ripe for the introduction of a protocol is meeting scheduling. If you are in a position where your job requires more than a couple of scheduled meetings per week, invest in a scheduling service like [Calendly](https://calendly.com/) or hire an assistant to stop playing _calendar Tetris_ for each of your appointments.

[Office hours](https://href.li/?https://www.fastcompany.com/90610764/completely-had-it-with-email-give-personal-personal-office-hours-a-try) are another protocol suggested in the book, this time to regulate how to ask questions. If you are a subject matter expert and the kind of person that [never passes up an opportunity to help a colleague](https://automattic.com/creed/help-a-colleague/), you may end up in a situation where people ask you questions at random times during the day. Not answering can be rude but staying on top of all of them introduces distractions and context switching. The solution: publish predefined times where you’re available to answer questions.


## Specialization is valuable

The book's underlying theme is that to do our best work without feeling overwhelmed by the buzz of constant communication we need to **maximize the time spent doing work and minimize the time spent between inboxes**. We can do that by reducing context-switching and avoiding unstructured unscheduled communication as much as possible. Working in a sequential and specialized manner is crucial towards that goal.

> **The Specialization Principle**: In the knowledge sector, working on fewer things, but doing each thing with more quality and accountability, can be the foundation for significantly more productivity.

One recommendation from the book is to have an attention budget. With your manager, define a fixed budget for the activities that do not produce direct value and work together to ensure you don’t go over it.

Another idea regarding specialization is that, given how valuable it is, it’s baffling how we reduced it in our work since technology has simplified many support roles.

> [Economics] textbooks used to introduce the idea of efficient labor markets by telling the story of the best lawyer in town who also happens to be the best typist.
>
> The obvious conclusion of the textbook story is that the lawyer would be foolish to not hire a typist. If the lawyer bills $500 an hour and a typist costs $50 an hour, then the lawyer will clearly end up better off outsourcing the typing so she can spend more time on legal work. The arrival of computers in the workplace, it seems, obscured this once obvious reality. We’ve all become the lawyer spending hours at the typewriter.

Drawing again from the processes I’m involved in, I wonder if tasks such as triaging the requests that come into our team or hitting the button that starts the phased release of a new version of the app is something a smart intern could do at least 80% as well as I currently do. Before reading the book, I would have feared being called lazy for suggesting this, but I now think there is a good economic reason for delegating less specialized tasks.

---

If I were to summarize the book’s recommendations in a sentence I would say that **for a knowledge company to be successful, it needs to constantly optimize how work is done, so it can minimize context switching and unscheduled unstructured communication in favor of focus and sequentiality**.

Since finishing [_A World Without Email_](https://geni.us/FylTA1), I’ve been on the lookout for ways to improve my personal workflows from that point of view, and to avoid being a source of distraction for my  colleagues. 

But there’s only so much that optimizations at the personal level can achieve. It’s time for teams and leaders to discuss how to do better and refine their workflows. Let's explore and experiment, make mistakes and learn from them.

I wholeheartedly recommend the book, this post is but a poor summary and touches only on some of its many valuable ideas and prompts. For a richer sample, the author has [a 5 videos series in which he elaborates on the key concepts](https://www.calnewport.com/emailacademy/).

What workflows are you deploying right now? What are your techniques to minimize context-switching in favor of focused work? I'd love to hear from you! Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

_P.S. This is an edited version of a post I originally shared in one of Automattic's internal P2s. We are constantly experimenting and refining our workflows and take ideas such as those from the book very seriously. If that sounds interesting, checkout our [remote jobs page](https://automattic.com/work-with-us/) or get in touch with me._

### Footnotes

<span id="fn1">1</span> - Ford's experiments to better allocate his capital culmintated into the assembly line. For an in-depth look at the story, see [_The Perfectionists: How Precision Engineers Created the Modern World_](https://geni.us/XO9cbnT), one of the book's sources. [↩️](#fn1-back)

<span id="fn2">2</span> – Peter F. Drucker, [“Knowledge-Worker Productivity: The Biggest Challenge,” California Management Review 41, no. 2 (Winter 1999)](https://href.li/?https://cmr.berkeley.edu/search/articleDetail.aspx?article=4872). Following the link ends up in a paywall – _with a bit of patience on Google, the original can still be found_. [↩️](#fn2-back)

<span id="fn3">3</span> – Mine is a gross simplification (with possible misrepresentations) of Shannon’s work. If you’re curious on the topic, you’ll enjoy _[Mind at Play: How Claude Shannon Invented the Information Age](https://geni.us/FqRN7P)_, another of the book's sources. [↩️](#fn3-back)
