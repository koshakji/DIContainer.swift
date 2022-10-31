# DIContainer.swift

This package is an experimental Dependency Injection Container written in Swift.

The goal is to register which implementation of any protocol you want to use, and then resolve dependencies from the container based on the protocol, without having to know anything about specific implementations. This makes swapping the actual implementation for mocking or new implementations much simpler as you don't have to change the client code, just register the new implementation with the container and you're good to go.

This package **does not** handle circular dependencies.

Dependencies can be defined with three different lifetimes:

- `eagerSingleton`: A singleton that's initialized and stored in the container and returned as-is whenever requested.

- `lazySingleton`: A singleton that's initialized when first requested. the initialization can make use of other dependencies in the container.

- `transient`: A new object is initialized whenever requested. The initialization can make use of other dependencies in the container.
