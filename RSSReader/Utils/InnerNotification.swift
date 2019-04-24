//
//  InnerNotification.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit

enum InnerNotification: String {
    case channelsDidChange
    case channelInfoDidChange

    private func getFullName() -> NSNotification.Name {
        return NSNotification.Name(rawValue: "com.astrum-vitriolum.rss-reader." + self.rawValue)
    }

    func post(object: Any?) {
        NotificationCenter.default.post(name: getFullName(), object: object)
    }

    func startObserve(by object: NSObject, selector: Selector) {
        NotificationCenter.default.addObserver(object, selector: selector, name: getFullName(), object: nil)
    }

    func stopObserve(by object: NSObject) {
        NotificationCenter.default.removeObserver(object, name: getFullName(), object: nil)
    }
}
