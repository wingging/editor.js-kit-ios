//
//  HeaderNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

public class HeaderNativeContentView: UIView, ConfigurableBlockViewWithDelegate {
    
    public let textView = UITextViewFixed()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(textView)
        
        textView.backgroundColor = .clear
        textView.isEditable = true
        textView.alwaysBounceVertical = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.addAccessoryAttributedView()
        NSLayoutConstraint.activate([
            textView.leftAnchor.constraint(equalTo: leftAnchor),
            textView.rightAnchor.constraint(equalTo: rightAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - ConfigurableBlockView conformance
    public func configure(withItem item: HeaderBlockContentItem, style: EJBlockStyle?, indexPath: IndexPath?, delegate: UITextViewDelegate?) {
        guard let style = style as? EJHeaderBlockStyle else {
            textView.text = item.text
            return
        }
        let attributedString = item.text.convertHTML(font: style.font(forHeaderLevel: item.level), forceFontFace: true)
        if item.cachedAttributedString == nil {
            item.cachedAttributedString = attributedString
        }
        textView.attributedText = attributedString
        
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        textView.setTextViewMark(indexPath: indexPath)
        textView.textAlignment = style.alignment
        textView.delegate = delegate
    }
    
    public static func estimatedSize(for item: HeaderBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        guard let style = style as? EJHeaderBlockStyle else { return .zero }
        let attributedString = item.cachedAttributedString ?? item.text.convertHTML(font: style.font(forHeaderLevel: item.level), forceFontFace: true)
        if item.cachedAttributedString == nil {
            item.cachedAttributedString = attributedString
        }
        
        let newBoundingWidth = boundingWidth - (style.insets.left + style.insets.right)
        let height = attributedString?.height(withConstrainedWidth: newBoundingWidth) ?? .zero
        
        return CGSize(width: boundingWidth, height: height)
    }
}
