//
//  ConfigurableBlockView.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 27.05.2022.
//

import CoreGraphics

///
public protocol ConfigurableBlockView {
    associatedtype BlockContentItem
    func configure(withItem item: BlockContentItem, style: EJBlockStyle?)
    static func estimatedSize(for item: BlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize
}

///
public protocol ConfigurableBlockViewWithDelegate {
    associatedtype BlockContentItem
    func configure(withItem item: BlockContentItem, style: EJBlockStyle?, indexPath: IndexPath?, delegate: UITextViewDelegate?)
    static func estimatedSize(for item: BlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize
}
