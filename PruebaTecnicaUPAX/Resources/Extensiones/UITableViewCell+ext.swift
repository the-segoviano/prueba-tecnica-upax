//
//  UITableViewCell+ext.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 18/01/22.
//

import UIKit

extension UITableViewCell {
    
    func releaseView() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
}
