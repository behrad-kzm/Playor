//
//  UIView+RelatedSize.swift
//
//  Created by Behrad Kazemi on 4/13/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
extension UIView {
    func calculateRelatedSize(multiplier: CGFloat) -> CGSize {
        return CGSize(width: bounds.size.width * multiplier, height: bounds.size.height * multiplier)
    }
    func calculateRelatedSize(decrease: CGFloat) -> CGSize {
        return CGSize(width: bounds.size.width - decrease, height: bounds.size.height - decrease)
    }
    func calculateRelatedSize(increase: CGFloat) -> CGSize {
        return CGSize(width: bounds.size.width + increase, height: bounds.size.height + increase)
    }
}
