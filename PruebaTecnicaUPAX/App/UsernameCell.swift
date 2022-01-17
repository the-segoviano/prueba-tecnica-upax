//
//  UsernameCell.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 17/01/22.
//

import UIKit

class UsernameCell: BaseTableViewCell {
    
    lazy var usernameTextField: UITextField = {
        let field = CustomTextField.getTextField(withPlaceholder: Constants.Strings.username)
        // field.delegate = self
        field.keyboardType = .alphabet
        return field
    }()
    
    func setUpView() {
        selectionStyle = .none
        
        addSubview(usernameTextField)
        usernameTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        usernameTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
}


