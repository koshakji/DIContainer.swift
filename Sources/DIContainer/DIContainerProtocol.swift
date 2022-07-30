//
//  DIContainerProtocol.swift
//  
//
//  Created by Majd Koshakji on 30/7/22.
//

public typealias DIFactory<T> = (any DIContainerProtocol) -> T?

public protocol DIContainerProtocol {
    func register<Protocol>(type: Protocol.Type, value: DILifecycle<Protocol>)
    func has<Protocol>(type: Protocol.Type) -> Bool
    subscript<Protocol>(_: Protocol.Type) -> Protocol? { get }
}

extension DIContainerProtocol {
    public func register<Protocol>(type: Protocol.Type, transient factory: @escaping DIFactory<Protocol>) {
        self.register(type: type, value: .transient(factory))
    }
    
    public func register<Protocol>(type: Protocol.Type, lazySingleton factory: @escaping DIFactory<Protocol>) {
        self.register(type: type, value: .lazySingleton(DILazy(factory: factory)))
    }
    
    public func register<Protocol>(type: Protocol.Type, eagerSingleton dependency: Protocol) {
        self.register(type: type, value: .eagerSingleton(dependency))
    }
    
    public func resolve<Protocol>(_ type: Protocol.Type) -> Protocol? {
        return self[type]
    }
}
