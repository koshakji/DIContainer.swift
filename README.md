# DIContainer.swift

This package is an experimental Dependency Injection Container written in Swift.

The goal is to register which implementation of any protocol you want to use, and then resolve dependencies from the container based on the protocol, without having to know anything about specific implementations. This makes swapping the actual implementation for mocking or new implementations much simpler as you don't have to change the client code, just register the new implementation with the container and you're good to go.

This package **does not** handle circular dependencies.

Dependencies can be defined with three different lifetimes:

1- `eagerSingleton`: A singleton that's initialized and stored in the container and returned as-is whenever requested.

2- `lazySingleton`: A singleton that's initialized when first requested. the initialization can make use of other dependencies in the container.

3- `transient`: A new object is initialized whenever requested. The initialization cane make use of other dependencies in the container.



## Examples
The examples will be based on the following protocol and implementations:
```swift
protocol PrinterProtocol {
    func print(data: Any...)
}

class PrinterImplementation: PrinterProtocol {
    func print(data: Any...) {
        print(data)
    }
}

class PrinterMock: PrinterProtocol {
    func print(_: Any...) {
        print("Nothing")
    }
}
```
We can register to use a new instance of `PrinterImplementation` whenever we require an instance of `PrinterProtocol`:
```swift
let container = DIContainer()
container.register(PrinterProtocol.self, transient: { _ in PrinterImplementation() })
``` 
or as a singleton, so we reuse the same instance of `PrinterImplementation` anywhere:
```swift
container.register(PrinterProtocol.self, eagerSingleton: PrinterImplementation())
``` 
Regardless of which lifetime we choose, when we want to use the dependency it would look the same:
```swift
let printer = container[PrinterProtocol.self]
printer?.print("Hello")
```
The resolved dependency is an optional, and will return `nil` in case the dependency hasn't been previously registered.



