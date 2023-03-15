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
