---
title: How to do dependency injection in SwiftUI
description: Let's look at two ways to inject dependencies in SwiftUI: using @EnvironmentObject or dependency injection with MVVM
---

Dependency injection is the practice of providing an object with the other objects it depends on rather than creating them internally.

```swift
// Without dependency injection
class Foo {
    let bar: Bar = Bar()
}

// With dependecy injection
class Foo {
    let bar: Bar

    init(bar: Bar) {
        self.bar = bar
    }
}
```

This approach makes the design more flexible, keeps your code [honest](https://mokacoding.com/blog/honesty-oriented-programming/), and, when paired with a protocol, allows you to test the object behavior by providing test doubles.

In SwiftUI, there are different options for dependency injection.
We'll look at two of those in this post:

- The `@EnvironmentObject` property wrapper
- Injection through an MVVM view model

<!-- Example: reading list app -->
To compare these two approaches, let's imagine we're building a library reading list app.

We have a tab view hosting two screens: one shows you all the books in the library, another your to-read list.
You can select a title from the library list to see its details and add it or remove it from your to-read list.

<!-- _image here_ -->

The to-read list and book detail views both need access to the reading list storage; let's call it `ReadingListController`.

```swift
import Combine

class ReadingListController: ObservableObject {

    // By publishing the reading list, we can leverage SwiftUI to automatically
    // update the UI when a book is added or removed.
    //
    // For the sake of this example, let's use in-memory storage. In the real
    // world we'd be storing to disk and/or calling a remote API.
    @Published private(set) var readingList: [Book] = []

    func isBookInList(_ book: Book) -> Bool { ... }

    func add(_ book: Book) { ... }

    func remove(_ book: Book) { ... }
}
```

Let's have a look at the two approaches to inject this dependency.

<!-- @Environment & @EnvironmentObject -->
## `@EnvironmentObject`

SwiftUI offers the [`@EnvironmentObject` property wrapper](https://developer.apple.com/documentation/swiftui/environmentobject) to define "an observable object supplied by a parent or ancestor view."
Every time the wrapped `ObservableObject` emits a change, the framework will invalidate the view, resulting in a redraw.

`@EnvironmentObject` allows us to inject dependencies because it looks for its value in the SwiftUI environment.
This means that a view deep in the hierarchy can access a dependency without its parent passing it through.

<!-- _image without @EnvironmentObject_ | _image with @EnvironmentObject_ -->

The way to add the dependency into the environment is to call the [`environmentObject(_:)`](https://developer.apple.com/documentation/swiftui/view/environmentobject(_:)) method on any ancestor of the view that needs to access it.
I find this is best done at the top level: in the `App` implementation or in the `UIWindowSceneDelegate` if you are mix-and-matching SwiftUI with UIKit.

```swift
import SwiftUI

@main
struct ReadingListApp: App {

    // The interface with the reading list storage.
    // This is the only place where we instantiate ReadingListController; no
    // singletons or static shared instances needed.
    let readingListController = ReadingListController()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ToReadList().navigationTitle("To Read 📖")
                }
                .tabItem { Text("To Read") }

                NavigationView {
                    BookList().navigationTitle("Books 📚")
                }
                .tabItem { Text("All Books") }
            }
            // Here we inject the ReadingListController instance in the
            // environment
            .environmentObject(readingListController)
        }
    }
}
```

The views that need access to `ReadingListController` can get it via `@EnvironmentObject`; the others don't have to know about it.

```swift
struct BookList: View {

    // Let's skip how to load the library books for the sake of brevity
    let books: [Book] = ...

    var body: some View {
        List(books) { item in
            // BookList defines the view where to navigate when a row is
            // selected, but notice how it doesn't provide it with a reference
            // to a ReadingListController.
            NavigationLink(destination: BookDetail(book: item)) {
                Text(item.title)
            }
        }
    }
}

struct BookDetail: View {

    let book: Book

    // Here, we access our injected dependency from the environment
    @EnvironmentObject var readingListController: ReadingListController

    var body: some View {
        VStack {
            Text(book.title)
            Text(book.author)

            if readingListController.isBookInList(book) {
                Button(action: { self.readingListController.remove(book) }) {
                    Text("Remove from reading list")
                }
            } else {
                Button(action: { self.readingListController.add(book) }) {
                    Text("Add to reading list")
                }
            }
        }
    }
}

struct ToReadList: View {

    // Here, too, we get our ReadingListController from the environment
    @EnvironmentObject var readingListController: ReadingListController

    var body: some View {
        List(readingListController.readingList) { item in
            Text(item.title)
            Text(item.author)
        }
    }
}
```

The code above is tidy and easy to follow once you wrap your head around how `@EnvironmentObject` works.
Thanks to the SwiftUI framework internals, we don't have to write any code to keep the to-read list and book detail screens in sync; everything is taken care of for us.

There's a catch, though, if you don't call `environmentObject`, or if someone removes it by accident, the app will crash.

On top of that, accessing `ReadingListController` directly from the view results in a bit of extra logic: we have an `if-else` in `BookDetail` to show the appropriate button and update the reading list depending on whether the book is already in it or not.
This conditional logic requires manual or UI-level automated testing, since you cannot (without [jumping through many hoops](https://nalexn.github.io/swiftui-unit-testing/)) inspect a SwiftUI view content in unit tests.

The next approach makes testing this conditional behavior easier and also removes the risk of runtime crashes.

<!-- ViewModel Dependency _Inversion_ -->
## View Model Dependency Injection

If you use the MVVM pattern in SwiftUI, giving each view a view model containing all of the logic to present data and act on it, you can use it to inject dependencies by doing these two things:

- Move the logic to build the views to show from the view layer to the view model
- Centralize the logic to create view models in a single place

Here's the view models for `BookList` and `BookDetail`.

```swift
import Combine

class BookListViewModel: ObservableObject {

    let books: [Book]

    // When creating the view model, inject the logic to create the detail view
    // for a given book.
    let viewForSelectedBook: (Book) -> BookDetail

    init(books: [Book], viewForSelectedBook: @escaping (Book) -> BookDetail) {
        self.books = books
        self.viewForSelectedBook = viewForSelectedBook
    }
}

class BookDetailViewModel: ObservableObject {

    let title: String
    let author: String

    @Published var addOrRemoveButtonText: String

    private let book: Book
    private let readingListController: ReadingListController

    init(book: Book, readingListController: ReadingListController) {
        title = book.title
        author = book.author
        self.book = book
        self.readingListController = readingListController

        // This method is defined in a private extension below to DRY the code without having to
        // define a static function that could be accessed here when self is not yet available.
        addOrRemoveButtonText = readingListController.textForAddOrRemoveButton(for: book)
    }

    // By moving the to update the reading list membership of a given book
    // here, we can write a unit test for it.
    func addOrRemoveBook() {
        if readingListController.isBookInList(book) {
            readingListController.remove(book)
        } else {
            readingListController.add(book)
        }

        addOrRemoveButtonText = readingListController.textForAddOrRemoveButton(for: book)
    }
}
```

The two views use their view models like this:

```swift
import SwiftUI

struct BookList: View {

    let viewModel: BookListViewModel

    var body: some View {
        List(viewModel.books) { item in
            NavigationLink(destination: viewModel.viewForSelectedBook(item)) {
                Text(item.title)
            }
        }
    }
}

struct BookDetail: View {

    @ObservedObject var viewModel: BookDetailViewModel

    var body: some View {
        VStack {
            Text(viewModel.title)
            Text(viewModel.author)
            Button(action: viewModel.addOrRemoveBook) {
                Text(viewModel.addOrRemoveButtonText)
            }
        }
    }
}
```

Notice how `BookDetail` has no `if-else` conditional now.
The view is [_humble_](https://martinfowler.com/eaaDev/uiArchs.html#HumbleView); it does what the view model tells it without any extra logic.

The final piece of the puzzle is the actual injection of the `ReadingListController` dependency from a centralized location.
We can do that at the `App` level – or in your `UIWindowSceneDelegate` if you are mix-and-matching SwiftUI with UIKit.
For consistency, I like to define this logic in a "root" view model.

```swift
class AppViewModel {

    // Like when using the environment approach, AppViewModel is the only point
    // where we instantiate ReadingListController; no singletons or static
    // shared instances needed.
    let readingListController = ReadingListController()

    // Once again, let's gloss over how to load the books for the sake of
    // brevity.
    let books: [Book] = ...

    func makeBookListViewModel() -> BookListViewModel {
        return BookListViewModel(
            books: books,
            viewForSelectedBook: { [unowned self] in
                BookDetail(viewModel: self.makeBookDetailViewModel(for: $0))
            }
        )
    }

    func makeBookDetailViewModel(for book: Book) -> BookDetailViewModel {
        return BookDetailViewModel(book: book, readingListController: readingListController)
    }

    func makeToReadListViewModel() -> ToReadListViewModel {
        return ToReadListViewModel(readingListController: readingListController)
    }
}
```

In the `App`, we instantiate the `AppViewModel` and use it to get the view models for the top-level screens.

```swift
import SwiftUI

@main
struct ReadingListApp: App {

    let viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ToReadList(viewModel: viewModel.makeToReadListViewModel())
                        .navigationTitle("To Read 📖")
                }
                .tabItem { Text("To Read") }

                NavigationView {
                    BookList(viewModel: viewModel.makeBookListViewModel())
                        .navigationTitle("Books 📚")
                }
                .tabItem { Text("All Books") }
            }
        }
    }
}

```

## Pros & Cons

Using view models requires more coding than relying on `@EnvironmentObject`. What you get from it is the certainty that the dependencies will be available at runtime. It also makes it easier to write unit tests because all the logic is in a plain Swift object.

Granted, one could achieve a similar result in terms of testability by making `ReadingListController` expose methods to get the button text for a given book and update its membership depending on its state.
While that's a valid option, the button text, in particular, seems like a responsibility overload: a data domain object like `ReadingListController` shouldn't need to know about view details like the text of a button.

`@EnvironmentObject` trades runtime-safety for conciseness and is a more text-book SwiftUI approach.
Using view models requires a bit more work but provides a way to keep the view clean and separate responsibilities.

Writing a bit of extra code when what you get in return is runtime safety seems like a reasonable tradeoff.

Which of these two ways do you prefer?
Have you got other ways to inject dependencies in SwiftUI?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

