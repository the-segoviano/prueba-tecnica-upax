//
//  Constants.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 17/01/22.
//

import UIKit

struct Constants {
    
    struct Strings {
        static let titleApp = "UPAX"
        static let ok = "ok"
        static let cancel = "Cancelar"
        static let send = "Enviar"
        static let username = "Username"
        static let close = "Cerrar"
        
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
        static let usernameCell: String = "UsernameCell"
        static let avatarCell: String = "AvatarCell"
        static let graphCell: String = "GraphCell"
    }
    
}
