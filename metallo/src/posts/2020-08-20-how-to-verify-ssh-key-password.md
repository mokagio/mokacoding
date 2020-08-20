---
title: How to verify your SSH private key password
tags:
- Espresso
---

Today, I was working on an app with a UI that asks for an SSH key password.
When I put my password in, it didn't work.

There were no useful logs so I wondered if I used the wrong password.
I had the password for that key in 1Password (after years of creating SSH keys with fancy passwords only to forget about them), so I was positive the it was correct, but there was a chance I was using the wrong key file.

To verify my password, I used this command:

```
ssh-keygen -y -f /path/to/ssh_key
```

The `-y` option "will read a private OpenSSH format file and print an OpenSSH public key to stdout".
The `-f` option specifies the path to the private key.

If the private key is password protected, `ssh-keygen` will ask for the password.
