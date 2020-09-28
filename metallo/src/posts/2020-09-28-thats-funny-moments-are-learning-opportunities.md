---
title: "\"That's funny…\" moments are learning opportunities"
description: "The most exciting phrase to hear in science, and software development, the one that heralds new discoveries, is not \"Eureka!\" but \"That's funny…\""
tags:
  - Software Design
  - Quotes
og_image: https://mokacoding.s3.amazonaws.com/og-image-light-bulbs.jpg
---

The other day, I came across this quote [often attributed to Isaac Asimov](https://quoteinvestigator.com/2015/03/02/eureka-funny/):

> The most exciting phrase to hear in science, the one that heralds new discoveries, is not "Eureka!" (I found it!) but "That's funny…"

That's as true for science as it is for software development.

When our software does something that makes us exclaim: "That's funny...", that's when learning happens.
The _funny_, unexpected behavior is a sign that our understanding of the software doesn't match reality.
When that happens, there's often a bug.

We tend to think of bugs as the software being wrong.
A different way to look at them, though, is as an asymmetry between the desired behavior and the authors' understanding of what the code they wrote would end up doing.

For example, you might expect that calling a view method named `display(_: Bool)` passing `true` will result in the view being displayed.
But, if the method implementation is as follows, the view will be hidden instead.

```swift
func display(_ shouldHide: Bool) {
  shouldHide ? hide() : show()
}
```

The difference between the mental representation<sup id="mental-representation-fn-back"><a href="#mental-representation-fn">1</a></sup> of what the code would do and its actual behavior is the source of the bug.

When reading and writing software, our aim should be to build the most accurate mental representation.

As the late Anders Ericsson points out in his book [Peak](https://geni.us/l8FSc), it is the quality of mental representations that sets apart the best form the rest.

Building mental representations is the same approach Nobel Prize [Richard Feynman used to understand physics](https://geni.us/bV50i):

> I had a scheme, which I still use today when somebody is explaining something that I'm trying to understand:
> I keep making up examples.

Instead of just trying to follow an equation, or in our case, the code, Feynman would picture it up in his mind, continuing to refine the model as more information arrived.

> As they're telling me the conditions of the theorem, I construct something which fits all the conditions.
> You know, you have a set (one ball)—disjoint (two balls).
> Then the balls turn colors, grow hairs, or whatever, in my head as they put more conditions on.
> Finally they state the theorem, which is some dumb thing about the ball which isn't true for my hairy green ball thing, so I say, 'False!'

Imagine being able to apply the same visual approach to debugging.
Read the code, build up an image of the information flowing through the system, and identify the bug source when the outcome in your mental image is not doesn't match reality.

One of the reasons I love Test-Driven Development is how it allows me to refine my mental image of the software I'm writing or modifying.

Before running the tests, I always pause and state what I expect them to do —will they pass, or will they fail, and if they fail, how?
Usually, I'm right, but sometimes I'm not.
Those are Asimov's "That's funny…" moments; the times where I get to adjust my model and refine my understanding, either of the new code I'm writing or of the way I should be interacting what already exists.

Our ability to build an accurate mental representation of the software also depends on how readable the code is.
This is why designing for local reasoning is important and why we should strive to [write code that is honest](http://www.mokacoding.com/blog/honesty-oriented-programming/).
Code with no hidden dependencies, doing only one thing, made up of small components, is easier to follow and reason about.
There's less room for mistakes when building a mental representation of it.

Back to the example above, a simple way to help future readers of the code build an accurate mental representation is to avoid omitting the [argument label](https://docs.swift.org/swift-book/LanguageGuide/Functions.html#ID526).

```swift
func display(shouldHide: Bool) {
  shouldHide ? hide() : show()
}
```

We could also make the code less surprising by removing the inverse logic.

```swift
func display(shouldShow: Bool) {
  showShow ? show() : hide()
}
```

The verb display means "to make a prominent exhibition of (something) in a place that it can be easily seen".
It's a bit weird to use it for a function that can hide a view, the opposite of displaying it.
We could go even further to help paint an accurate mental image and use a different verb.

```swift
func updateVisibility(to visible: Bool) {
  visible ? show() : hide()
}
```

Reading this a call to this version of the method, `updateVisibility(to: true)`, is less likely to result in an incorrect mental representation.

---

Whether you are aware of it or not, you always build a mental representation of your software to understand it.
Since the quality of our mental representation directly affects how well we can work within the codebase, it makes sense to invest in making sure it is accurate.

As software writers, we can make our code easier to represent by taking into account readability, testability, how many things an unit of code does, and how many dependencies it has.
Tip: [practicing TDD helps you with that](https://www.mokacoding.com/blog/if-youre-not-writing-tests-first-youre-missing-out/).

As software readers, we can refine our mental representations by noticing when the behavior differs from our expectation and discover the reason why.

"That's funny…" moments are a trampoline for learning.

---

### Footnotes

<span id="mental-representation-fn"><b>1</b></span>.
Another possible name for the representation we build in our brain of how the code behaves could be _mental model_.
I avoided using that term because it's becoming trendy and therefore overloaded.
Everyone's trying to sell you something about mental models these days.
When I think about mental models, I think about Charile Munger's definition from [his USC Business School 1994 speech entitled A Lesson on Elementary Worldly Wisdom](https://fs.blog/great-talks/a-lesson-on-worldly-wisdom/) (_the link is a third party transcript; I can't find the original_).
<a href="#mental-representation-fn-back">Back</a>.

<p><i>
<span>Cover image by <a href="https://unsplash.com/@wilhelmgunkel?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Wilhelm Gunkel</a> on <a href="https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText">Unsplash</a></span>.
</i></p>
