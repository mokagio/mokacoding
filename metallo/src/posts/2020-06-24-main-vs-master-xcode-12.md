---
title: 'Should you change your branch name to "main"?'
description: "In Xcode 12, the default branch name is main instead of master. This little language change has deeper implications and stirred up an hornets'."
og_image: "https://mokacoding.s3.amazonaws.com/git-branch-m.png"
---

The short answer is yes.
It's a small change and easy to make, it won't disrupt your workflow, but has the possibility of making a group of people feel a bit more comfortable.

But don't delude yourself that by doing this you're fighting racism.
You're not.

There's a _real_ work to do out there.
Unless you make this the first step in the long journey, the branch name will be the only thing that changed.

---

The other night, I noticed that when the new Xcode 12 sets up the Git repo for a new project, it uses `main` instead of `master` as the branch name.

I eagerly [tweeted](https://twitter.com/mokagio/status/1275403354324303873) my discovery.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Xcode 12 creates new repos with `main` instead of `master`.<br><br>Well done <a href="https://twitter.com/Apple?ref_src=twsrc%5Etfw">@Apple</a> 🙌🏻🙌🏼🙌🏽🙌🏾🙌🏿 <a href="https://t.co/7ql1DBUIvr">pic.twitter.com/7ql1DBUIvr</a></p>&mdash; Gio 💻🔧📚 (@mokagio) <a href="https://twitter.com/mokagio/status/1275403354324303873?ref_src=twsrc%5Etfw">June 23, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

I woke up to more than a hundred mentions.
People got very passionate about it, the haters and the trolls were unleashed.

I didn't reply to the tweets.
Twitter is not the place to have constructive conversations on difficult topics, as many of the comments show. The medium is too constrained for deep thinking.

I'd like to say a few words here, though.


Moving away from the name `master` in repositories is a recent trend it tech.
[GitHub is working on a similar change](https://www.theregister.com/2020/06/15/github_replaces_master_with_main/) and so is [Automattic](https://automattic.com), where I work.
WordPress.org has already [opted to use `trunk` ](https://make.wordpress.org/core/2020/06/18/proposal-update-all-git-repositories-to-use-main-instead-of-master/) instead.

The topic of language in software development is older, though.
For example, 6 years ago the Django web framework [replaced all occurrences of "master/slave" with "leader/follower"](https://github.com/django/django/pull/2692).

Does changing a few names in your codebase "end racism"?
No.

Is it going to have a meaningful impact on society or even just tech?
No.

Is it just theater, doing _something_ just to show that something is being done? Possibly.

**Is it something worth doing?
Yes.**

It's not a matter of being politically correct.
It's a matter of building a more inclusive environment, one step at a time.

The words you use make a difference in the results you get.
Marketers know it well, using the right wording can make or break the sale numbers.

[A Stanford study](https://nlp.stanford.edu/pubs/pryzant2017sigir.pdf) shows that in Japan, products sell best if their advertising uses polite language and words that invoke cultural tradition.
[Another study](https://onlinelibrary.wiley.com/doi/full/10.1111/cogs.12637) shows that if you want to encourage girls into STEM subjects, using a statement like "girls are as good as boy at math" will actually achieve the opposite result, reinforcing the stereotype that boys are better than girls.

> [I]n some ways, implicit messages might shape beliefs more powerfully than explicit messages that express the same ideas.

**Using a more inclusive language is the first step to build an inclusive world.
Not the only step, not the most impactful one, but a step nonetheless.**

And if this argument is not enough for you, what about just ~~not being an asshole~~ being kind?
_See how I changed my language to make the message positive there?_

Rob Napier [puts it well](https://twitter.com/cocoaphony/status/1275494069024817155):

> If someone tells you that a term is offensive, you should start with the assumption that they're correct, and behave accordingly, unless you have some good reason to think it's in bad faith.

Not everybody has the same background as you do.
Just because something does not affect you, it doesn't mean it does not affect other people.
How would you like it if words that are offensive to you were thrown around all the time?
Do you really think you could just _toughen up_ and move on?

Religions across history have a common thread in the so called [golden rule](https://en.wikipedia.org/wiki/Golden_Rule): "_Do not treat others in ways that you would not like to be treated_".

The beauty of the golden rule is that there's nothing mystical to it.
You don't need to be religious to appreciate it's effectiveness.

The folks at [Thoughtbot](https://thoughtbot.com/blog) went through something similar when they renamed their popular library from `factory_girl` to `factory_bot`.
The name was [meant as a nod to the factory method and the object mother patterns](https://github.com/thoughtbot/factory_bot/pull/943/files), but the female gender in such a male-dominated space as tech made some people uncomfortable.
They [eventually changed it](https://thoughtbot.com/blog/factory_bot#why):


> We concluded that, even though not everyone agreed, lack of concern from many shouldn't prevent the name being changed.
> Being clever shouldn't be favored at the expense of others feeling marginalized.

If such a small change as `git -m main` can have a positive impact, even if little, in the work life of some people with a concrete reason to ask for it, why not just doing it and move on?

But don't pat yourself in the back just yet.

**Changing from `master` to `main` doesn't mean you're fighting against racism and inequality.**
It is but a single step, and an easy one, too.

The cynical will say that this is only theater, smoke and mirrors.
If that's as far as you'll go, than that's true, it was just theater.

**But maybe, just maybe, we can make this tiny change be the first of many.**

The next one is [educating ourselves](https://anygoodthing.com/2020/06/14/what-is-racism/).
Another one is trying to understand [other people's point of view](https://dev.to/afrodevgirl/replacing-master-with-main-in-github-2fjf).
And the one after that is changing our companies from the bottom up by [lending our privilege](https://www.youtube.com/watch?v=hyiMathkUrQ).

Just don't go on Twitter and feed the trolls.
