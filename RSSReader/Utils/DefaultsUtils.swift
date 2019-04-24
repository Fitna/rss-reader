//
//  DefaultsUtils.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

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
        return channels ?? []
    }

    static func save(channels: [RSSChannel]) {
        if let data = try? JSONEncoder().encode(channels) {
            UserDefaults.standard.set(data, forKey: Keys.channels.rawValue)
            InnerNotification.channelsDidChange.post(object: channels)
        }
    }
}
