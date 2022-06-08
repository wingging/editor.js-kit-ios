//
//  EJCustomBlockTableAdaptable.swift
//  EditorJSKit
//
//  Created by Chang Wing Le on 07/06/2022.
//

import Foundation

///
protocol EJCustomBlockTableAdaptable: EJAbstractCustomBlock, ReusableBlockView {
    func prepareCell(forTableView tableView: UITableView,
                     contentItem: EJAbstractBlockContentItem,
                     indexPath: IndexPath,
                     style: EJBlockStyle?) -> UITableViewCell?
    func estimatedSize(forBlock block: EJAbstractBlock,
                       itemIndex: Int,
                       style: EJBlockStyle?,
                       superviewSize: CGSize) -> CGSize?
}
