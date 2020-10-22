---
title: Code Coverage Is A Broken Metric
description: "But you should track it anyways."
tags:
- Testing
- Refactoring
---

Start talking with management about testing and soon you'll get asked about code coverage. Some teams and companies might event require a certain code coverage threshold for code to be considered safe. **Code coverage is a broken metric, you should be careful about what you do with it**. A bit like IQ scores.

The IQ test is a set of standardized tests introduced at the beginning of the 20th century to measure human intelligence. Take one at your own risk, you might learn you're not as smart as you think your are. At least according to the IQ test.

In fact, the test is not a measure of overall intelligence, just a measure of one's capability in the tasks of the test. IQ doesn't measure intelligence, it measure IQ. The same goes for the standardised tests administered in schools all over the world. They don't measure how ready to function in society children are, only if they're good at remembering things or doing math, barely scratching the surface of whether they understood and internalized those concepts.

The correlation between IQ and performance at school or on the job is visible, but not that strong. "Sometimes IQ scores are described as the 'best available predictor' of that performance. It is worth noting, however, that such tests predict _considerably less than half the variance of job-related measures_ [emphasis mine]" researchers say[<sup id="researchers-say">1</sup>](#fn1).

A question I often get asked is "what code coverage value should we use?". Code coverage is like IQ, it's an incomplete metric for how good a codebase and its test suite actually are.

Here's an example of code coverage false positives:

```swift
// Source.swift
func element(atIndex index: Int, of array: [Int]) -> Int {
    return array[index]
}

// Tests.swift
func testArrayAccess() {
    XCTAssertEqual(element(atIndex: 0, of: [1, 2, 3]), 1)
}
```

The code has 100% code coverage, yet calling `element(atIndex: 3, of: [1, 2, 3])` will result in a crash. When writing tests is not enough to cover the happy path, you also need to verify how the code behaves in the failure and edge cases.

![screenshot of Xcode showing 100% code coverage on a bugged function](https://s3.amazonaws.com/mokacoding/2019-02-19-code-coverage-fail-1.png)

Another example:

```swift
// Source.swift
struct Post {

    let title: String
    let body: String
}

extension Post {

    init?(fromJSON json: String) {
        // TODO: remove dummy implementation
        self.title = "dummy"
        self.body = "lorem ipsum"
    }
}

// Tests.swift
func testPostFromJSON() {
  let post = Post(fromJSON: loadJSONFixture())
  XCTAssertNotNil(post)
}

```

![screenshot of Xcode showing 100% code coverage on a method returning dummy data](https://s3.amazonaws.com/mokacoding/2019-02-19-code-coverage-fail-2.png)

Once again, we have 100% code coverage but the behaviour of the code is incorrect. The problem here is that the test is not granular enough, it asserts _something_ has been returned, without verifying if it's what we expected or not. The author of the code forgot to followup on their `// TODO:` comment, and shipped code with an incomplete implementation. 

As you can see **code coverage is only good at measuring code coverage**, that is, how many of the code paths are hit by a test. It doesn't tell us if those test are comprehensive, on target, or how rigid they are -will they help refactor or need to be updated every time the implementation changes?

We should forgive managers and architects for administrating code coverage thresholds. Like human intelligence or the level of education provided by a school, the quality of a codebase is an hard thing to measure, with a lot of variables affecting the score. It's tempting to find something easier to compute and use it as a proxy.

Should we ditch code coverage then? Stop caring about increasing the number, or let it not drop under a certain threshold? Not at all. Maybe broken was too strong of an attribute for code coverage. The metric itself is not broken, the way we tend to use it is.

We can't rely solely on code coverage to measure the quality of a test suite, and we can't expect enforcing a coverage % will make the code good. Moreover, arbitrary coverage ratios like .8 or .9 are meaningless without first considering how much of what the application is actually valuable to test. Fore example, pure UI or animation code has poor return of time invested in writing tests, a codebase heavy on the UI side should grant a lower coverage threshold.

The best way to use code coverage is not to highlight how many tests you have, but how many you don't. **Use it to identify the areas of your codebase that are not tested**, then take a critical look at them. Is any of them important for the correct behaviour of the application? Is there any plan to change them in the near future? Can you live with it being untested for the time being, and [focus your work on tasks with more impact](https://mokacoding.com/blog/how-to-choose-what-to-refactor/)?

Software engineer like to say they use the best tools for the job. This shouldn't apply only to databases, frameworks, or programming languages, but also to metrics like code coverage. Measure code coverage, track its trend, but don't use it as the only quality indicator of a test suite or codebase. Remember, code coverage only measure code coverage.

### Footnotes
1. <span id="fn1"></span> [_Researchers say_](#researchers-say). Neisser, U.; Boodoo, G.; Bouchard, T. J., J.; Boykin, A. W.; Brody, N.; Ceci, S. J.; Halpern, D. F.; Loehlin, J. C.; Perloff, R.; Sternberg, R. J.; Urbina, S. (1996). "[Intelligence: Knowns and Unknowns](https://en.wikipedia.org/wiki/Intelligence:_Knowns_and_Unknowns)". American Psychologist Association.
