---
title: A distributed asynchronous release process
description: My latest post on mobile.blog explores two simple conventions Automattic uses to remove the need for synchronous meetings in their app release process.
tags:
- Distributed
- Processes
og_image: https://s3.amazonaws.com/mokacoding/2021-03-13-labels.jpg
---

![Screenshot of the cover of my latest post for mobile.blog](https://s3.amazonaws.com/mokacoding/2021-03-13-mobile-blog-cover.jpg)
<p>My latest post for <a href="https://mobile.blog/">mobile.blog</a>, <i><a href="https://mobile.blog/2021/03/12/two-simple-techniques-to-make-your-release-process-more-asynchronous-and-decentralized/">Two simple techniques to make your release process more asynchronous and decentralized
</a></i> shares a couple of conventions we use at <a href="https://automattic.com">Automattic</a> to ship the WordPress, WooCommerce, and Simplenote apps every two weeks with no sychronous meeting.</p>

Imagine you're about to package the release candidate for the new version of your app when you discover there are open PRs that look like they should make it into that build.
Also imagine that everyone else in your team is asleep because you live on the other side of the world.
How are you going to know whether you should wait for those PRs to be merged go ahead?

That's what happens to me every two weeks and what prompted me to write to share some of the tactics we use to deal with this situation to avoid delays or middle-of-the-night conversations.

As my day job, I work with a lot of smart folks from all over the world.
Automattic has been a distributed company since its inception.
When I say "from all over the world," I mean that literally, my division alone has people from _22 timezones_!

Being distributed across so many timezones makes it impossible to rely on synchronous meetings as the primary tool to take decisions.
There's never a (_reasonable_) time when everyone can online together.

This pressure made us develop several processes to get stuff done asynchronously.
As a mobile infrastructure engineer, one of those I'm most involved with is our apps' releases, scheduled every two weeks.
My team wrote about our [release process](https://mobile.blog/2019/05/06/wordpress-mobile-apps-the-heartbeat-release-process/) in the past.
Eli, our _Head of Apps_, also gave a [talk about it a try! Swift NYC](https://www.youtube.com/watch?v=CcPdDwz116k&ab_channel=try%21SwiftConference).

In my post, I drill down on two particular conventions using GitHub labels and milestones to communicate whether a PRs should be part of the new version of the app it belongs to.
I also talk about the different automation we put in place to remind contributors and reviewers about these conventions.

I think you'll like it.
Check it out [here](https://mobile.blog/2019/05/06/wordpress-mobile-apps-the-heartbeat-release-process/) and do let me know what you think.
