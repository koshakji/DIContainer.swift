//
//  DILifecycle.swift
//  
//
//  Created by Majd Koshakji on 30/7/22.
//

public enum DILifecycle<T> {
    case eagerSingleton(T)
    case lazySingleton(DILazyContainer<T>)
    case transient(DIFactory<T>)
    case cached(DICached<T>)
}

internal extension DILifecycle {
    func reset() {
        if case .cached(let cached) = self {
            cached.reset()
        }
    }
    
    func isResettable() -> Bool {
        if case .cached(let cached) = self { return cached.isCached }
        return false
    }
}


public class DILazyContainer<T> {
    private var value: DILazy<T>
    
    
    init(factory: @escaping DIFactory<T>) {
        self.value = .uninitialized(factory)
    }
    
    func value(for container: any DIContainerProtocol) -> T? {
        switch self.value {
        case .initialized(let v):
            return v
        case .uninitialized(let factory):
            let v = factory(container)
            self.value = .initialized(v)
            return v
        }
    }
    
    private enum DILazy<T> {
        case uninitialized(DIFactory<T>)
        case initialized(T?)
    }
}

public class DICached<T> {
    private let factory: DIFactory<T>
    private var cached: T? = nil
    
    var isCached: Bool { cached == nil }
    
    public init(factory: @escaping DIFactory<T>) {
        self.factory = factory
    }
    
    func value(for container: any DIContainerProtocol) -> T? {
        if cached == nil {
            self.cached = self.factory(container)
        }
        return cached
    }
    
    func reset() {
        self.cached = nil
    }
}
