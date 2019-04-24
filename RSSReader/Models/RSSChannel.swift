//
//  RSSChannel.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit

class RSSChannel: Codable {
    var url: URL
    var imageURL: URL?
    var shortDescription: String?
    var title: String?
    var favorite: Bool = false

    init(url: URL) {
        self.url = url
    }
}
