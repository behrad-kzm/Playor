//
//  UIColor+Combine.swift
//
//  Created by Behrad Kazemi on 4/15/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
extension UIColor{
    
    private func lerp(from a: CGFloat, to b: CGFloat, alpha: CGFloat) -> CGFloat {
        return (1 - alpha) * a + alpha * b
    }
    
    private func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return (r, g, b, a)
    }
    
    func combine(with color: UIColor, amount: CGFloat) -> UIColor {
        let fromComponents = components()
        
        let toComponents = color.components()
        
        let redAmount = lerp(from: fromComponents.red,
                             to: toComponents.red,
                             alpha: amount)
        let greenAmount = lerp(from: fromComponents.green,
                               to: toComponents.green,
                               alpha: amount)
        let blueAmount = lerp(from: fromComponents.blue,
                              to: toComponents.blue,
                              alpha: amount)
        
        
        let color = UIColor(red: redAmount,
                            green: greenAmount,
                            blue: blueAmount,
                            alpha: 1)
        
        return color
    }
}
