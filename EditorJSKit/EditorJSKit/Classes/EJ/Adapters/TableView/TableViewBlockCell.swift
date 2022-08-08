//
//  TableViewBlockCell.swift
//  EditorJSKit
//
//  Created by Chang Wing Le on 07/06/2022.
//

import Foundation

public class TableViewBlockCell<EmbeddedView: UIView>: UITableViewCell, ConfigurableBlockViewWithDelegate where EmbeddedView: EJBlockViewWithDelegate {
    
    public typealias BlockContentItem = EmbeddedView.BlockContentItem
    
    private let embeddedView = EmbeddedView()
    
    private var section : Int?
    private var row : Int?

    override public var reuseIdentifier: String? {
        EmbeddedView.reuseId
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(embeddedView)
        embeddedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            embeddedView.leftAnchor.constraint(equalTo: leftAnchor),
            embeddedView.rightAnchor.constraint(equalTo: rightAnchor),
            embeddedView.topAnchor.constraint(equalTo: topAnchor),
            embeddedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func setTextViewTag(indexPath: IndexPath){
        row = indexPath.row
        section = indexPath.section
    }
    
    public func configure(withItem item: EmbeddedView.BlockContentItem, style: EJBlockStyle?, indexPath: IndexPath?, delegate: UITextViewDelegate?) {
        if row != nil && section != nil{
            embeddedView.configure(withItem: item, style: style, indexPath: IndexPath(row: row!, section: section!), delegate: delegate)
        }else{
            embeddedView.configure(withItem: item, style: style, indexPath: nil, delegate: delegate)
        }
    }

    /**
     */
    public static func estimatedSize(for item: BlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        EmbeddedView.estimatedSize(for: item, style: style, boundingWidth: boundingWidth)
    }
}
