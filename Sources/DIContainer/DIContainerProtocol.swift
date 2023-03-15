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
}

extension DIContainerProtocol {
    public func register<Protocol>(
        type: Protocol.Type = Protocol.self,
        named name: String? = nil,
        transient factory: @escaping DIFactory<Protocol>) {
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
            value: .lazySingleton(DILazyContainer(factory: factory))
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
