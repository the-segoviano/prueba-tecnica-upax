//
//  GraphCell.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 17/01/22.
//

import UIKit

class GraphCell: BaseTableViewCell {
    
    func setUpView() {
        selectionStyle = .none
        textLabel?.text = "Gráfica"
        textLabel?.textAlignment = .center
    }
    
}
