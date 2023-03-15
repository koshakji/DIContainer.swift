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
    
    private func `key`<Protocol>(for type: Protocol.Type, named name: String?) -> String {
        if let name {
            return "\(name)|\(type)"
        } else {
            return "\(type)"
        }
    }
    
    public func register<Protocol>(
        type: Protocol.Type,
        named name: String? = nil,
        value: DILifecycle<Protocol>
    ) {
        self.dependencies[self.key(for: type, named: name)] = value
    }
    
    public func has<Protocol>(
        type: Protocol.Type = Protocol.self,
        named name: String? = nil
    ) -> Bool {
        return self.dependencies.index(forKey: self.key(for: type, named: name)) != nil
    }
    
    public func resolve<Protocol>(
        _ type: Protocol.Type = Protocol.self,
        named name: String? = nil
    ) -> Protocol? {
        guard let lifecycle = self.dependencies[self.key(for: type, named: name)] as? DILifecycle<Protocol> else {
            return nil
        }
        
        switch lifecycle {
        case .eagerSingleton(let value): return value
        case .lazySingleton(let lazy): return lazy.value(for: self)
        case .transient(let factory): return factory(self)
        }
    }
}

