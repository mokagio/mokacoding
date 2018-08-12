---
title: '"Does Software Understand Complexity?" via Michael Feathers'
description: Thoughts on a Michael Feathers post on how the understanding of complexity in software development compares to other fields.
---

[Michael Feathers](https://twitter.com/mfeathers), author of [Working Effectively with Legacy Code](https://amzn.to/2MEI7Ef), shared a post on his blog titled "[Does Software Understand Complexity?](http://michaelfeathers.silvrback.com/does-software-understand-complexity)".

The post is a reflection on Feathers' experience at the 2018 edition of the [International Conference of Complex Systems](http://www.necsi.edu/events/iccs2018/). At the conference, Feathers says, he met many researchers from a wide spectrum of fields, each sharing techniques and mathematical models to understand and manage complexity in their field.

Feathers was surprised to be one of the few software people attending the conference. An interest and discipline for applied research seems to be lacking in the software world. Yet we could all benefit from it.

> There's a lot of knowledge outside our field that could be applicable to us - different ways of seeing problems and different frames we can apply to them.

I ask software developers I meet "[what is your biggest struggle with building software right now?](mailto:gio+struggle@mokacoding.com?subject=My biggest struggle with building software&body=My biggest struggle with building software right now is...)". An answer I often get is "managing complexity".

Complexity keeps creeping in every system we build, we seem unable to keep it at bait. I share Michael Feathers' hope that as an industry we'll start learning from other fields and develop a body of research based approaches to deal with complexity.

I can't help but being a bit cynical about it though. While preparing a refactoring workshop for [/dev/world/2018](https://devworld.com.au/) I've gone through [Working Effectively with Legacy Code](https://amzn.to/2MEI7Ef) one more time. A passage from the introduction caught my attention.

> Let’s do a little thought experiment. We are stepping into a large function that contains a large amount of complicated logic. We analyze, we think, we talk to people who know more about that piece of code than we do, and then we make a change. We want to make sure that the change hasn’t broken anything, but how can we do it? Luckily, we have a quality group that has a set of regression tests that it can run overnight. We call and ask them to schedule a run, and they say that, yes, they can run the tests overnight, but it is a good thing that we called early. Other groups usually try to schedule regression runs in the middle of the week, and if we’d waited any longer, there might not be a timeslot and a machine available for us. We breathe a sigh of relief and then go back to work. We have about five more changes to make like the last one. All of them are in equally complicated areas. And we’re not alone. We know that several other people are making changes, too.
>
> The next morning, we get a phone call. Daiva over in testing tells us that tests AE1021 and AE1029 failed overnight. She’s not sure whether it was our changes, but she is calling us because she knows we’ll take care of it for her. We’ll debug and see if the failures were because of one of our changes or someone else’s.

"Does this sound real?" asks Feathers afterward. The answer is yes. I've seen it, and still see it, in many work places. What's worrying though is the fact the book was published in 2004. **It's been 14 years** and we still seem to be facing the same problems. One would have expected to see some improvement in the mean time.
