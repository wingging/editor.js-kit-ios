//
//  DelimiterBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 19/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public class DelimiterBlockContent: EJAbstractBlockContentSingleItem {
    public var item: EJAbstractBlockContentItem = DelimiterBlockContentItem()
    
    public func setItem(atIndex index: Int, contentItem: EJAbstractBlockContentItem) {
        item = contentItem
    }
    
    enum CodingKeys: CodingKey {}
}

///
public class DelimiterBlockContentItem: EJAbstractBlockContentItem {
    var text = "\u{FF0A} \u{FF0A} \u{FF0A}"
}
