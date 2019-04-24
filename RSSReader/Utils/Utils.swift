//
//  Utils.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}

extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
