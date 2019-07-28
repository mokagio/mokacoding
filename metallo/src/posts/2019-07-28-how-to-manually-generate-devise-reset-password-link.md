---
title: How to manually generate Devise reset password link
tags:
- Ruby on Rails
- Ruby
---

One of the users of one of a sort of SaaS I look after on the side reached out saying they couldn't reset the password.

Apparently, they did not receive the reset password email; it wasn't even in their spam folder.

The simplest thing to do was to generate a new reset password link and send it to them directly.

I use Ruby on Rails for my backend, with as little custom logic as possible.
Naturally, the authentication layer is taken care of by [devise](https://github.com/plataformatec/devise).

To manually generate a reset password link using devise, the first step is to log in your server and launch the Rails console.

```
bundle exec rails c
```

Once in there, ask devise for a new reset password token.
The call returns two values. The first is the raw token to use in the reset password URL query string, and the second is a hashed version of the token.

```
raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
```

For the reset password to work, you need to associate the token to the user that will use it.

```
user = User.find_by(email: 'john.doe@mysaas.com')
user.reset_password_token = hashed
user.reset_password_sent_at = Time.now.utc
user.save
```

Finally, you can share the URL. Unless you have customized your routes, it'll look like this:

```
https://mysaas.com/users/password/edit?reset_password_token=raw
```

Full credits for these steps to [this StackOverflow answer](https://stackoverflow.com/a/41790443/809944).
