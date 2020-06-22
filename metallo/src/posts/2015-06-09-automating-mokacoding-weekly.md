---
layout: post
title: MailChimp automated workflow for mokacoding weekly
description: "At mokacoding we're big on automation, and we eat our own dog's food! The workflow to write and send new issues of our newsletter, mokacoding weekly, is (partially) automated thanks to some simple Ruby scripting and Mac command line utilities."
tags:
- Automation
- Productivity
---

This week on [mokacoding](https://www.mokacoding.com) we are going to keep Xcode closed, the iPhones in our pockets, and look at the [automated workflow](https://github.com/mokacoding/mokacoding-weekly) that we use to create "mokacoding weekly", the newsletter that every week reaches your inbox with the latest articles from the blog and other interesting links from the testing, automation, productivity, and software development world.

At the end of March 2015 "mokacoding weekly" issue 1 was sent to 49 subscribers.

The newsletter is sent with [MailChimp](http://mailchimp.com/), which has a WYSIWYG/HTML editor for the email content.

Issue number 2 was sent out by duplicating the campaign made for the previous one, and by changing the content.

That wasn't a fun experience, the format kept changing for no reason, and it was hard to set it back to the original one. Even after discovering that you can write raw HTML in the editor, the situation didn't improve. After working with [haml](http://haml.info/) or [jade](http://jade-lang.com/]) old school HTML is too cumbersome.

A good automation rule of thumb is _"[three strikes and you automate](http://c2.com/cgi/wiki?ThreeStrikesAndYouAutomate)"_, if you have to do something that you already did two times, automate it. And that's why before it was time to send out issue number 3 an automated workflow was put in place. You can have a look at it on [GitHub](https://github.com/mokacoding/mokacoding-weekly).

Taking care of the layout being the bigger pain point at the time, that's the first issue that this automate workflow tries to solve, or at least smooth. The question was **how can we avoid writing HTML, but still have good formatting?**

The answer was easy, it'd be great to write in [Markdown](http://daringfireball.net/projects/markdown/) the same way I can do for[this blog](http://github.com/mokagio/mokacoding/tree/gh-pages/metallo/src/posts).

The [redcarpet](https://github.com/vmg/redcarpet) gem allows you to parse `.md` files in valid HTML ones, and it also comes with a command line interface.

```
redcarpet mokacoding-weekly-003.md mokacoding-weekly-003.html
```

To keep the amount of editing as little as possible I extracted the header and footer common to every issue in two files. These can be appended and prepended to the one with the real content, which is the only one that changes.

```
redcarpet header.md mokacoding-weekly-003.md footer.md
```

To avoid typing that long command every week there is a [Rake](https://github.com/ruby/rake) task, `rake build`, that does it for us.

Now to we can simply write the new issue content with the comfort of the markdown syntax, type `rake build`, and paste the output into MailChimp.

## Even more automation

This workflow is already better that doing everything manually... but it can still be improved!

One point that can could be talked is the copy-paste of the content. Why should one select and copy the generated HTML output manually? Let's make it automatic.

Mac OS X provides a nice command, [`pbcopy`](http://superuser.com/questions/288320/whats-like-osxs-pbcopy-for-linux) to copy text input to the Clipboard.

```text
redcarpet ... | pbcopy
```

That's better 😎

Another manual task is the numbering. Is it really necessary to remember the number of the previous issue, or have to look it up? Let's make it automatic.

```ruby
task :new do
  # count how many issuse we have already and increment by 1
  next_number = '%03d' % (Dir["#{issues_folder}/*.md"].length + 1)

  path = "#{issues_folder}/mokacoding-weekly-#{next_number}.md"
  sh "touch #{path}"
end
```

Done, no need to count any more, simply type `rake new`.

We can go even further! Why should one open the text editor? Let's make is automatic! The Rake task can be modified by adding the following line after the file has been generated.

```ruby
sh "#{ENV['VISUAL']} #{path}"
```

Which will open the newly created markdown file using the text editor set in the `VISUAL` environment variable.

Using the env var is cool, it makes the workflow agnostic of the text editor.

That's more or less it. The workflow consist in only two shell command and a Cmd-V, _plus all the MailChimp release steps_.

## Where to go from here

This workflow is working quite well for mokacoding weekly, but there are still places in which it could do better. Some ideas on even more automation could be:

* Use a template for the content.
* Automatically pick title, link, and description of the mokacoding links from the blog.
* Generate the titles and links for the other entries from a reading list assembled during the week.
* Automate setting the content and sending the mailing list, if it's possible with the [MailChimp APIs](http://kb.mailchimp.com/api/resources) or maybe using tools like [Phantom.js](http://phantomjs.org/)

---

I hope that this post will set some wheel in motion on your head, to automate some of the more mundane tasks of your workflow.

You can use the comments below or tweet [@mokacoding](http://twitter.com/mokacoding) to let us know if you do, or if you have any tip for the MailChimp setup. And of course, don't forget to [subscribe](/#subscribe) to mokacoding weekly!

_Happy coding, and leave the codebase better than you found it._
