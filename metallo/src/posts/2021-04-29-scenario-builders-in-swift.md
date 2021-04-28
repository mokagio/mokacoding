---
title: How to manage complex inputs in your Swift tests with Scenario Builders
description: "When writing unit tests in Swift for complex objects, you may need to write a lot of setup boilerplate code in the arrange phase. Scenario Builders are a pattern that extracts and encapsulated all that logic in a single component with an English-like API. This tutorial shows how to build a Scenario Builder in Swift and looks at its pros and cons."
og_description: "Scenario Builders extract and encapsulate complex setup logic behind an English-like API in your Swift unit tests."
twitter_title: Scenario Builders in Swift
tags:
- Testing
- Swift
date: 2021-04-06 06:21
---

How do you set up the input state for a system under test that depends on a complicated network of objects?

If you manually instantiate and connect all of the components involved, your unit test's arrange phase will become long and hard to read.

Using [fixtures](https://mokacoding.com/blog/streamlining-tests-setup-with-fixtures-in-swift/) can help removing boilerplate and highlighting only the properties that affect the behavior under test, but you're still required to manually connect the various objects.

[GeePaw Hill](https://www.geepawhill.org) shares an alternative tactic to tackle this problem, which he calls [Scenario Builders](https://www.geepawhill.org/2021/03/23/scenario-builders/).

This post shows how to construct a Scenario Builder in Swift.

## Rich input state makes the arrange phase noisy

Let's imagine we're building a medical system application and we want to test the logic that issues a script, like GeePaw does in his example.
In particular we want to make sure a doctor cannot issue a script for a medicine to a patient that is below the drug's minimum age.
There are many rules involved in the process, such as:
the patient needs to be registered with the doctor issuing the script,
they both need to be part of the system,
and the patient needs to be over the minimum age for the drug.

A traditional unit test would require a setup along these lines:

```swift
let medicalBackend = MedicalBackend(
    name: "medical backend",
    registrationID: "123ABC",
    address: Address(
        streetNumber: "123",
        street: "a street",
        city: "a city",
        state: "a state",
        postCode: "2ABC"
    )
)
let doctor = Doctor(name: "a name", license: "1234", specialty: .generalPractitioner)
medicalBackend.employ(doctor: doctor)
let patient = Patient(
    name: "another name",
    dateOfBirth: Date(year: 2010, month: 01, day: 01),
    address: Address(
        streetNumber: "234",
        street: "a street",
        city: "a city",
        state: "a state",
        postCode: "12ABC"
    )
)
medicalBackend.onboard(patient: patient)
medicalBackend.register(patient: patient, with: doctor)
```

The key information affecting the system under test outcome, that is, whether the patient is under age for the medicine, is lost in the noise made by the rest of the necessary input parameters.

As already mentioned, [fixtures](https://mokacoding.com/blog/streamlining-tests-setup-with-fixtures-in-swift/) can help, but we're still left with extra work in the arrange phase:

```swift
let medicalBackend = MedicalBackend(
    name: "medical backend",
    registrationID: "123ABC",
    address: .fixture()
)
let doctor = Doctor.fixture()
medicalBackend.employ(doctor: doctor)
let patient = Patient.fixture(dateOfBirth: Date(year: 2010, month: 01, day: 01))
medicalBackend.onboard(patient: patient)
medicalBackend.register(patient: patient, with: doctor)
```

Scenario Builders simplify the setup of networks of objects by centralizing all of the instantiation, default values, and linking logic.

## Scenario Builder

A Scenario Builder is an object that lives in your test suite to which you ask to construct a scenario with a natural language-like API.
It encapsulates all the logic to create and connect the objects that make up the input state.

Here's the Scenario Builder for our example:

```swift
struct ScenarioBuilder {

    private var patientAge: Int = 30

    func withPatientAge(_ age: Int) -> ScenarioBuilder {
        var newBuilder = self
        newBuilder.patientAge = age
        return newBuilder
    }

    func build(referenceDate: Date = Date()) -> (MedicalBackend, Doctor, Patient) {
        let medicalBackend = MedicalBackend(
            name: "a name",
            registrationID: "ABC123",
            address: .fixture()
        )

        let doctor = Doctor.fixture()

        medicalBackend.employ(doctor: doctor)

        let dob = Calendar.current.date(byAdding: .year, value: patientAge, to: referenceDate)!
        let patient = Patient.fixture(dateOfBirth: dob)

        medicalBackend.onboard(patient: patient)
        medicalBackend.register(patient: patient, with: doctor)

        return (medicalBackend, doctor, patient)
    }
}
```

This pattern is similar to [Test Data Builders](http://www.natpryce.com/articles/000714.html) and fixtures, but removes the need for nesting instantiation of dependent objects.

Thanks to the Scenario Builder, the test we wrote before can become much simpler:

```swift
let (medicalBackend, doctor, patient) = ScenarioBuilder().withPatientAge(10).build()
```

Notice the signal to noise ratio of this syntax compared to the initial example.
All the irrelevant information is hidden away inside `ScenarioBuilder`.

To appreciate the value of this approach, imagine how much setup work this would spare you if you had to write five, ten, thirty more tests that required a consistent starting state for the medical system.

A key difference between this approach and extracting the logic in a dedicated function is composability.
Once you've gone through the effort of setting up the Scenario Builder, adding additional variations to the scenario is relatively cheap.

```swift
ScenarioBuilder()
  .withPatientAge(10)
  .withPatientAllergicTo(someActiveIngredient)
  .withPatientWithSpecialCondition(specialCondition)
  .withDoctorNotQualifiedFor(specialCondition)
  .build()
```

Scenario Builders are also a way to decouple the tests from the implementation detail of the state instantiation, reducing the maintenance cost.
Imagine something changes in the method that links a `Patient` to a `Doctor`,
if you manually create and connect patients and doctors in each test,
you'd have to update all of them.
With a Scenario Builder, you only have to update one object.

By lowering the cost of making an update to the production code, Scenario Builders give you more flexibility to refactor, with extra confidence that the test suite will validate your changes.

## Tradeoffs

Scenario Builders are a lot of work and they'll likely grow to hold a non-trivial amount of logic, so much so that you may end up wanting to write tests against them.
On the other hand, they lower the barrier to entry to write new tests and centralize the code that you need to update when some of the underlying structure changes, as opposed to manually editing each of the tests.

Whether the cost of implementing and maintaining a Scenario Builder is worth the benefits to the test suite will vary from project to project.

I haven't had the chance to try this out, but I have a hunch this approach would be valuable to write high-level integration tests for the ViewModel layer of a SwiftUI application.
SwiftUI's unidirectional data flow makes it straightforward and beneficial to hold the entire application state in a single object (which can be comprised of smaller isolated sub-states, for better local reasoning).

---

In a data rich app, constructing the entire state for testing can easily become a cumbersome matter.
Using a Scenario Builder is a way to simplify writing of new tests, make existing tests readable, and lower the maintenance cost.

What do you think of Scenario Builders?
Drop a comment below or get in touch on Twitter at [@mokagio](https://twitter.com/mokagio).

_If you enjoyed this post on testing, you'll like my upcoming book [Test-Driven Development with SwiftUI and Combine](https://tddinswift.com/), which teaches TDD step-by-step building a real world application._
