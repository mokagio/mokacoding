---
title: How to add co-authors to a Git commit
tags:
- Espresso
- Git
- GitHub
---

When pairing on code, it's great to make commits that are marked as authored by both delevopers.
There is a Git convention to do so, you can add the co-author(s) information in the commit message like this:

```
Co-authored-by: name <name@example.com>
```

[GitHub](https://github.blog/2018-01-29-commit-together-with-co-authors/) and [GitLab](https://gitlab.com/gitlab-org/gitlab-foss/-/merge_requests/17919) both support this syntax.

This is also handy when people open pull requests on your projects that you'd like to merge, but that need some extra work.
In those cases, I often start from scratch to ensure atomic commits and be able to run as many interactive rebases as I need.
To give credit to the original author, I use the co-author annotation in my commits.
