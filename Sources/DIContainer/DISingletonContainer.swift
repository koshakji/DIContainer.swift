//
//  DISingletonContainer.swift
//  
//
//  Created by Majd Koshakji on 2/4/23.
//

import Foundation

public class DISingletonContainer: DIContainer {
    public static var shared: DISingletonContainer = .init()
    
    private override init() {
        super.init()
    }
}
