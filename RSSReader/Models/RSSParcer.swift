//
//  RSSParcer.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit
import MWFeedParser

class RSSParcer: NSObject {
    private var items: [MWFeedItem] = []
    let channel: RSSChannel

    private var completions: [(([MWFeedItem], Error?) -> Void)] = []
    private var isPacring = false

    private static var parcers: [WeakRef<RSSParcer>] = []

    static func parce(_ channel: RSSChannel, completion: @escaping (([MWFeedItem], Error?) -> Void)) {
        var parcer = parcers.reap().first(where: { $0.channel == channel })
        if parcer == nil {
            parcer = RSSParcer(with: channel)
            self.parcers.append(WeakRef(value: parcer))
        }
        parcer?.parce(with: completion)
    }

    private init(with channel: RSSChannel) {
        self.channel = channel
    }

    private func parce(with completion: @escaping (([MWFeedItem], Error?) -> Void)) {
        self.completions.append(completion)
        if isPacring {
            return
        }
        isPacring = true

        DispatchQueue.global(qos: .background).async {
            if let parcer = MWFeedParser(feedURL: self.channel.url) {
                parcer.delegate = self
                parcer.parse()
            }
        }
    }
}

//swiftlint:disable implicitly_unwrapped_optional
extension RSSParcer: MWFeedParserDelegate {
    func feedParserDidStart(_ parser: MWFeedParser!) {
        self.items = [MWFeedItem]()
    }

    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        self.channel.title = info.title
        self.channel.summary = info.summary
    }

    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        self.items.append(item)
    }

    func feedParserDidFinish(_ parser: MWFeedParser!) {
        DispatchQueue.main.async {
            for completion in self.completions {
                completion(self.items, nil)
            }
            self.completions = []
            self.isPacring = false
        }
    }

    func feedParser(_ parser: MWFeedParser!, didFailWithError error: Error!) {
        DispatchQueue.main.async {
            print("parser error \(self.channel.url): \(error.localizedDescription)")
            for completion in self.completions {
                completion(self.items, error)
            }
            self.completions = []
            self.isPacring = false
        }
    }
}
