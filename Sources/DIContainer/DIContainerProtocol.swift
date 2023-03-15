//
//  DIContainerProtocol.swift
//  
//
//  Created by Majd Koshakji on 30/7/22.
//

public typealias DIFactory<T> = (any DIContainerProtocol) -> T?

public protocol DIContainerProtocol {
    func register<Protocol>(type: Protocol.Type, named: String?, value: DILifecycle<Protocol>)
    func has<Protocol>(type: Protocol.Type, named: String?) -> Bool
    func resolve<Protocol>(_ type: Protocol.Type, named: String?) -> Protocol?
    func isResettable<Protocol>(_ type: Protocol.Type, named: String?) -> Bool
    func reset<Protocol>(_ type: Protocol.Type, named: String?)
}

extension DIContainerProtocol {
    public func register<Protocol>(
        type: Protocol.Type = Protocol.self,
        named name: String? = nil,
        transient factory: @escaping DIFactory<Protocol>
    ) {
        self.register(
            type: type,
            named: name,
            value: .transient(factory)
        )
    }
    
    public func register<Protocol>(
        type: Protocol.Type = Protocol.self,
        named name: String? = nil,
        lazySingleton factory: @escaping DIFactory<Protocol>
    ) {
        self.register(
            type: type,
            named: name,
            value: .lazySingleton(factory)
        )
    }
    
    public func register<Protocol>(
        type: Protocol.Type = Protocol.self,
        named name: String? = nil,
        eagerSingleton dependency: Protocol
    ) {
        self.register(
            type: type,
            named: name,
            value: .eagerSingleton(dependency)
        )
    }
    
    public func register<Protocol>(
        type: Protocol.Type = Protocol.self,
        named name: String? = nil,
        cached factory: @escaping DIFactory<Protocol>
    ) {
        self.register(
            type: type,
            named: name,
            value: .cached(factory)
        )
    }
    
    public subscript<Protocol>(
        _ type: Protocol.Type,
        named name: String? = nil
    ) -> Protocol? {
        get { self.resolve(type, named: name) }
    }
    
    public func forceResolve<Protocol>(
        _ type: Protocol.Type = Protocol.self,
        named name: String? = nil
    ) -> Protocol {
        return self.resolve(type, named: name)!
    }
}

public extension DIContainerProtocol {
    private func getFactory<T>(from initializer: @escaping () -> T) -> DIFactory<T> {
        return { _ in initializer() }
    }
    
    func register<Protocol>(
        type: Protocol.Type = Protocol.self,
        named name: String? = nil,
        transient initializer: @escaping () -> Protocol
    ) {
        self.register(
            type: type,
            named: name,
            value: .transient(getFactory(from: initializer))
        )
    }
    
    func register<Protocol>(
        type: Protocol.Type = Protocol.self,
        named name: String? = nil,
        lazySingleton initializer: @escaping () -> Protocol
    ) {
        self.register(
            type: type,
            named: name,
            value: .lazySingleton(getFactory(from: initializer))
        )
    }
    
    
    func register<Protocol>(
        type: Protocol.Type = Protocol.self,
        named name: String? = nil,
        cached initializer: @escaping () -> Protocol
    ) {
        self.register(
            type: type,
            named: name,
            value: .cached(getFactory(from: initializer))
        )
    }
}


