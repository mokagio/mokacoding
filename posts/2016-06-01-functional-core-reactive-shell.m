
During the past couple of months I gave a talk named "Functional Core, Reactive
Shell" (or something similar) at a number of (3) events. I think is my best
talk so far, and I'd like to share a summary of its contents and ideas here.

The purpose of the talk is to introduce a somehow different way to look at
software architecture and how manage its complexity.

You can see the video from one of the talks
[here](https://youtu.be/nYxy7Y7Gji4?t=28m35s). And these are the slides:

<iframe src="//www.slideshare.net/slideshow/embed_code/key/y1q0g6Yvw5IyAC" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/GiovanniLodi2/functional-core-reactive-shell" title="Functional Core, Reactive Shell" target="_blank">Functional Core, Reactive Shell</a> </strong> from <strong><a href="//www.slideshare.net/GiovanniLodi2" target="_blank">Giovanni Lodi</a></strong> </div>

### Spaghetti, Lasagna and Pizza

We're all too familiar with so called spaghetti code, source code so entangled
and messy to remind of a bowl of spaghetti, minus the deliciousness.

The opposite of spaghetti code is lasagna code, software that follows the
[single responsibility
principle](https://en.wikipedia.org/wiki/Single_responsibility_principle) and
composed of multiple layers of abstraction, each segregating parts of the code
from the other making the system easier to reason about despite its size.

Another famous, and yummy, Italian food that can be used to describe software
architecture is... Pizza. To understand the details of pizza code we need to
look back at the lasagna for a moment.

### From the tests' point of view

From the developer point of view lasagna code is great, every component has
clear dependencies, and operates on a specific layer of abstraction. At the top
we work with domain objects, at the bottom with database drivers and network
clients.

But when writing tests for these component we bump in two issues. The first is
that objects from a certain layer depend on objects from the layer below, which
depend on objects from the layer below them, and so on. The higher the lasagna
the taller is the dependency tree that we need to build to initialize our
system under test.

The second issue is that the behaviour of some components depends on what the
objects it depends upon do. For example a persistence service which only deals
with domain objects in its public interface, internally relies on a database
controller for a certain vendor to persist that data to disk. To test that the
persistence service behaves as expected we need to test how it commands the
database.

### Test Doubles

Pasta lovers and test enthusiast have found a neat solution for these _limitation_
of lasagna software, using test doubles.

Test doubles is the name of a group of testing patter based on the idea of making
a special copy, a double, of an object for the purpose of facilitating testing.

We can use a *stub*, a test double allowing us to control the indirect inputs
provided to the system under test, to replace dependencies trees that would
otherwise be expensive to setup with a single copy of the top level dependency.
The methods of this stub when called won't perform any logic but simply return
values that we have configured at the start.

Alongside making the tests easier to setup, another advantage of using stub is
that now we can easily control the inputs provided to our system, and so we
can easily test any kind of scenario.

We can use a *mock*, at test double allowing us to control the indirect outputs
produced by the system under test, to verify that top level objects depending
on other at lower level consume them as intended.

Going back to our persistence service example, we could initialize it with a
mock database, which doesn't really persist data to disk, but simply records
the method calls it receives. Now testing the behaviour of the persistence
service is just a matter of verifying it calls the expected methods, with the
expected arguments.

### The issue with Mocks

Mocks sound very promising on paper, but they have an issue which you'll soon
come familiar with when using them. Mocks are liars. Mocks are not production
code, they make you test your system with components that are not going to be
used for real.

There are too many stories of software projects with test suites relying
heavily on mocking going wrong despite all the tests being green.

I myself am guilty of shipping a build to testers crashing due to a networking
issue that my tests didn't scam because they were relying on a mock.

"Well, didn't you test the real version of the mocked dependency?" you could
ask.  I had. "Clearly not well enough.". Correct, but that misses the point.

The point is that mocks make us test the wrong things. A test should assert
behaviours in the form of outputs for a given input, not by verifying if a
certain method is called or not. Mocks focus on implementation, while the
results are what we actually care about.

Isn't one of the points of tests to enable us to change the implementation of
our components without changing the system's behaviour?

If you were to test a method with this signature:

```swift
func sum(a: Int, b: Int) -> Int
```

Would you assert that `+` is called, or that given 1 and 2 the result is 3?

Smarter people than me have tackled the issue of mocking, one of those is [Ken
Scambler](https://twitter.com/kenscambler) in his post "[To Kill a
Mockingtest](http://techblog.realestate.com.au/to-kill-a-mockingtest/)". I
highly recommend you read it for a deeper and more practical look at the issue,
and how to solve it.

### The root of the problem

Mocks are not evil, yes they are pathological liar, but at the end of the day
they are just a tool, and quite a smart one actually.

The root of the problem is with the lasagna architecture itself. Layers upon
layers of objects interacting with and depending upon each other make it so
that a change in one layer could ripple to the others.

### From Objects to Values

As I said, smarter people than me have thought about these issues, this is the
beauty of software development, and science, we [stand on the shoulders of
giants](https://en.wikipedia.org/wiki/Standing_on_the_shoulders_of_giants).

In his talk "[Boundaries](https://www.destroyallsoftware.com/talks/boundaries)"
[Gary Bernhardt](https://twitter.com/garybernhardt?lang=en) proposes to shift
the focus of our software design from the objects and how they interact, to the
values they exchange.

By shifting towards values we can leverage concept from the functional
programming world, in particular immutability and pure functions.

Immutable values cannot be changed. This makes it easy to pass them around without
having to worry that some other component will change them, invalidating our
assumptions.

Pure functions do not have side effects, which means that they don't produce
mutations, nor they interact with the outside world, no networks calls nor
file-system operations.

Testing pure functions is incredibly straightforward: provide inputs and assert
that the outputs are what you expect. No need to setup stubs or mocks.

If we write our software by focusing on the data it deals with then we can have
pipelines of pure functions that get values in and give values out.

But what about I/O?! As we said, a pure function does not have side effects,
and as such cannot perform I/O. So how do we actually show stuff to the users
or gather their inputs?

### Decision and Actions

A software designed "value first" can manage side effects by... making them
values as well!

The idea is to split the code that takes decision, what side effect to perform,
from the code taking action, what actually performs the effect.

For example when storing some data in the database we could have a
`DatabaseAction` value:

```swift
enum DatabaseActionMode {
  case Delete
  case Insert
  case Update
}

struct DatabaseAction {
  let objects: [Persistable]
  let mode: DatabaseActionMode
}
```

Testing code that interacts with the database would then become a matter of
testing the logic, pure functions, producing `DatabaseAction` values.

The action can then be performed by something like this:

```swift
class DatabaseService {

  func performAction(action: DatabaseAction) {
    switch action.mode {
    case .Delete: // ...
    case .Insert: // ...
    case .Update: // ...
    }
  }
}
```

Testing `DatabaseService` would be easy as well, just create a simple
`DatabaseAction` and verify that the `objects` it carries are modified in
database according to the value of its `mode` property.

### Functional Core, Imperative Shell

Our software now boils down to a pipeline of purely functional values
transformations that eventually produces side effects which are sent to objects
that know how
to perform them.

This is what Gary Bernhardt calls "Functional Core, Imperative Shell".

The functional core is made by the values and the purely functional logic, the
imperative shell is the straightforward glue that takes value from one
function, passes them to the next, and eventually provides a side effect value
to its performer.

And that's the pizza! Values and functions are our toppings, the imperative
glue code is the crust.

### Functional Core, Reactive Shell

Gary Bernhardt talk is dated 2012, and he was working in Ruby. Some years have
passed and some paradigms have become mainstream, so I'd like to introduce my
spin on the concept, with the background of an iOS developer working in Swift.

The Functional Reactive Programming flavour introduced by
[RxJS](https://github.com/Reactive-Extensions/RxJS) and implemented in Swift by
frameworks such as [RxSwift](https://github.com/ReactiveX/RxSwift) and
[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) marries very
well with the concept of looking to software as a pipeline of values
transformation.

By leveraging FRP we can replace most of the imperative glue code with the
scaffold provided by signal transformations. We can go from "Functional Core,
Imperative Shell", to "Functional Core, Reactive Shell".

Input sources, like a button the user touches, a read from the file-system, a
network request, etc.  can all be treated as signal producers. We can transform
the input signals by using the FRP scaffolding tools like `map`, `flatMap`,
`zip`, etc. operators apply our pure transformations, for example going from a
JSON dictionary to a view update action with embedded view model. An finally we
can observe those signals, and perform the side effects they produce.

This approach reduces the amount of actual business logic we need to write, boiling
it down to a number of functions that we can test with confidence.

And speaking of testing we can test the behaviour of the whole reactive shell
quite easily too, just provide our own source of input signals to the shell,
and subscribe to them to assert the side effect values are configured as
expected.

### Is this pizza actually edible?

While there's little doubt that real Italian food, and Pizza in particular, is
delicious, you might be wondering if the "Functional Core, Reactive Shell" is
actually a good idea.

I'll be honest. There are some downsides. First of all the FRP style and its
tools come with a bit of a learning curve, and not all developers are familiar
with them.

Even if you and your team are prolific with this style, to be effective all
your code needs to buy into this style. This could be a problem later on if you
want to change architecture, or if the original team is replaced by one less
familiar with FRP.

Finally, another considerable disadvantage is that the reactive shell code, the
crust of the pizza, will look long and odd. Like this:

```swift
SignalProducer(values: [
	//
	// Input sources
	//
	databaseService.allStuff()
		.map { $0.map { Stuff(realmObject: $0) } },

	networkService.performRequest(toEndpoint: .GetStuff)
		.flatMap(.Latest) { JSON in
			return Stuff.stuffProducer(withJSON: JSON)
	}
	])
	.flatten(.Merge)
	//
	// Data transformations
	//
	.map { stuffArray in stuffArray.map { CellViewModel(stuff: $0) } }
	.map { viewModels in Effect.UpdateView(viewModels: viewModels) }
	//
	// Collect and perform side effects
	//
	.observeOn(UIScheduler())
	.on(
		failed: { [weak self] error in
			self?.performEffect(Effect.PresentAlert(error: error))
		},
		next: { [weak self] effect in
			self?.performEffect(effect)
		}
	)
	.start()
```

You can see more code
[here](https://github.com/mokacoding/functional-core-reactive-shell-demo).

My personal opinion is that these issues are balanced up by what you get out of
this approach. The awkward and hard to read "reactive shell" is balanced up by
very small and easy to understand _toppings_, and that's actually where the
majority of your business logic will be.

On top of that the shell is the tells you the story of the whole system, no
need to jump up and down abstraction layers and managers classes that call
controllers that call other managers.

Furthermore, this approach simplifies making changes to the system. It easy to
add or remove steps to the pipeline, and since each transformation is pure and
isolated from the others changing them is even easier.

Finally, I see the fact that these techniques are not mainstream, and not
straightforward to pick up as a non-issue. I've been very lucky to work with
many software developers that embrace learning and realise that any new
pattern, paradigm, or technology they learn enriches them.

### Wrapping it up

I am not here to tell you that "Functional Core, Imperative/Reactive Shell" is
the silver bullet of software architecture. Each project is different, and each
team working on it is different as well.

I personally find this approach very interesting, and have been working in a
"Functional Core, Reactive Shell" way on some side projects. Working with it is
fun and rewarding, and I find it easy to pick the code up even after weeks and
find my way around it straightaway.

To be honest I haven't had the chance to use it on a "real world" app, and due
to that I probably have yet to bump into issues that could arise at scale, or
with a larger team working on it.

I hope you'll give this approach a shot, even if sandboxed to a new small
feature. If you do, please get in touch with me on Twitter
[@mokagio](https://twitter.com/mokagio) or leave a comment below. I'd love to
know if you find it useful, or if you think this is a silly idea.

_Leave the codebase better than you found it._
