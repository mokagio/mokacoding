---
layout: post
title: Hacker News Button
description: How to add an Hacker News button to your blog
tags:
  - Espresso
---

You might have noticed that each post on mokacoding has an [Hacker News](https://news.ycombinator.com/news) button. Hopefully you even clicked it.

Adding a share to Hacker News button to your blog is super easy thanks to [the work](https://segment.io/) of the guys at [Segment.io](https://segment.io/).

You can go to their [Hacker News Button website](https://segment.io/) to use a wizard to configure the button and get the code, or use the same one I use for mokacoding.

[Jade](http://jade-lang.com/) version:

```jade
script.
  !function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');

a.hn-button(href="https://news.ycombinator.com/submit",
  'data-title'="#{post.title}",
  'data-url'="#{post.url}",
  'data-count'="horizontal",
  'data-style'="twitter").
      Vote on Hacker News
```

HTML version:

```html
<script>
  !function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');
</script>

<a class="hn-button"
  href="https://news.ycombinator.com/submit"
  data-title="POST TITLE"
  data-url="http://your.blog.com/post"
  data-count="horizontal",
  data-style="twitter">
  Vote on Hacker News
</a>
```

There you go. If you found this post useful I would really appreciate if you could hit my Hacker News button, and the ones next to it too 😎.

_Happy coding, and leave the codebase better than you found it._
