//
//  LinkBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
public class LinkBlockContent: EJAbstractBlockContentSingleItem {
    public private(set) var item: EJAbstractBlockContentItem
    public var link: URL
    
    public init(url: String, item: EJAbstractBlockContentItem){
        let convertUrl = URL(string: url)
        if convertUrl != nil{
            link = convertUrl!
        }else{
            link = URL(string: "https://iconscout.com/icon/file-not-found")!
        }
        
        self.item = item
    }
    
    public func setItem(atIndex index: Int, contentItem: EJAbstractBlockContentItem) {
        item = contentItem
    }
    
    enum CodingKeys: String, CodingKey { case link, meta }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        link = try container.decode(URL.self, forKey: .link)
        let item = try container.decode(LinkBlockContentItem.self, forKey: .meta)
        item.link = link
        item.formattedLink = LinkFormatterService.format(link: link)
        self.item = item
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(link, forKey: .link)
        let linkItem = item as! LinkBlockContentItem
        try container.encode(linkItem, forKey: .meta)
    }
}

///
public class LinkBlockContentItem: EJAbstractBlockContentItem {
    public var link: URL?
    
    private let title: String
    private let siteName: String?
    public var description: String?
    
    public let image: ImageFile?
    public var formattedLink: String?
    
    var cachedTitleAttributedString: NSAttributedString?
    var cachedSiteNameAttributedString: NSAttributedString?
    var cachedDescriptionAttributedString: NSAttributedString?
    
    public init(title: String, siteName: String, description: String){
        self.title = title
        self.siteName = siteName
        self.description = description
        image = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case title, site_name, description, image
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        siteName = try container.decodeIfPresent(String.self, forKey: .site_name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        image = try container.decodeIfPresent(ImageFile.self, forKey: .image)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(siteName, forKey: .site_name)
        try container.encode(description, forKey: .description)
        try container.encode(image, forKey: .image)
    }
    
    func prepareCachedStrings(withStyle style: EJLinkBlockStyle) {
        if cachedTitleAttributedString == nil {
            cachedTitleAttributedString = title.convertHTML(font: style.titleFont)
        }
        
        if cachedSiteNameAttributedString == nil {
            cachedSiteNameAttributedString = siteName?.convertHTML(font: style.titleFont)
        }
        
        if cachedDescriptionAttributedString == nil {
            cachedDescriptionAttributedString = description?.convertHTML(font: style.descriptionFont)
        }
    }
}
