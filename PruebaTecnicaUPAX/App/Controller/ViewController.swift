//
//  ViewController.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 16/01/22.
//

import UIKit
import FirebaseStorage

class ViewController: UIViewController {

    // MARK: - Scope
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.IdForCell.genericCell)
        tableView.register(UsernameCell.self, forCellReuseIdentifier: Constants.IdForCell.usernameCell)
        tableView.register(AvatarCell.self, forCellReuseIdentifier: Constants.IdForCell.avatarCell)
        tableView.register(GraphCell.self, forCellReuseIdentifier: Constants.IdForCell.graphCell)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    lazy var sendButton: UIButton = {
        let button = BaseButton.standardButton(withTitle: Constants.Strings.send)
        button.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        return button
    }()
    
    // MARK: Firestore
    let storage = Storage.storage().reference()
    
    // MARK: - Lyfe-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mercury
        UserDefaults.standard.set(false, forKey: "was-avatar-updated")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = self.tableView.frame.height
        let contentHeight   = self.tableView.contentSize.height
        let centeringInset  = (tableViewHeight - contentHeight) / 2.0
        let topInset        = max(centeringInset, 0.0)
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    
    // MARK: - Custom Setup
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.heightAnchor.constraint(equalToConstant: self.view.frame.width/2).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        view.addSubview(sendButton)
        sendButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: Constants.Value.htButton).isActive = true
        sendButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }
    

    
    
    @objc private func sendRequest(){
        var username: String = ""
        if let usernametextField = view.viewWithTag(Constants.Tags.userNameInput) as? UITextField {
            username = usernametextField.text!
            if username.isEmpty == true {
                Alert.showIncompleteFormAlert(on: self)
                return
            }
            if username.isValidInput() == false {
                Alert.showWrongFormatUsernameAlert(on: self)
                return
            }
        }
        
        if !UserDefaults.standard.bool(forKey: "was-avatar-updated") {
            Alert.showPickupANewImageAlert(on: self)
            return
        }
        
        UserDefaults.standard.set(username, forKey: "username")
        
        guard let avatarData = UserDefaults.standard.data(forKey: "avatar") else {
            return
        }
        
        // MARK: Firestore
        let path: String = "avatar-images/\(username).png"
        storage.child(path).putData(avatarData, metadata: nil) { [weak self] _, error in
            guard error == nil else {
                return
            }
            self?.storage.child(path).downloadURL { [weak self] (url, error) in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print(" url-firestore ", urlString, "\n")
                UserDefaults.standard.set(urlString, forKey: "url-firestore")
                DispatchQueue.main.async {
                    Alert.showSuccessAlert(on: self!)
                    if let usernametextField = self?.view.viewWithTag(Constants.Tags.userNameInput) as? UITextField
                    {
                        usernametextField.text = ""
                    }
                }
            }
        }
    }
    
    
    
}






