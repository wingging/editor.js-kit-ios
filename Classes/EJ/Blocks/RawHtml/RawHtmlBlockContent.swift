//
//  RawHtmlBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 21/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public class RawHtmlBlockContent: EJAbstractBlockContentSingleItem {
    public var item: EJAbstractBlockContentItem
    
    public init(passedItem: EJAbstractBlockContentItem){
        item = passedItem
    }
    
    public func setItem(atIndex index: Int, contentItem: EJAbstractBlockContentItem) {
        item = contentItem
    }
    
    public required init(from decoder: Decoder) throws {
        item = try RawHtmlBlockContentItem(from: decoder)
    }
    public func encode(to encoder: Encoder) throws {
        try item.encode(to: encoder)
    }
}

///
public class RawHtmlBlockContentItem: EJAbstractBlockContentItem {
    public var html: String
    var cachedAttributedString: NSAttributedString?
    
    enum CodingKeys: String, CodingKey { case html }
    
    public init(passedHtml: String){
        html = passedHtml
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        html = try container.decode(String.self, forKey: .html)
    }
}
