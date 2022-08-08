//
//  EJAbstractBlock.swift
//  EditorJSKit_Example
//
//  Created by Ivan Glushko on 12/06/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

///
public protocol EJAbstractBlockProtocol: Decodable, Encodable {
    var type: EJAbstractBlockType { get }
    var data: EJAbstractBlockContent { get }
}

///
open class EJAbstractBlock: EJAbstractBlockProtocol {
    public var type: EJAbstractBlockType
    public var data: EJAbstractBlockContent
    
    public enum CodingKeys: String, CodingKey { case type, data }
    
    public init(initType: EJAbstractBlockType, initData: EJAbstractBlockContent){
        type = initType
        data = initData
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let kit = (decoder.userInfo[EJKit.Keys.kit.codingUserInfo] as? EJKit) ?? .shared
        
        // Loop through custom blocks
        for customBlock in kit.registeredCustomBlocks {
            guard let type = try? customBlock.type.decode(container: container) else { continue }
            guard let data = try? customBlock.abstractContentClass.init(from: decoder) else {
                throw DecodingError.typeMismatch(
                    EJAbstractBlockContent.self,
                    DecodingError.Context(
                        codingPath: [CodingKeys.type],
                        debugDescription: "Block's content type didn't match declared type \(type.rawValue)"))
            }
            self.type = type
            self.data = data
            return
        }
        
        if let type = try? container.decode(EJNativeBlockType.self, forKey: .type) {
            self.type = type
            switch type {
            case .header:
                self.data = try container.decode(HeaderBlockContent.self, forKey: .data)
            case .image:
                self.data = try container.decode(ImageBlockContent.self, forKey: .data)
            case .list:
                self.data = try container.decode(ListBlockContent.self, forKey: .data)
            case .linkTool:
                self.data = try container.decode(LinkBlockContent.self, forKey: .data)
            case .delimiter:
                self.data = try container.decode(DelimiterBlockContent.self, forKey: .data)
            case .paragraph:
                self.data = try container.decode(ParagraphBlockContent.self, forKey: .data)
            case .raw:
                self.data = try container.decode(RawHtmlBlockContent.self, forKey: .data)
            }
            return
        }
        
        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: [CodingKeys.type],
                debugDescription: "Unable to parse block - no native or custom type found"))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type.rawValue, forKey: .type)
        switch type.rawValue{
            case "header":
                let data = self.data as! HeaderBlockContent
                try container.encode(data, forKey: .data)
            case "image":
                let data = self.data as! ImageBlockContent
                try container.encode(data, forKey: .data)
            case "list":
                let data = self.data as! ListBlockContent
                try container.encode(data, forKey: .data)
            case "linkTool":
                let data = self.data as! LinkBlockContent
                try container.encode(data, forKey: .data)
            case "delimiter":
                let data = self.data as! DelimiterBlockContent
                try container.encode(data, forKey: .data)
            case "paragraph":
                let data = self.data as! ParagraphBlockContent
            try container.encode(data, forKey: .data)
            case "raw":
                let data = self.data as! RawHtmlBlockContent
                try container.encode(data, forKey: .data)
            default:
                print("Not item encoded")
        }
    }
}
