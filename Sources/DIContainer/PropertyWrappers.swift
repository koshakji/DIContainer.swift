//
//  PropertyWrappers.swift
//  
//
//  Created by Majd Koshakji on 9/7/23.
//


@propertyWrapper
public struct Resolved<T> {
    private let container: any DIContainerProtocol
    private let name: String?
    
    public init(
        container: any DIContainerProtocol = DISingletonContainer.shared,
        named name: String? = nil
    ) {
        self.container = container
        self.name = name
    }
    
    public var wrappedValue: T? {
        get {
            return self.container.resolve(T.self, named: name)
        }
    }
}

@propertyWrapper
public struct ForceResolved<T> {
    private let container: any DIContainerProtocol
    private let name: String?
    
    public init(
        container: any DIContainerProtocol = DISingletonContainer.shared,
        named name: String? = nil
    ) {
        self.container = container
        self.name = name
    }
    
    public var wrappedValue: T {
        get {
            return self.container.forceResolve(T.self, named: name)
        }
    }
}
