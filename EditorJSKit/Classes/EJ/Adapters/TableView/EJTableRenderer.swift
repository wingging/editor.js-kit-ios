//
//  EJTableRenderer.swift
//  EditorJSKit
//
//  Created by Chang Wing Le on 07/06/2022.
//

import Foundation

///
open class EJTableRenderer: EJTableBlockRenderer {
    unowned public var tableView: UITableView
    
    public typealias View = UITableViewCell
    
    public var startSectionIndex: Int = .zero
    
    private let kit: EJKit
    
    public init(tableView: UITableView, kit: EJKit = .shared) {
        self.tableView = tableView
        self.kit = kit
    }
        
    /**
     */
    public func render(block: EJAbstractBlock, indexPath: IndexPath, style: EJBlockStyle? = nil) throws -> View {
        let style = style ?? kit.style.getStyle(forBlockType: block.type)
        
        if let customBlock = kit.retrieveCustomBlock(ofType: block.type) as? EJCustomBlockTableAdaptable,
           let contentItem = block.data.getItem(atIndex: indexPath.item),
           let cell = customBlock.prepareCell(forTableView: tableView,
                                              contentItem: contentItem,
                                              indexPath: indexPath,
                                              style: style) {
            return cell
        }
        
        switch block.type {
            
        case EJNativeBlockType.header:
            typealias Cell = TableViewBlockCell<HeaderBlockView>
            let reuseId = HeaderBlockView.reuseId
            tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
            let content = block.data as! HeaderBlockContent
            let item = content.getItem(atIndex: .zero) as! HeaderBlockContentItem
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! Cell
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.image:
            typealias Cell = TableViewBlockCell<ImageBlockView>
            let reuseId = ImageBlockView.reuseId
            tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
            let content = block.data as! ImageBlockContent
            let item = content.getItem(atIndex: indexPath.item) as! ImageBlockContentItem
            if item.file.imageData == nil {
                item.file.callback = { [weak self] in
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! Cell
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.list:
            typealias Cell = TableViewBlockCell<ListItemBlockView>
            let reuseId = ListItemBlockView.reuseId
            tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
            let content = block.data as! ListBlockContent
            let item = content.getItem(atIndex: indexPath.item) as! ListBlockContentItem
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! Cell
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.linkTool:
            typealias Cell = TableViewBlockCell<LinkBlockView>
            let reuseId = LinkBlockView.reuseId
            tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
            let content = block.data as! LinkBlockContent
            let item = content.getItem(atIndex: .zero) as! LinkBlockContentItem
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! Cell
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.delimiter:
            typealias Cell = TableViewBlockCell<DelimiterBlockView>
            let reuseId = DelimiterBlockView.reuseId
            tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
            let content = block.data as! DelimiterBlockContent
            let item = content.getItem(atIndex: .zero) as! DelimiterBlockContentItem
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! Cell
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.paragraph:
            typealias Cell = TableViewBlockCell<ParagraphBlockView>
            let reuseId = ParagraphBlockView.reuseId
            tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
            let content = block.data as! ParagraphBlockContent
            let item = content.getItem(atIndex: .zero) as! ParagraphBlockContentItem
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! Cell
            cell.configure(withItem: item, style: style)
            return cell
            
        case EJNativeBlockType.raw:
            typealias Cell = TableViewBlockCell<RawHtmlBlockView>
            let reuseId = RawHtmlBlockView.reuseId
            tableView.register(Cell.self, forCellReuseIdentifier: reuseId)
            let content = block.data as! RawHtmlBlockContent
            let item = content.getItem(atIndex: .zero) as! RawHtmlBlockContentItem
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! Cell
            cell.configure(withItem: item, style: style)
            return cell
            
        default: throw EJError.missmatch
        }
        
    }
    
    public func size(forBlock block: EJAbstractBlock, itemIndex: Int, style: EJBlockStyle?, superviewSize: CGSize) throws -> CGSize {
        
        if let customBlock = kit.retrieveCustomBlock(ofType: block.type) as? EJCustomBlockTableAdaptable,
           let size = customBlock.estimatedSize(forBlock: block,
                                                itemIndex: itemIndex,
                                                style: style,
                                                superviewSize: superviewSize) {
            return size
        }
        
        switch block.type {
        case EJNativeBlockType.header:
            return HeaderNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! HeaderBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.image:
            return ImageNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! ImageBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.list:
            return ListItemNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! ListBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.linkTool:
            return LinkNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! LinkBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.delimiter:
            return DelimiterNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! DelimiterBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.paragraph:
            return ParagraphNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! ParagraphBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        case EJNativeBlockType.raw:
            return RawHtmlNativeContentView.estimatedSize(for: block.data.getItem(atIndex: itemIndex) as! RawHtmlBlockContentItem, style: style, boundingWidth: superviewSize.width)
            
        default: return kit.style.defaultItemSize
        }
    }
    
    public func insets(forBlock block: EJAbstractBlock) -> UIEdgeInsets {
        var insets = kit.style.defaultSectionInsets
        switch block.type {
        case EJNativeBlockType.header:
            guard
                let headerItem = (block.data as? HeaderBlockContent)?.getItem(atIndex: 0) as? HeaderBlockContentItem,
                let headerStyle = kit.style.getStyle(forBlockType: block.type) as? EJHeaderBlockStyle
            else { return insets }
            insets.top += headerStyle.topInset(forHeaderLevel: headerItem.level)
            insets.bottom += headerStyle.bottomInset(forHeaderLevel: headerItem.level)
            return insets
        default:
            break
        }
        return insets
    }
    
    public func spacing(forBlock block: EJAbstractBlock) -> CGFloat {
        if let style = kit.style.getStyle(forBlockType: block.type) {
            return style.lineSpacing
        }
        return kit.style.defaultItemsLineSpacing
    }
}

