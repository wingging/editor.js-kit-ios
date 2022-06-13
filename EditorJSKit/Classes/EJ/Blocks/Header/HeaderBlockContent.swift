//
//  EJHeaderBlockContent.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

///
public class HeaderBlockContent: EJAbstractBlockContentSingleItem {
    public var item: EJAbstractBlockContentItem
    
    public func setItem(atIndex index: Int, contentItem: EJAbstractBlockContentItem) {
        item = contentItem
    }
    
    public init(contentItem: EJAbstractBlockContentItem){
        item = contentItem
    }
    
    required public init(from decoder: Decoder) throws {
        item = try HeaderBlockContentItem(from: decoder)
    }
    public func encode(to encoder: Encoder) throws {
        try item.encode(to: encoder)
    }
}

///
public class HeaderBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey { case text, level }
    public var text: String
    public var level: Int
    public var cachedAttributedString: NSAttributedString?
    
    public init(text: String, level: Int) {
        self.text = text
        self.level = level
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        level = try container.decode(Int.self, forKey: .level)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(level, forKey: .level)
    }
}
