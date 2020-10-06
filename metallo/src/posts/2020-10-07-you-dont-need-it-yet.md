---
title: You Don't Need It Yet
tags:
- Software Design
og_image: https://mokacoding.s3.amazonaws.com/2020-10-07-mvp.jpg
---

YDNIY, You Don't Need It Yet, is a principle to ship software on a schedule [proposed by Itamar Turner-Trauring](https://codewithoutrules.com/2020/09/18/ydniy/).
Applying it consistently will benefit you beyond merely staying on track with a pre-committed schedule, though, it will help you learn and shape your software.

The idea behind YDNIY is that if a feature, or part of it, is not required to make your product useful, you can delay implementing it and ship something valuable to the users.
This is not limited to the first version of your product: **keep refining the value you offer one strictly necessary change at a time, providing the users with a steady drip of improvements**.

Itamar uses his [Python memory profiler library `fil`](https://pythonspeed.com/products/filmemoryprofiler/) as an example of how to apply YDNIY.
The first public version was installable only via [`pip`](https://pypi.org/project/pip/), run only on Linux, and could profile only complete program runs.
This version was obviously incomplete and not that powerful, but it still delivered something useful to some users.
In the following releases, Itamar added more and more features, all of them useful and core for a memory profiler, but none critical enough to prevent delivering something valuable to the users before it was finished.

YDNIY is similar to YAGNI, You Ain't Gonna Need It, the principle of writing only code that is motivated by a current requirement, not ideas of what the software might need to do in the future.
Both help us write less software and ship faster.
The difference is that where YAGNI is a ruthless elimination of anything but the necessary, YDNIY is a careful consideration of what is necessary _right now_ and what can wait instead.

YDNIY has some resemblance with the MVP, Minimum Viable Product, approach, too, but, as Itamar puts is, "the goal of the MVP is to learn about users or customers, whereas the goal of YAGNI and YDNIY is to get something useful into users' hands as quickly as possible."

While it's true that YDNIY is not as explicitly about learning as MVP is, **delivering something useful into users' hands as soon as possible can generate even more learning than an MVP**.

Developing a product in small iterations, each refining the way it solves a problem, is the foundation of the [Earliest Testable/Usable/Lovable](https://blog.crisp.se/2016/01/25/henrikkniberg/making-sense-of-mvp) approach created by Henrik Kniberg "improving on MVP".

> What is the cheapest and fastest way we can start learning?
> Will [this incomplete but functional version of our product] help solve the customer's problem?
> Maybe, maybe not, but we'll definitely learn something by putting this into the hands of real users.

In fact, Itamar library's changelog resembles Kniberg's famous "skateboard, scooter, bicycle, motorbike, car" example of Earlier Testable/Usable/Lovable iteration.

![The Earliest Testable/Usable/Lovable model applied to the process of building a car](https://mokacoding.s3.amazonaws.com/2020-10-07-mvp.jpg)
_Image via Henrik Kniberg's [original post](https://blog.crisp.se/2016/01/25/henrikkniberg/making-sense-of-mvp)._

As such, Itamar is selling YDNIY short when he says it's more about shipping fast than learning.
Carefully delaying the implementation of features and components that are not immediately necessary to ship something useful to the users sooner is precisely the kind of approach that generates learning when followed with feedback requests to the users.

Successful bootstrappers know a lot about applying YDNIY and moving in small iterations focused on gaining insights from their customers.
When you quit your day job to start your own business, your income depends on how many customers you can get.
The ability to ship something valuable (that people will pay for) fast (before your savings run out) is the difference between staying in the game and having to leave before you can make your play.

[Ben Orenstein](https://twitter.com/r00k), co-founder and CEO of [Tuple](https://tuple.app/), a pair programming app, has been sharing his bootstrapping journey since inception in [The Art Of Proudct](https://artofproductpodcast.com/) podcast.
Like Itamar's `fip`, Tuple launched on only one platform: macOS.
At the time of writing, it still doesn't offer Linux or Windows clients.
This is clearly a limitation to the possible userbase for the app, but the company provides a smooth and reliable remote pair programming experience to enough developers on macOS to be profitable and growing.

Several times in the show's history, Ben has bounced the idea of building clients for other platforms.
"Do we need it yet?"
The answer, for the moment, is still no.

Had Ben and his team decided that it was necessary to ship the first version of Tuple with support across platforms, the company's trajectory would have been very different.
Remote pair programming involves real-time streaming of and interaction with the users' screen; making it work cross-platform is not a simple feat.
Getting that right might have taken too much time, eating up the founders' savings, possibly ending up in that section of the startup cemetery reserved for those burnt their runway before their product ever saw the light of day.

**You Don't Need It Yet is a purposeful restraint of what you decide to build in the interest of delivering value to the users as soon as possible.**

It goes against the perfectionist nature shared by most software developers.
To practice it, you need to be comfortable with being uncomfortable about your product's completeness, because you'll need to ship something clearly unfinished.

When applied to a new product or a new complex feature, and paired with a fast-feedback mindset, YDNIY will help you learn and guide your development towards adding value on every iteration.

Next time you sit down to write some code or flesh out a product idea, ask yourself, "do I need this yet?"
What are you trying to solve, and what do you need to learn?
Try to think of ways to build a smaller version of what you want to achieve, something you can ship as soon as possible to validate your assumptions.
