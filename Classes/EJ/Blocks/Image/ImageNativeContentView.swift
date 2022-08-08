//
//  ImageNativeContentView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 17/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public class ImageNativeContentView: UIView, ConfigurableBlockViewWithDelegate {
    
    // MARK: - UI Properties
    public let imageView = UIImageView()
    public let textView = UITextViewFixed()
    
    private var imageWidth: NSLayoutConstraint?
    private var imageHeight: NSLayoutConstraint?
    
    ///
    private var withBackground: Bool = false
    
    ///
    private var appliedCaptionInsets: UIEdgeInsets?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(textView)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageWidth = imageView.widthAnchor.constraint(equalToConstant: 0)
        let imageHeight = imageView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageWidth,
            imageHeight
        ])
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        
        textView.backgroundColor = .clear
        textView.isEditable = true
        textView.alwaysBounceVertical = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setImage(from data: Data, item: ImageBlockContentItem) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.imageView.image = image
                self.textView.isHidden = false
                self.imageView.isHidden = false
                if let imageSize = ImageNativeContentView.imageSize(for: item, containerMaxWidth: self.bounds.width) {
                    self.imageWidth?.constant = imageSize.width
                    self.imageHeight?.constant = imageSize.height
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    private static func imageSize(for item: ImageBlockContentItem, containerMaxWidth: CGFloat) -> CGSize? {
        if let data = item.file.imageData, let image = UIImage(data: data) {
            let imageRatio = image.size.width / image.size.height
            if imageRatio >= 1 {
                // album or square
                let imageHeight: CGFloat = image.size.height / UIScreen.main.scale
                let height: CGFloat = min(imageHeight, containerMaxWidth / imageRatio)
                return CGSize(width: height * imageRatio, height: height)
            }
            else {
                // portrait
                var imageWidth = image.size.width / UIScreen.main.scale
                imageWidth = min(imageWidth, containerMaxWidth)
                let height = imageWidth / imageRatio
                return CGSize(width: height * imageRatio, height: height)
            }
        }
        return nil
    }
    
    // MARK: - ConfigurableBlockView conformance
    public func configure(withItem item: ImageBlockContentItem, style: EJBlockStyle?, indexPath: IndexPath?, delegate: UITextViewDelegate?) {
        // 1. Apply basic style
        layer.cornerRadius = style?.cornerRadius ?? .zero
        imageView.backgroundColor = .clear
        backgroundColor = .clear
        
        guard let style = style as? EJImageBlockStyle else { return }
        
        // 2. Apply content
        if let data = item.file.imageData {
            setImage(from: data, item: item)
            let attributedCaption = item.cachedAttributedCaption ?? item.caption.convertHTML(font: style.font)
            if item.cachedAttributedCaption == nil {
                item.cachedAttributedCaption = attributedCaption
            }
            textView.attributedText = attributedCaption
            withBackground = item.withBackground
            textView.isHidden = false
            imageView.isHidden = false
        }
        else {
            textView.isHidden = true
            imageView.isHidden = true
        }
        
        // 3. Apply specific style
        let captionInsets = style.captionInsets
        if appliedCaptionInsets != captionInsets {
            let constraints = [
                textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(captionInsets.bottom)),
                textView.leftAnchor.constraint(equalTo: leftAnchor, constant: captionInsets.left),
                textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -(captionInsets.right))
            ]
            if appliedCaptionInsets != nil {
                NSLayoutConstraint.deactivate(constraints)
            }
            NSLayoutConstraint.activate(constraints)
            appliedCaptionInsets = captionInsets
        }
        
        textView.setTextViewMark(indexPath: indexPath)
        textView.textColor = style.captionColor
        textView.textAlignment = style.textAlignment
        textView.delegate = delegate
        imageView.layer.cornerRadius = style.imageViewCornerRadius
        
        if withBackground {
            imageView.backgroundColor = style.imageViewBackgroundColor
            backgroundColor = style.backgroundColor
        }
    }
    
    public static func estimatedSize(for item: ImageBlockContentItem, style: EJBlockStyle?, boundingWidth: CGFloat) -> CGSize {
        let containerMaxWidth: CGFloat = boundingWidth - (style?.insets.left ?? .zero) - (style?.insets.right ?? .zero)
        var height: CGFloat = .zero
        if let imageSize = self.imageSize(for: item, containerMaxWidth: containerMaxWidth) {
            height += imageSize.height
        }
        
        guard let style = style as? EJImageBlockStyle else { return .zero }
        
        let attributedCaption = item.cachedAttributedCaption ?? item.caption.convertHTML(font: style.font)
        if item.cachedAttributedCaption == nil {
            item.cachedAttributedCaption = attributedCaption
        }
        
        if let attributedCaption = attributedCaption {
            height += attributedCaption.height(withConstrainedWidth: containerMaxWidth)
            height += style.captionInsets.top + style.captionInsets.bottom
        }
        
        //let cellspacing: CGFloat = 50
        
        //return CGSize(width: boundingWidth, height: height + cellspacing)
        return CGSize(width: boundingWidth, height: height)
    }
}
