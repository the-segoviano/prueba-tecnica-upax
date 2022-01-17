//
//  Helpers.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 17/01/22.
//

import UIKit





extension UIViewController {
    /**
     * Funciones para ocultar el keyword cuando se toca en cualquier region de la pantalla
     *
     */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}




class GraphDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" GraphDetailViewController ")
    }
    
}

