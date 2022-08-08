//
//  UITextView+Fixed.swift
//  EditorJSKit
//
//  Created by Vadim Popov on 09/10/2019.
//

import UIKit

///
public class UITextViewFixed: UITextView {
    
    var row: Int?
    var section: Int?
    /**
     */
    override public func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    /**
     */
    public func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
    
    public func setTextViewMark(indexPath: IndexPath?){
        row = indexPath?.row
        section = indexPath?.section
    }
}
