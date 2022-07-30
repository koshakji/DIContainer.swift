//
//  DIContainer.swift
//  
//
//  Created by Majd Koshakji on 30/7/22.
//

public class DIContainer: DIContainerProtocol {
    private var dependencies: [String: Any]
    
    public init() {
        self.dependencies = [:]
    }
    
    private func `key`<Protocol>(for type: Protocol.Type) -> String {
        return "\(type)"
    }
    
    public func register<Protocol>(type: Protocol.Type, value: DILifecycle<Protocol>) {
        self.dependencies[self.key(for: type)] = value
    }
    
    public func has<Protocol>(type: Protocol.Type) -> Bool {
        return self.dependencies.index(forKey: self.key(for: type)) != nil
    }
    
    public subscript<Protocol>(_ type: Protocol.Type) -> Protocol? {
        get {
            guard let lifecycle = self.dependencies[self.key(for: type)] as? DILifecycle<Protocol> else {
                return nil
            }
            
            switch lifecycle {
            case .eagerSingleton(let value): return value
            case .lazySingleton(var lazy):
                let value = lazy.value(for: self)
                self.dependencies[self.key(for: type)] = lazy
                return value
            case .transient(let factory): return factory(self)
            }
        }
    }
}

