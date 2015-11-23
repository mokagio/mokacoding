---
layout: post
title: Opening a PR to Bitbucket from the terminal
description: A simple script you can run to open a PR on BitBucket for your current branch.
tags:
  - Espresso
  - Automation
  - BitBucket
---

One can't always use [GitHub](https://github.com) to store their code, in some cases other solutions have to be used, most likely imposed by some big obtouse company. One of such solutions is [BitBucket](https://bitbucket.org).

One thing I love about GitHub is how easy it is to create a pull request. You can go on the project's repo and see the button to do it if you recently pushed on a branch that is not the main one, or use the [`hub` gem](https://github.com/github/hub) and do it from the terminal.

Once you get used to this convenience switching to BitBucket can be quite annoying.

I wrote a simple little script to open a PR to a BitBucket repo from the terminal:

```bash
#!/bin/bash

org=YOUR_ORG
project=PROJECT_NAME
branch=$(git rev-parse --abbrev-ref HEAD)

open "https://bitbucket.org/${org}/${project}/pull-request/new?source=${branch}&t=1"
```

Running this script, which I usually call `pr.sh`, will open your browser on a configured page to create a pull request on BitBucket.

Unfortunately you have to specify the organization and the project name in the script. This is quite annoying, but is a one off operation.

If you use this script, or have a better solution to suggest, please hit me up on Twitter [@mokagio](https://twitter.com/mokagio), I'd love to hear your opinion.

## Update

I just realised that a simpler way to achieve the same result is to simply _**click with the mouse on the link that appears in the result of a push to a branch that is not master**_!. I guess it went a bit too far in my quest to never leave the home row 😳.

_Happy coding, and leave the codebase better than you found it._




