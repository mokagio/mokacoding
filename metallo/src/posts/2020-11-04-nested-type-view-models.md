---
title: How to make the View to ViewModel relationship clear
description: "How to make it clear that a view model belongs to a view using Swift's nested types"
tags:
  - Swift
  - SwiftUI
og_image: https://s3.amazonaws.com/mokacoding/2020-11-04-nested-type-view-model.jpg
---

SwiftUI lends itself well to be used together with the Model-View-ViewModel (MVVM) pattern.
You can keep the view lean by moving all of the presentation logic and behavior into a view model with little to no code to sync between the two, thanks to framework tools like `@ObservedObject`.

While, in theory, you could have a view model power different views, like a row in a list as well as a detail screen, in practice, there is usually a 1-to-1 relationship between a view and its view model.

To make this connection clearer, we can use a Swift language feature called [_nested types_](https://docs.swift.org/swift-book/LanguageGuide/NestedTypes.html).
We can define the view model as a type _within_ the view.

## Nested Type View Model

Nested types allow us to "nest supporting enumerations, classes, and structures within the definition of the type they support."

When there is a 1-to-1 relationship between a view and view model, when the view model supports a single view, a nested type is a great way to make that relationship explicit.

```swift
struct BookDetail: View {

    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View { ... }
}

extension BookDetail {

    class ViewModel: ObservableObject { ... }
}
```

You can find a working example of this code in action [on GitHub](https://github.com/mokagio/ReadingList).

Thanks to the nested type, the full name of the view model is `BookDetail.ViewModel`.
This makes it obvious at a semantic level that the view model is related to `BookDetail`.

You could argue that `BookDetail.ViewModel` is not that different from `BookDetailViewModel`.
Plus, since Xcode has fuzzy auto-completion – _when it works, that is_ – there is no difference when typing the two.

While that's all true, this approach has some advantages compared to keeping the two concepts in unrelated types.

## Advantages — Clearer and less error-prone

First of all, it's worth reiterating that using a nested type makes the relationship between the two types more evident than merely relying on their names.
I feel this modeling expresses the design at [a more precise level](https://mokacoding.com/blog/pipe-wrench/), making it easier to understand the code.

Within the view definition, we can reference the view model just as `ViewModel`, which leaves the code more compact.

The nested type also makes refactoring simpler.
If we ever need to rename the view, we won't need to touch the `ViewModel`.

It's impossible for the names of the two types to diverge.
We can't forget to update the view model after updating the view because there is no update to make on it; we'll never have a `BookDetail` view using a `BookInfoViewModel.`

In the same way, there is no chance to make a typo in the root of the view model type name – one can still mistype `ViewModel`, though.

As much as I like the purity of this approach, it comes with a downside that it's hard to look past: it makes it harder to find the view model code with Open Quickly.

## One disadvantage with Open Quickly

[Open Quickly](http://xcodetips.com/tips/shift-cmd-o-open-quickly.html) is an Xcode feature that allows you to fuzzy find files and types by typing their name.
Press `Shift Cmd O`, and a search field will appear on screen.
As you type your query, Xcode will show the results.

In the case of nested type view models, there is no query, fuzzy or not, that can easily bring up the right type.

For example, "bookdet" will show the `BookDetail.swift` file, but there's no mention of the view model class.
If we jump to that file, we'll have to find the class by scrolling or with `Cmd F`.

![Screenshot of the Open Quickly window with the "bookdet" query but no view model result](https://s3.amazonaws.com/mokacoding/2020-11-04-bookdet.png)

Searching for "bookdetailviewmodel" brings up no results, despite the query being more explicit.
"viewmodel" returns all the view model classes, and you need to read the little file name field on each line to identify the right one.

The only solution I found is to **keep the view models in dedicated files**.
If you do that, then a fuzzy query like "bdvm" will bring up `BookDetail.ViewModel.swift`.

![Screenshot of the Open Quickly window with the "bdvm" query and the matching MVVM view model file](https://s3.amazonaws.com/mokacoding/2020-11-04-bdvm-working.png)
<br>
<br>

Extracting the view models in dedicated files is something you'd probably want to do anyways to keep the domains separated and avoid the chance of merge conflicts when two developers are working on the view and the view model in parallel on different branches.
Still, it's annoying to _have to_ do it to find the objects efficiently.

## Yay or Nay?

None of the advantages of using nested types for view models are life-changing.
This approach won't make your app better from a functionality point of view, nor will it save you time or reduce the chance of making mistakes.
It's all _syntax sugar_, at best.

Is the smarter looking code worth it, or is it better to do a bit more typing and trust the devs in the team will still get the 1-to-1 relationship based on the name of the types, and that code review will catch the cases in which the two diverge?

I haven't had the chance to use this pattern on a team in the real world, so I can't answer that for sure.
I just found this approach fascinating and wanted to share it with you.

What do you think?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).
