//
//  ParagraphBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//

import Foundation

///
public class ParagraphBlockContent: EJAbstractBlockContentSingleItem {
    
    public var item: EJAbstractBlockContentItem
    
    public init(passedItem: EJAbstractBlockContentItem){
        item = passedItem
    }
    
    required public init(from decoder: Decoder) throws {
        item = try ParagraphBlockContentItem(from: decoder)
    }
    
    public func setItem(atIndex index: Int, contentItem: EJAbstractBlockContentItem) {
        item = contentItem
    }
    
    public func encode(to encoder: Encoder) throws {
        try item.encode(to: encoder)
    }
}

///
public class ParagraphBlockContentItem: EJAbstractBlockContentItem {
    public var text: String
    let htmlReadyText: String
    public var cachedAttributedString: NSAttributedString?
    
    public init(readyText: String, htmlText: String){
        text = readyText
        htmlReadyText = htmlText
    }
    
    enum CodingKeys: String, CodingKey { case text }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        htmlReadyText = text.replacingOccurrences(of: "\n", with: "<br>")
    }
}
