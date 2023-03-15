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
    
    public func has<Protocol>(type: Protocol.Type = Protocol.self) -> Bool {
        return self.dependencies.index(forKey: self.key(for: type)) != nil
    }
    
    public subscript<Protocol>(_ type: Protocol.Type = Protocol.self) -> Protocol? {
        get {
            guard let lifecycle = self.dependencies[self.key(for: type)] as? DILifecycle<Protocol> else {
                return nil
            }
            
            switch lifecycle {
            case .eagerSingleton(let value): return value
            case .lazySingleton(let lazy): return lazy.value(for: self)
            case .transient(let factory): return factory(self)
            }
        }
    }
}

