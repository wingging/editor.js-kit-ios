//
//  EJTableViewAdapter.swift
//  EditorJSKit
//
//  Created by Chang Wing Le on 07/06/2022.
//

import Foundation

///
public final class EJTableViewAdapter: NSObject {
    
    ///
    unowned let tableView: UITableView
    private let kit: EJKit
    public var dataSource: EJTableDataSource?
    
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
            return try renderer.render(block: block, indexPath: indexPath, style: style)
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
            
            //return 80
            return try renderer.size(forBlock: block,
                                     itemIndex: indexPath.item,
                                     style: style,
                                     superviewSize: tableView.frame.size).height
        } catch {
            return .zero
        }
    }
    /*
    /**
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let data = dataSource?.data,
              (.zero ..< data.blocks.count).contains(section)
        else { return .zero }
        return renderer.spacing(forBlock: data.blocks[section])
    }
    
    /**
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let data = dataSource?.data,
              (.zero ..< data.blocks.count).contains(section)
        else { return .zero }
        return renderer.insets(forBlock: data.blocks[section])
    }
    */
}
