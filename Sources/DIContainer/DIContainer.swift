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
    
    private func getLifecycle<Protocol>(
        _ type: Protocol.Type,
        named name: String?
    ) -> DILifecycle<Protocol>? {
        self.dependencies[self.key(for: type, named: name)] as? DILifecycle<Protocol>
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
        guard let lifecycle = self.getLifecycle(type, named: name) else {
            return nil
        }
        
        switch lifecycle {
        case .eagerSingleton(let value): return value
        case .lazySingleton(let lazy): return lazy.value(for: self)
        case .transient(let factory): return factory(self)
        case .cached(let cached): return cached.value(for: self)
        }
    }
    
    public func isResettable<Protocol>(_ type: Protocol.Type, named name: String? = nil) -> Bool {
        guard let lifecycle = self.getLifecycle(type, named: name) else {
            return false
        }
        return lifecycle.isResettable()
    }
    
    public func reset<Protocol>(_ type: Protocol.Type, named name: String? = nil) {
        guard let lifecycle = self.getLifecycle(type, named: name) else {
            return
        }
        lifecycle.reset()
    }
}

