---
title: "Git-iquette"
description: "Every team and every project should have a Git-iquette: a set of common practices for managing the git repository."
tags:
- Git
---

I'd like to suggest the introduction of a **_Git-iquette_** in every project, an etiquette in the version control usage.

I've recently started a greenfield project with a new client, with a team bigger than what I'm used to. As a team we discussed a coding styleguide, as set of rules and conventions to apply to both the style we use to code, the architectural choices, and the preferred patterns.

This is a very valuable thing to have, specially for a team. If everybody writes with the same style, it's gonna be easier for a reader of the code to understand different parts of the system, and to start working on a piece that hasn't been written by them.

I consider this an application of the [_"principle of least surprise"_](http://en.wikipedia.org/wiki/Principle_of_least_astonishment), the code I'm gonna read is written in the style I'm expecting, and the components in the system follow the same set of rules.

For these reasons having a set of rules on how to check-in code and how to manage the repository is incredibly valuable too.

In his article ["Every line of code is always documented"](http://mislav.uniqpath.com/2014/02/hidden-documentation/) Mislav Marohnić shows how by using `git blame` and `git show` he understood the reasons behind a cryptic line of code, and how important it was for the behaviour of the software.

The repository is the history of the codebase. Some TV shows have a "previously on ...", that's the same when we read the `git log` after a pull, we get up to date with the latest developments of the project.

What we don't want is a summary of the changes happened while we were away written like this:

```
Doesn't work!

End of day commit

Checking this in because it's time for a beer
```

Equally bad is getting a single gianormous commit that adds a bug fix, three feature, and removes a bunch of unused files.

So here's some starting points to use when writing a project's Git-iquette.

## How to write a Git-iquette

### Short commits

Commits should be [small](http://blog.crealytics.com/blog/2010/07/09/5-reasons-keeping-git-commits-small/) and [atomic](http://en.wikipedia.org/wiki/Atomic_commit#Atomic_Commit_Convention).

### Title and description

The commit message should have a short, less than 50 characters, title, that describes what the has been done in the commit.

If needed, a more detailed description can be written after the title, leaving an empty line between the two.

More tips on how to write a good commit message [here](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).

### Commit title style

Given for granted that we all agree on the fact commits should be small and atomic, we need some rules on how to write the commit message.

First of all, which verb to use? When reading a book it'd be confusing if the author kept changing the verbs tense, and the same stands for our `git log`. Choose a style:

```
Add awesome feature

Adds awesome feature

Added awesome feature
```

They're all legit and reasonable, the important thing is to be consistent. _My preference is to use imperative verbs, because it's the same thing git does in it's generated commit messages._

### Merge vs Rebase

Merge vs rebase is an open discussion in the community, and both options have their pros and cons. Again the important thing is to be consistent, and to provide rules on when it's acceptable to merge instead of reabsing, or vice versa.

### Special workflows

On top of merge vs rebase there are other workflows that can be adopted to manage the version control in an effective way. For example [git-flow](http://nvie.com/posts/a-successful-git-branching-model/) makes it simpler to work of features, while the [GitHub flow](https://guides.github.com/introduction/flow/) is very good for teams that focus on code reviews.

Evaluate if the team can take advantage form using a particular workflow, and make it clear in the Git-iquette.

### Hooks

Finally there could be useful [git hooks](http://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) to add. Everything that can be automated should be automated!

## Wrapping it all up

What's listed above is just a suggestion on what to take into consideration when writing a Git-iquette, a version control styleguide. The choices proposed are based on what works for me, and they might not work for you. The important takeaway is to have a clear set of guidelines, and to **always be consistent.**

If you have suggestions or want to share a Git-iquette that works for you leave a comment below, or tweet me [@mokagio](https://twitter.com/mokagio).

_Happy version control check-ins_
