//
//  DILifecycle.swift
//  
//
//  Created by Majd Koshakji on 30/7/22.
//

public enum DILifecycle<T> {
    case eagerSingleton(T)
    case lazySingleton(DILazy<T>)
    case transient(DIFactory<T>)
}

public enum DILazy<T> {
    case uninitialized(DIFactory<T>)
    case initialized(T?)
    
    init(factory: @escaping DIFactory<T>) {
        self = .uninitialized(factory)
    }
    
    mutating func value(for container: any DIContainerProtocol) -> T? {
        switch self {
        case .uninitialized(let factory):
            let value = factory(container)
            self = .initialized(value)
            return value
        case .initialized(let value):
            return value
        }
    }
}
