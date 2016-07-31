---
title: Cloud 66 Postfix Deploy Hook
description: A deploy hook to configure Postfix every time a Cloud 66 stack is built
tags:
- Espresso
- Cloud 66
- DevOps
---

The [Cloud 66](http://www.cloud66.com/) documentation to [install SMTP on a
server](http://community.cloud66.com/articles/installing-smtp-on-your-server)
is excellent and easy to follow, but glosses over how to write a deploy hook
to automate the process.

This is my take on a deploy hook to install SMPT through Postfix.

#### `deploy_hooks.yml`

```yml
---
production:
  first_thing:
    - source: /.cloud66/postfix_setup.sh
      destination: ~/postfix_setup.sh
      target: any
      apply_during: build_only
      execute: true
      sudo: true
```

#### `postfix_setup.sh`

```bash
#!/bin/bash

set -e

# Install Postfix to send emails
yet | sudo apt-get install postfix

# Configure Postfix
sudo echo "myhostname = yourdomain.com" >> /etc/postfix/main.cf

# Apply configurations
sudo /etc/init.d/postfix reload
```

This is the first deploy hook that I've ever written for Cloud 66, so if you
think there's a better way to achieve the result please get in touch through
Twitter [@mokagio](https://twitter.com/mokagio), or leave a comment below.

_Leave the codebase better than you found it._
