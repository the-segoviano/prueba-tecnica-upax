//
//  UIView+ext.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 17/01/22.
//

import UIKit

extension UIView {
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /**
     * Add border to View
     *
     */
    func addBorder(borderColor: UIColor = UIColor.red, widthBorder: CGFloat = 1.0) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = widthBorder
    }
    
    func removeViews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
    
}
