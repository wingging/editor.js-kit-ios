//
//  BaseBlockContentItem.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 30.05.2022.
//

import Foundation

///
public struct BlockContent {
    ///
    public struct Single<ContentItem: EJAbstractBlockContentItem>: EJAbstractBlockContentSingleItem {
        
        public var item: EJAbstractBlockContentItem
        
        ///
        private enum CodingKeys: String, CodingKey {
            case data
        }
        
        public func setItem(atIndex index: Int, contentItem: EJAbstractBlockContentItem) {
            //item = contentItem
        }
        
        public init(from decoder: Decoder) throws {
            if let item = try? ContentItem(from: decoder) {
                self.item = item
            } else {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                item = try container.decode(ContentItem.self, forKey: .data)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            //var container = encoder.container(keyedBy: CodingKeys.self)
            try item.encode(to: encoder)
            //try container.encode(item, forKey: .data)
        }
    }
}
