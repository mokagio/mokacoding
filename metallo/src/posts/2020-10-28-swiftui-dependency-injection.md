---
title: Dependency Injection in SwiftUI
description: "This post shows two ways of achieving dependency injection in SwiftUI: using @EnvironmentObject or a View Model Factory."
og_image: https://mokacoding.s3.amazonaws.com/2020-10-28-swiftui-di-mvvm.jpg
---

There are different ways to do dependency injection in SwiftUI.
In this post, we'll look at two of them:

- [Using the `@EnvironmentObject` property wrapper](#%40environmentobject)
- [Using a View Model Factory](#view-models-view-model-factory)

### Dependency Injection

Dependency injection, DI for short, is the practice of providing an object with the other objects it depends on rather than creating them internally.

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

DI makes the design more flexible, keeps your code [honest](https://mokacoding.com/blog/honesty-oriented-programming/), and, when paired with a protocol, allows you to test the object behavior by providing test doubles.

The challenge with dependency injection is how to provide components with the dependencies they need without manually passing them through all of their ancestors in the hierarchy.
`@EnvironmentObject` and the View Model Factory both provide a clean solution to this.

To compare these two approaches, let's imagine we're building a library reading list app.
A tab view hosts two screens: one shows you all the books in the library, another your to-read list.
You can select a title from the library list to see its details, then add it or remove it from your to-read list.

The to-read list and book detail views both need access to the reading list storage; let's call it `ReadingListController`.

```swift
import Combine

class ReadingListController: ObservableObject {

    // By publishing the reading list, we can leverage SwiftUI to automatically
    // update the UI when a book is added or removed.
    //
    // For the sake of this example, let's use in-memory storage. In the real
    // world, we'd be storing to disk and/or calling a remote API.
    @Published private(set) var readingList: [Book] = []

    func isBookInList(_ book: Book) -> Bool { ... }

    func add(_ book: Book) { ... }

    func remove(_ book: Book) { ... }
}
```

Let's have a look at the two approaches to inject this dependency.

## `@EnvironmentObject`

SwiftUI offers the [`@EnvironmentObject` property wrapper](https://developer.apple.com/documentation/swiftui/environmentobject) to define "an observable object supplied by a parent or ancestor view."
Every time the wrapped `ObservableObject` emits a change, the framework will invalidate the view, resulting in a redraw.

`@EnvironmentObject` allows us to inject dependencies because it looks for its value in the SwiftUI environment.
This means that a view deep in the hierarchy can access a dependency without its parent passing it through.

The way to add the dependency into the environment is to call the [`environmentObject(_:)`](https://developer.apple.com/documentation/swiftui/view/environmentobject(_:%29) method on any ancestor of the view that needs to access it.
I find this is best done at the top level: in the `App` implementation or in the `UIWindowSceneDelegate` if you are mix-and-matching SwiftUI with UIKit.

Let's look at some code; you can get the source for this example [here](https://github.com/mokagio/ReadingList/tree/trunk/PureSwiftUIExample).

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

The next approach removes the risk of runtime crashes.

## View Models & View Model Factory

If you use the MVVM pattern in SwiftUI, giving each view a view model containing all of the logic to present data and act on it, you can use it to inject dependencies by:

- Moving the responsibility to build the views to show from the view layer to the view model;
- Passing the logic to build views in the view models at `init` time; and
- Creating the view models in a centralized place, which can inject the dependency as part as the view-building logic in the `init`.

Views should delegate all logic to their view models, be it what view to use as the destination of a `NavigationLink` or what text to show in a button.

```swift
import SwiftUI

struct BookList: View {

    let viewModel: BookListViewModel

    var body: some View {
        List(viewModel.books) { item in
            // The view model tells the view what's the NavigationLink destination
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
            // The view models take care of actioning on the reading list.
            // Because of that, the view only need an instance of the view
            // model; the ReadingListController dependency is hidden inside it.
            Button(action: viewModel.addOrRemoveBook) {
                Text(viewModel.addOrRemoveButtonText)
            }
        }
    }
}
```

You can find the code sample for this approach [here](https://github.com/mokagio/ReadingList/tree/trunk).

Notice how `BookDetail` has no `if-else` conditional now.
The view is [_humble_](https://martinfowler.com/eaaDev/uiArchs.html#HumbleView); it does what the view model tells it without any extra logic.

The view models themselves don't know how to build views; they ask for that knowledge in the form of a closure at init time.
Have a look at `BookListViewModel`:

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

    private let book: Book
    private let readingListController: ReadingListController

    let title: String { book.title }
    let author: String { book.author }

    @Published var addOrRemoveButtonText: String

    init(book: Book, readingListController: ReadingListController) {
        self.book = book
        self.readingListController = readingListController

        // This method is defined in a private extension below to DRY the code
        // without having to define a static function that could be accessed
        // here when self is not yet available.
        addOrRemoveButtonText = readingListController.textForAddOrRemoveButton(for: book)
    }

    func addOrRemoveBook() {
        if readingListController.isBookInList(book) {
            readingListController.remove(book)
        } else {
            readingListController.add(book)
        }

        addOrRemoveButtonText = readingListController.textForAddOrRemoveButton(for: book)
    }
}

private extension ReadingListController {

    func textForAddOrRemoveButton(for book: Book) -> String {
        isBookInList(book) ? "Remove from reading list" : "Add to reading list"
    }
}
```

The final piece of the puzzle is the actual injection of the `ReadingListController` dependency from a centralized location.
This object will be the only one instantiating `ReadingListController` and will create the view models, passing the dependency to those that need it.

A good name for an object whose sole purpose is to create other objects is _factory_, a hint to the [factory pattern](https://en.wikipedia.org/wiki/Factory_method_pattern), although stripped of the functionality to let a class defer the instantiation of its components to its subclasses.

```swift
class ViewModelFactory {

    // Like when using the environment approach, ViewModelFactory is the only
    // point where we instantiate ReadingListController; no singletons or
    // static shared instances needed.
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

This pattern removes the need to pass dependencies down each node of the hierarchy because `ViewModelFactory` builds all of the view models and each view model receives the logic to construct the views at `init` time.

We can call `ViewModelFactory` at the top level of our SwiftUI application, be it the `App` or `UIWindowSceneDelegate` implementation, to get the view models for the root views.

```swift
import SwiftUI

@main
struct ReadingListApp: App {

    let viewModelFactory = ViewModelFactory()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ToReadList(viewModel: viewModelFactory.makeToReadListViewModel())
                        .navigationTitle("To Read 📖")
                }
                .tabItem { Text("To Read") }

                NavigationView {
                    BookList(viewModel: viewModelFactory.makeBookListViewModel())
                        .navigationTitle("Books 📚")
                }
                .tabItem { Text("All Books") }
            }
        }
    }
}
```

## Pros & Cons

`@EnvironmentObject` trades runtime-safety for conciseness and is a more text-book SwiftUI approach, but it can crash your app.

Using view models for dependency injection requires a bit more work and conventions that developers need to respect but is safe at runtime.

Writing some extra code when what you get in return is runtime safety seems like a reasonable tradeoff; that's the approach I prefer.
I'm still new to SwiftUI, though, and often wonder how much of my thinking within the framework is impeded by the mindset and habits developed after years of working with UIKit.

Which of these two ways do you prefer?
Have you got other ways to inject dependencies in SwiftUI?
I'd love to hear from you!
Leave a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

_Thanks to Adam Campbell and [Rogerio Paula Assis](https://twitter.com/rpassis) for reviewing an early draft of this post._
