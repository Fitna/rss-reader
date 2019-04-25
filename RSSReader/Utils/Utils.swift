//
//  Utils.swift
//  RSSReader
//
//  Created by Akira Silverhaze on 24/04/2019.
//

import UIKit
import MWFeedParser

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

extension UIViewController {
    func presentAlert(with text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: { _ in
        }))

        present(alert, animated: true, completion: nil)
    }
}

extension MWFeedItem {
    private func findImageURL(in array: [Any]) -> URL? {
        for item in array {
            if let dictionary = item as? [String: Any] {
                if let string = dictionary["url"] as? String {
                    if let url = URL(string: string) {
                        return url
                    }
                }
            }
        }
        return nil
    }

    func imageURL() -> URL? {
        if let url = self.findImageURL(in: self.enclosures) {
            return url
        }

        if !(content ?? "").isEmpty {
            let regex = try? NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: [])
            let range = NSRange(location: 0, length: content.count)
            if let match = regex?.firstMatch(in: content, options: [], range: range) {
                let url = (content as NSString).substring(with: match.range(at: 2))
                print("\(url)")
                return URL(string: url)
            }
        }
        return nil
    }
    /*
     NSString *htmlContent = item.content;
     NSString *imgSrc;

     // find match for image
     NSRange rangeOfString = NSMakeRange(0, [htmlContent length]);
     NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@ options:0 error:nil];

     if ([htmlContent length] > 0) {
     NSTextCheckingResult *match = [regex firstMatchInString:htmlContent options:0 range:rangeOfString];

     if (match != NULL ) {
     NSString *imgUrl = [htmlContent substringWithRange:[match rangeAtIndex:2]];
     NSLog(@"url: %@", imgUrl);

     //NSLog(@"match %@", match);
     if ([[imgUrl lowercaseString] rangeOfString:@"feedburner"].location == NSNotFound) {
     imgSrc = imgUrl;
     }
     }
     }
 */
}
