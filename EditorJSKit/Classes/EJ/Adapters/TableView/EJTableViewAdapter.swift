//
//  EJTableViewAdapter.swift
//  EditorJSKit
//
//  Created by Chang Wing Le on 07/06/2022.
//

import Foundation

///
public final class EJTableViewAdapter: NSObject, UITextViewDelegate {
    
    ///
    unowned let tableView: UITableView
    private let kit: EJKit
    public var dataSource: EJTableDataSource?
    public var adapterDelegate: EJTableViewAdapterDelegate?
    
    //public var delegate: EJTableViewAdapterDelegate?
    /// Custom delegate if you witsh to override sizes / insets
    public var delegate: UITableViewDelegate? {
        didSet {
            tableView.delegate = delegate
        }
    }

    
    // MARK: Inner tools
    private lazy var renderer = EJTableRenderer(tableView: tableView, kit: kit)
    
    /**
     */
    public init(tableView: UITableView, kit: EJKit = .shared) {
        self.tableView = tableView
        self.kit = kit
        super.init()
        tableView.dataSource = self
        delegate = self
        tableView.delegate = delegate
    }
    
    public func newEditBlock(upOrDown: Bool, blockType: EJNativeBlockType){
        let indexPath = tableView.indexPathForSelectedRow
        
        if indexPath == nil{
            return
        }
        
        let insertRow = indexPath!.section + (upOrDown ? 0 : 1)
        
        switch blockType{
            case EJNativeBlockType.header:
                let contentItem = HeaderBlockContentItem(text: "", level: 1)
                let block = EJAbstractBlock(initType: EJNativeBlockType.header, initData: HeaderBlockContent(contentItem: contentItem))
                adapterDelegate?.add(block: block, index: insertRow)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case EJNativeBlockType.image:
                /*
                ImageBlockContentItem
                let contentItem = HeaderBlockContentItem(text: "", level: 1)
                debugPrint(contentItem)
                
                 let block = EJAbstractBlock(initType: EJNativeBlockType.header, initData: HeaderBlockContent(contentItem: contentItem))
                adapterDelegate?.add(block: block, index: indexPath!.section + (upOrDown ? -1 : 1))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                */
                break
            case EJNativeBlockType.list:
                let contentItem = ListBlockContentItem(text: "Test here", index: .zero, style: .unordered)
                let block = EJAbstractBlock(initType: EJNativeBlockType.list, initData: ListBlockContent(firstItem: contentItem))
                adapterDelegate?.add(block: block, index: insertRow)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case EJNativeBlockType.linkTool:
                let contentItem = LinkBlockContentItem(title: "Testing", siteName: "Testng", description: "Linking")
                let block = EJAbstractBlock(initType: EJNativeBlockType.linkTool, initData: LinkBlockContent(url: "https://iconscout.com/icon/file-not-found", item: contentItem))
                adapterDelegate?.add(block: block, index: insertRow)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case EJNativeBlockType.delimiter:
                let block = EJAbstractBlock(initType: EJNativeBlockType.delimiter, initData: DelimiterBlockContent())
                adapterDelegate?.add(block: block, index: insertRow)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                break
            case EJNativeBlockType.paragraph:
                let contentItem = ParagraphBlockContentItem(readyText: "Test1", htmlText: "Test2")
                let block = EJAbstractBlock(initType: EJNativeBlockType.paragraph, initData:             ParagraphBlockContent(passedItem: contentItem))
                adapterDelegate?.add(block: block, index: insertRow)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case EJNativeBlockType.raw:
                let contentItem = RawHtmlBlockContentItem(passedHtml: "<div style=\\\"background: #000; color: #fff; font-size: 30px; padding: 50px;\\\">Any raw HTML code</div>")
                let block = EJAbstractBlock(initType: EJNativeBlockType.raw, initData:                         RawHtmlBlockContent(passedItem: contentItem))
                adapterDelegate?.add(block: block, index: insertRow)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
    }
    
    public func deleteBlock(){
        let indexPath = tableView.indexPathForSelectedRow
        if indexPath != nil{
            adapterDelegate?.delete(indexPath: indexPath!)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func deselectTableView(){
        if tableView.indexPathForSelectedRow != nil {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: .random())
        }
    }
    
    //MARK: - UITextViewDelegate
    public func textViewDidBeginEditing(_ textView: UITextView) {
        deselectTableView()
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        deselectTableView()
        
        let textViewFixed = textView as! UITextViewFixed
        let textViewString = textViewFixed.attributedText
        
        let block = dataSource?.tableData?.blocks[textViewFixed.section!]
        if block != nil{
            switch block!.type {
            case EJNativeBlockType.header:
                let contentItem = block!.data.getItem(atIndex: textViewFixed.row!) as! HeaderBlockContentItem
                if textViewString != nil{
                    contentItem.text = textViewString!.string
                    contentItem.cachedAttributedString = textViewString!
                }
                block!.data.setItem(atIndex: textViewFixed.row!, contentItem: contentItem)
            case EJNativeBlockType.image:
                let contentItem = block!.data.getItem(atIndex: textViewFixed.row!) as! ImageBlockContentItem
                if textViewString != nil{
                    contentItem.caption = textViewString!.string
                    contentItem.cachedAttributedCaption = textViewString!
                }
                block!.data.setItem(atIndex: textViewFixed.row!, contentItem: contentItem)
            case EJNativeBlockType.list:
                let contentItem = block!.data.getItem(atIndex: textViewFixed.row!) as! ListBlockContentItem
                if textViewString != nil{
                    contentItem.text = textViewString!.string
                    contentItem.cachedAttributedString = textViewString!
                }
                block!.data.setItem(atIndex: textViewFixed.row!, contentItem: contentItem)
            case EJNativeBlockType.linkTool:
                let contentItem = block!.data.getItem(atIndex: textViewFixed.row!) as! LinkBlockContentItem
                if textViewString != nil{
                    contentItem.description = textViewString!.string
                    contentItem.cachedDescriptionAttributedString = textViewString!
                }
                block!.data.setItem(atIndex: textViewFixed.row!, contentItem: contentItem)
            case EJNativeBlockType.delimiter:
                let _ = block!.data.getItem(atIndex: textViewFixed.row!) as! DelimiterBlockContentItem
                /*
                if textViewString != nil{
                    contentItem.text = textViewString!.string
                }
                block!.data.setItem(atIndex: textViewFixed.row!, contentItem: contentItem)
                */
            case EJNativeBlockType.paragraph:
                let contentItem = block!.data.getItem(atIndex: textViewFixed.row!) as! ParagraphBlockContentItem
                if textViewString != nil{
                    contentItem.text = textViewString!.string
                    contentItem.cachedAttributedString = textViewString!
                }
                block!.data.setItem(atIndex: textViewFixed.row!, contentItem: contentItem)
            case EJNativeBlockType.raw:
                let contentItem = block!.data.getItem(atIndex: textViewFixed.row!) as! RawHtmlBlockContentItem
                if textViewString != nil{
                    contentItem.html = textViewString!.string
                    contentItem.cachedAttributedString = textViewString!
                }
                block!.data.setItem(atIndex: textViewFixed.row!, contentItem: contentItem)
            default:
                break
            }
        }
        
        adapterDelegate?.set(blockList: dataSource?.tableData, closure: {
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        })
    }

}

///
extension EJTableViewAdapter: UITableViewDataSource {
    /**
     */
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.tableData?.blocks.count ?? .zero
    }
    
    /**
     */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.tableData?.blocks[section].data.numberOfItems ?? .zero
    }
    
    /**
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = dataSource?.tableData else {
            return UITableViewCell()
        }
        do {
            let block = data.blocks[indexPath.section]
            let style = kit.style.getStyle(forBlockType: block.type)
            
            do{
                let data = try EJKit.shared.encode(blocksList: data)
                print(String(decoding: data, as: UTF8.self))
            } catch {
                print("The error converting json to data : ")
                print(error)
            }

            return try renderer.render(block: block, indexPath: indexPath, style: style, delegate: self)
        }
        catch {
            return UITableViewCell()
        }
    }
}

///
extension EJTableViewAdapter: UITableViewDelegate {
    /**
     */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        guard let data = dataSource?.tableData,
              (.zero ..< data.blocks.count).contains(indexPath.section)
        else { return .zero }
        do {
            let block = data.blocks[indexPath.section]
            let style = kit.style.getStyle(forBlockType: block.type)
            
            return try renderer.size(forBlock: block,
                                     itemIndex: indexPath.item,
                                     style: style,
                                     superviewSize: tableView.frame.size).height + kit.style.defaultTableCellSpacing
        } catch {
            return .zero
        }
    }
}

///
public protocol EJTableViewAdapterDelegate {
    func set(blockList:EJBlocksList?, closure:() -> Void)
    func add(block: EJAbstractBlock, index: Int)
    func delete(indexPath: IndexPath)
}
