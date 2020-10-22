---
title: Job stories acceptance tests using KIF and Specta
description: "When writing tests it's very important do be declarative, aiming to have tests that explain how a class is supposed to behave as good as its documentation would do. When talking about acceptance tests we can achieve this kind of clarity by having a 1:1 relationship between the tests and the acceptance criteria for the application. A very effective way to express acceptance criteria is through _job stories_. In this post we'll see how to write acceptance tests that map job stories for our iOS apps, using KIF and Specta."
tags:
- Acceptance Testing
- KIF
- Specta
---

In this post we'll put together two of the tools seen in the past weeks, [KIF](https://mokacoding.com/blog/setting-up-kif-for-ios-acceptance-testing) and [Specta](https://mokacoding.com/blog/better-tests-with-specta), to write more effective acceptance tests, that map user stories.

If you don't know what a job story is I'll suggest you to have a look at [these](https://medium.com/the-job-to-be-done/replacing-the-user-story-with-the-job-story-af7cdee10c27) two [posts](https://robots.thoughtbot.com/converting-to-jobs-stories). In short, a job story is an alternative approach to collecting requirements to the more famous _user story_, that focus on the value added by the feature or bugfix to be implemented. It is a good way to make sure only things that will actually benefit the user and help deliver a better experience will be developed.

Let's take a look at our example app, [Bench](https://github.com/mokacoding/Bench). One (_of the two_) its feature is displaying the list of the elements from the [periodic table](http://en.wikipedia.org/wiki/Periodic_table). The job story for this feature could have looked something like:

> When I tap the "show elements" button
> I see a list of elements
> So that I can expand my knowledge

The test we wrote was this:

```objc
/**
 *  When I tap the "show elements" button, I see a listt of elements, so I can expand my knowledge
 */
- (void)testShowElements {
  [tester tapViewWithAccessibilityLabel:@"show elements"];

  [tester waitForViewWithAccessibilityLabel:@"Elements"];
  [tester waitForViewWithAccessibilityLabel:@"[H] Hydrogen (1)" ];
  [tester waitForViewWithAccessibilityLabel:@"[Uuo] Ununoctium (118)"];
  // Code to restore the app to the default state
}
```

The only way we have to tie the test to the story is by using a comment. The terminal output for it will be:

```
Test Case '-[MainScreenTest testShowElements]' started.
Test Case '-[MainScreenTest testShowElements]' passed (1.720 seconds).
```

This output does not give use any information on the story.

Let's now see what we could do using Specta has the harness for the test. The simplest implementation we could write is be something like this:

```objc
describe(@"When I tap the 'show elements' button, I see a list of elements, so I can expand my knowledge", ^{
  it(@"should do what's expected", ^{
    [tester tapViewWithAccessibilityLabel:@"show elements"];

    [tester waitForViewWithAccessibilityLabel:@"Elements"];
    [tester waitForViewWithAccessibilityLabel:@"[H] Hydrogen (1)" ];
    [tester waitForViewWithAccessibilityLabel:@"[Uuo] Ununoctium (118)"];
    // Code to restore the app to the default state
  });
});
```

Which outputs:

```
Test Case '-[MainScreenSpec test_When_I_tap_the_show_elements_button_I_see_a_list_of_elements_so_that_I_can_expand_my_knowledge__should_do_whats_expected]' started.
Test Case '-[MainScreenSpec test_When_I_tap_the_show_elements_button_I_see_a_list_of_elements_so_that_I_can_expand_my_knowledge__should_do_whats_expected]' passed (1.703 seconds).
```

Now, I'm not gonna say that this console output _reads better_ than the previous one, but you can't deny that, once you digest the [snake casing](http://en.wikipedia.org/wiki/Snake_case), the story is expressed there.

However, there are some issues, that `@"should do what's expected"` is a bit out of place, and doesn't really add any value. Also, the test body is as long as its XCTest counterpart.

When can leverage on the xSpec syntax that Specta provides use to write a test case that flows in a nicer way.

```objc
describe(@"Main screen", ^{
  context(@"when I tap the 'show elements' button", ^{
    before(^{
      [tester tapViewWithAccessibilityLabel:@"show elements"];
    });

    it(@"I see a list of elements, so I can expand my knowledge", ^{
      [tester waitForViewWithAccessibilityLabel:@"Elements"];
      [tester waitForViewWithAccessibilityLabel:@"[H] Hydrogen (1)" ];
      [tester waitForViewWithAccessibilityLabel:@"[Uuo] Ununoctium (118)"];
    });

    after(^{
      // Code to restore the app to the default state
    });
  });
});
```

The code of this test really _reads better_, what I especially like is how this syntax allows us to separate the operations that we need to perform to reach the screen or feature under test from the assertion itself. The same stands true for the code to restore the app into the default state, from which the next test, whatever it will be, can reliably start.

Notice how we removed the useless `@"should do what's exepceted"` and how more horizontally compact the code is, no need to move your eyes left and right to read it, or to horizontally scroll.

The console output is still long and with all the `_`, but at least it only carries useful information:

```
Test Case '-[MainScreenSpec test_Main_screen__when_I_tap_the_show_elements_button__I_see_a_list_of_elements_so_I_can_expand_my_knowledge]' started.
Test Case '-[MainScreenSpec test_Main_screen__when_I_tap_the_show_elements_button__I_see_a_list_of_elements_so_I_can_expand_my_knowledge]' passed (1.724 seconds).
```
You can have a look at [the other tests](https://github.com/mokacoding/Bench/blob/KIF%2BSpecta/BenchKIF/MainScreenSpec.m) on Bench to have a better idea of how this kind of tests look.

---

Acceptance testing on iOS is an field which is still evolving and taking a proper form, both the tools and the process are not yet mature and up to the task. This approach to writing acceptance tests using a job story style, with KIF and Specta as tools of choice, is only one of the possible ones, and it's not said that it's the best one. Although without experimenting and trying new approaches we risk to stagnate, and progress comes from experimentation. I've been using this approach in a handful of projects and have been quite happy with the results.

I'd like to hear your opinion on this, or on any other styles you might be using to write your acceptance test cases. You can tweet [@mokacoding](http://twiter.com/mokacoding), or use the comments below. And don't forget to [subscribe](#subscribe) to our newsletter.

_Happy coding, and leave the codebase better than you found it._
