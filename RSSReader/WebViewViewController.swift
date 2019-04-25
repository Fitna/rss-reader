//
//  WebViewViewController.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 25/04/2019.
//

import UIKit
import MWFeedParser

class WebViewViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    var link: URL? { didSet { updateLink() } }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }

    func updateLink() {
        self.loadViewIfNeeded()
        webView.stopLoading()
        if let link = link {
            webView.loadRequest(URLRequest(url: link))
        }
    }
}

extension WebViewViewController: UIWebViewDelegate {
}
