//
//  ImageBlockContent.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
open class ImageBlockContent: EJAbstractBlockContentSingleItem {
    public var item: EJAbstractBlockContentItem
    
    public func setItem(atIndex index: Int, contentItem: EJAbstractBlockContentItem) {
        item = contentItem
    }
    
    required public init(from decoder: Decoder) throws {
        item = try ImageBlockContentItem(from: decoder)
    }
    
    public func encode(to encoder: Encoder) throws {
        try item.encode(to: encoder)
    }
}

///
public class ImageBlockContentItem: EJAbstractBlockContentItem {
    enum CodingKeys: String, CodingKey { case file, caption, withBorder,stretched, withBackground }
    public let file: ImageFile
    public var caption: String
    public let withBorder: Bool
    public let stretched: Bool
    public let withBackground: Bool
    
    var cachedAttributedCaption: NSAttributedString?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        file = try container.decode(ImageFile.self, forKey: .file)
        caption = try container.decode(String.self, forKey: .caption)
        withBorder = try container.decode(Bool.self, forKey: .withBorder)
        stretched = try container.decode(Bool.self, forKey: .stretched)
        withBackground = try container.decode(Bool.self, forKey: .withBackground)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(file, forKey: .file)
        try container.encode(caption, forKey: .caption)
        try container.encode(withBorder, forKey: .withBorder)
        try container.encode(stretched, forKey: .stretched)
        try container.encode(withBackground, forKey: .withBackground)
    }
}

///
public class ImageFile: Decodable, Encodable {
    enum CodingKeys: String, CodingKey { case url }
    
    public let url: URL
    public var imageData: Data?
    public var callback: (() -> Void)?
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(URL.self, forKey: .url)
        DataDownloaderService.downloadFile(at: url) { [weak self] (data, downloadedUrl) in
            self?.imageData = data
            self?.callback?()
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
    }
}
