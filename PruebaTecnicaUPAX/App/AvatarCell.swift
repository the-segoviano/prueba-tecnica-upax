//
//  AvatarCell.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 17/01/22.
//

import UIKit

class AvatarCell: BaseTableViewCell {
    
    let localStorage = UserDefaults.standard
    
    let sizeAvatarImageView: CGFloat = 80.0
    
    let avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFit
        avatar.clipsToBounds = true
        avatar.image = UIImage(named: "avatar")
        return avatar
    }()
    
    
    let containerAvatar: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        container.layer.cornerRadius = 80/2
        container.layer.masksToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: -1, height: 1)
        container.layer.shadowRadius = 5
        return container
    }()
    
    func setUpView(with url: String = "") {
        // selectionStyle = .none
        addSubview(containerAvatar)
        containerAvatar.isUserInteractionEnabled = true
        containerAvatar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerAvatar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerAvatar.widthAnchor.constraint(equalToConstant: sizeAvatarImageView).isActive = true
        containerAvatar.heightAnchor.constraint(equalToConstant: sizeAvatarImageView).isActive = true
        containerAvatar.addSubview(avatar)
        containerAvatar.addBorder(borderColor: .lightGray, widthBorder: 1)
        
        avatar.centerXAnchor.constraint(equalTo: containerAvatar.centerXAnchor).isActive = true
        avatar.centerYAnchor.constraint(equalTo: containerAvatar.centerYAnchor).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: sizeAvatarImageView).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: sizeAvatarImageView).isActive = true
        
    }
    
}
