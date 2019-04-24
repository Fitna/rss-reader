//
//  DefaultsUtils.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//
//swiftlint:disable force_unwrapping

import UIKit

enum DefaultsUtils {
    enum Keys: String {
        case channels
    }

    static func getChannels() -> [RSSChannel] {
        var channels: [RSSChannel]?
        if let data = UserDefaults.standard.data(forKey: Keys.channels.rawValue) {
            channels = try? JSONDecoder().decode([RSSChannel].self, from: data)
        }
        return channels ?? [RSSChannel(url: URL(string: "https://www.liga.net/news/rss.xml")!),
                            RSSChannel(url: URL(string: "https://www.liga.net/tech/technology/rss.xml")!),
                            RSSChannel(url: URL(string: "https://www.liga.net/fin/crypto/rss.xml")!)]
    }

    private static func save(channels: [RSSChannel]) {
        if let data = try? JSONEncoder().encode(channels) {
            UserDefaults.standard.set(data, forKey: Keys.channels.rawValue)
        }
    }

    static func save(channel: RSSChannel) {
        var channels: [RSSChannel] = getChannels()
        if let index = channels.firstIndex(of: channel) {
            channels[index] = channel
            InnerNotification.channelInfoDidChange.post(object: channel)
        } else {
            channels.append(channel)
            InnerNotification.channelsDidChange.post(object: channels)
        }
        self.save(channels: channels)
    }

    static func remove(channel: RSSChannel) {
        var channels: [RSSChannel] = getChannels()
        if let index = channels.firstIndex(of: channel) {
            channels.remove(at: index)
            self.save(channels: channels)
            InnerNotification.channelsDidChange.post(object: channels)
        }
    }
}
