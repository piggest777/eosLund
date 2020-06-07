//
//  PaddingLabel.swift
//  eosLund
//
//  Created by Denis Rakitin on 2020-01-10.
//  Copyright © 2020 Denis Rakitin. All rights reserved.
//

import UIKit

class UILabelPadding: UILabel {
    let padding = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
