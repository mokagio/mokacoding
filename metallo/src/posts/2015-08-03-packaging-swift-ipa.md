---
layout: post
title: Packaging an ipa with Swift files from the terminal
description: "If you are having problems with xcodebuild failing to export your apps with either Swift or Watch Kit support here's the solution, with a handy custom script."
date: 2015-08-03
tags:
- Espresso
- Swift
- Automation
- TestFlight
---

One day I saw this tweet from my friend [Marco Sero](http://marcosero.com/)

<blockquote class="twitter-tweet" lang="en"><p lang="en" dir="ltr">Shout-out to <a href="https://twitter.com/phatblat">@phatblat</a> who today saved me a lot of time adding Swift support to the Yammer app with his script <a href="https://t.co/oEwdRVaeDq">https://t.co/oEwdRVaeDq</a></p>&mdash; Marco Sero (@marcosero) <a href="https://twitter.com/marcosero/status/623418915033628672">July 21, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

It looked liked something I should have take note of. So I obviously forgot about it.

Some days ago I set up the automated build distribution pipeline for a new client, with an app using a bit of Swift. I usually use something similar to [this script](https://gist.github.com/mokagio/bae969dd8e3846ef7773). It is a pretty battle tested script, but something when wrong.

And that's when I remembered Marco's tweet and [phatblat](https://twitter.com/phatblat)'s script.

Download the raw script [from here](https://gist.githubusercontent.com/phatblat/6eb8895e2202f796960e/raw/264765c05ecc8918425cb513b12409de91e3a675/package-ida.sh), place it somewhere, maybe in the project's root, then simply replace the `xcodebuild -exportArchive` command with:

```
bin/package-swift-ipa.sh "$archive_path" "$(pwd)/$ipa_path"
```

Notice the `$(pwd)` in the second argument. That's because the script is expecting absolute paths, while mine uses relative ones.

_Leave the codebase better than you found it._
