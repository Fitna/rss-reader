//
//  WeakRef.swift
//  MegaGame
//
//  Created by Oleg Matveev on 09/04/2019.
//  Copyright © 2019 Megastar. All rights reserved.
//

import Foundation

protocol WeakRefProtocol {
    associatedtype GenericType: AnyObject
}

struct WeakRef<T>: WeakRefProtocol where T: AnyObject {
    typealias GenericType = T

    private(set) weak var value: T?

    init(value: T?) {
        self.value = value
    }
}

extension Array where Element: WeakRefProtocol {
    mutating func clean() {
        self = self.filter { ($0 as? WeakRef<Element.GenericType>)?.value != nil }
    }

    func getObjects() -> [Element.GenericType] {
        return self.compactMap { ($0 as? WeakRef<Element.GenericType>)?.value }
    }

    mutating func reap() -> [Element.GenericType] {
        var refs: [Element] = []
        var objects: [Element.GenericType] = []

        self.forEach({
            let wref = $0 as? WeakRef<Element.GenericType>
            let value = wref?.value
            if let object = value {
                refs.append($0)
                objects.append(object)
            }
        })
        self = refs
        return objects
    }
}
