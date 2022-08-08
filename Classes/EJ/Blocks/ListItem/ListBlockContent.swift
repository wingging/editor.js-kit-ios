//
//  ListBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public enum ListBlockStyle: String, Decodable {
    case unordered
    case ordered
}

///
public class ListBlockContent: EJAbstractBlockContent {
    
    public var style: ListBlockStyle
    public var items: [ListBlockContentItem]
    public var numberOfItems: Int { return items.count }
    
    public init(firstItem: ListBlockContentItem){
        style = .unordered
        items = [firstItem]
    }
    
    public func getItem(atIndex index: Int) -> EJAbstractBlockContentItem? {
        guard items.indices.contains(index) else { return nil }
        return items[index]
    }
    
    public func setItem(atIndex index: Int, contentItem: EJAbstractBlockContentItem) {
        items[index] = contentItem as! ListBlockContentItem
    }
    
    public func removeItem(atIndex: Int){
        items.remove(at: atIndex)
    }
    
    enum CodingKeys: String, CodingKey { case style, items }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let style = try container.decode(ListBlockStyle.self, forKey: .style)
        self.style = style
        if let items = try? container.decode([String].self, forKey: .items) {
            self.items = items.enumerated().map { return ListBlockContentItem(text: $1, index: $0 + 1, style: style) }
        } else {
            throw DecodingError.typeMismatch([ListBlockContentItem].self,
                                             DecodingError.Context(codingPath: [CodingKeys.items],
                                             debugDescription: "Couldn't parse items"))}
        
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(style.rawValue, forKey: .style)
        try container.encode(items, forKey: .items)
    }
    
}

///
public class ListBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey {  case text }
    public let style: ListBlockStyle
    public var text: String
    public let index: Int
    
    var cachedAttributedString: NSAttributedString?
    
    public init(text: String, index: Int, style: ListBlockStyle) {
        self.text = text
        self.index = index
        self.style = style
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        index = .zero
        style = .unordered
    }
    
    public func encode(to encoder: Encoder) throws {
        try text.encode(to: encoder)
    }
    
    func prepareCachedAttributedString(withStyle style: EJListBlockStyle) {
        if cachedAttributedString == nil {
            cachedAttributedString = text.convertHTML(font: style.font)
        }
    }
}
