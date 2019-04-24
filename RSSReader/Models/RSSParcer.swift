//
//  RSSParcer.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit
import MWFeedParser

enum RSSParcerError: Error {
    case parcingInProgress
}
class RSSParcer: NSObject {
    private(set) var items = [MWFeedItem]()
    private(set) var channel: RSSChannel?
    private var completion: (([MWFeedItem], Error?) -> Void)?
    private var isPacring = false

    func parce(_ channel: RSSChannel, completion: @escaping (([MWFeedItem], Error?) -> Void)) throws {
        if isPacring {
            throw RSSParcerError.parcingInProgress
        }
        isPacring = true

        self.channel = channel
        self.completion = completion

        if let parcer = MWFeedParser(feedURL: channel.url) {
            parcer.delegate = self
            parcer.parse()
        }
    }
}

//swiftlint:disable implicitly_unwrapped_optional
extension RSSParcer: MWFeedParserDelegate {
    func feedParserDidStart(_ parser: MWFeedParser!) {
        self.items = [MWFeedItem]()
    }

    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        self.channel?.title = info.title
        self.channel?.summary = info.summary
    }

    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        self.items.append(item)
    }

    func feedParserDidFinish(_ parser: MWFeedParser!) {
        completion?(items, nil)
        completion = nil
        isPacring = false
    }

    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        completion?(items, error)
        completion = nil
        isPacring = false
    }
}
