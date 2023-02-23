#  Experiment with Main Actor Tasks

An experiment to see on which thread (*main* or *background*) the process will execute inside a **Task**.

## Process

Call a method inside a `Task { ... }` to see on which Thread the method body will be executed.

```swift
Task {
    await viewModel.printTemperatures()
}
```

## Results

### Case 1

When *@MainActor* annotation is used **on the whole class**:

```swift
@MainActor class ViewModel: ObservableObject {
```

Then inner-method calls are executed on different threads like:

```swift
@MainActor class ViewModel: ObservableObject {
    ...
    func printTemperatures() async {
        printingInProgress = true

        printComputerTemperature()                  // Nr.1 - executed on main thread
        await printRoomTemperature()                // Nr.2 - executed on main thread
        await service.printWeatherTemperature()     // Nr.3 - executed on background thread

        printingInProgress = false
    }
}
```

### Case 2

When *@MainActor* annotation is used **on the method**:

```swift
@MainActor func printTemperatures() async {
```

Then inner-method calls are executed on different threads like:

```swift
class ViewModel: ObservableObject {
    ...
    @MainActor func printTemperatures() async {
        printingInProgress = true

        printComputerTemperature()                  // Nr.1 - executed on main thread
        await printRoomTemperature()                // Nr.2 - executed on background thread
        await service.printWeatherTemperature()     // Nr.3 - executed on background thread

        printingInProgress = false
    }
}
```
