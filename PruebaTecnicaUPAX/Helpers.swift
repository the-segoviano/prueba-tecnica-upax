//
//  Helpers.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 17/01/22.
//

import UIKit

extension UIColor {
    
    static let mercury = ParseColor.hexStringToUIColor(hex: "#f3f3f3")
    
}

class ParseColor {
    /**
     * Metodo para crear un color a partir de un hexadecimal en String
     *
     * @param hex String que se convertira a UIColor
     * @return UIColor
     */
    static func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}





class BaseButton {
    
    
    class func standardButton(withTitle title: String) -> UIButton {
        let button = BaseButton.getButton(withTitle: title, withColor: .systemBlue)
        return button
    }
    
    static func getButton(withTitle title: String, withColor color: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.Value.cornerRadius
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        return button
    }
    
}




class CustomTextField {
    
    class func getTextField(withPlaceholder placeholder: String = "") -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.Value.cornerRadius
        field.addBorder(borderColor: UIColor.lightGray, widthBorder: 1.0)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.placeholder = placeholder
        if #available(iOS 13.0, *) {
            field.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
        return field
    }
    
}





struct Constants {
    
    struct Strings {
        static let titleApp = "UPAX"
        static let ok = "ok"
        static let cancel = "Cancelar"
        static let send = "Enviar"
        
    }
    
    
    struct Value {
        static let htTextField: CGFloat = 48.0
        static let htButton: CGFloat = 40.0
        static let leadingMar: CGFloat = 16.0  // Or Left Margin
        static let trailingMar: CGFloat = -16.0 // Or Right Margin
        static let padding: CGFloat = 8.0
        static let cornerRadius: CGFloat = 15.0
        static let sizeProductImage: CGFloat = 30.0
        static let sizeIconHeart: CGFloat = 24.0
    }
    
    
    struct ImageName {
        static let add: String = "add"
    }
    
    struct IdForCell {
        static let genericCell: String = "GenericCell"
        static let customHeaderCell = "customHeaderCell"
        static let customFooterCell: String = "customFooterCell"
        static let productCell: String = "ProductCell"
        static let userCollectionCell: String = "UserCollectionCell"
        
        
    }
    
}




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


