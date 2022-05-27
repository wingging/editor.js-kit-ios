//
//  ListItemBlockView.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 18/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import UIKit

///
public class ListItemBlockView: BaseBlockView<ListItemNativeContentView> {
    override var blockType: EJAbstractBlockType { EJNativeBlockType.list }
}
