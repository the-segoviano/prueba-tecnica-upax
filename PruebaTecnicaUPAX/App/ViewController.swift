//
//  ViewController.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 16/01/22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Scope
    
    let notifier = NotificationCenter.default
    
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
        //tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    lazy var sendButton: UIButton = {
        let button = BaseButton.standardButton(withTitle: Constants.Strings.send)
        button.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lyfe-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mercury
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTableView()
        /**
        let tapDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        tapDismissKeyboard.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapDismissKeyboard)
        */
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
        tableView.addBorder()
    }
    

    @objc private func sendRequest(){
        print(" sendRequest ")
    }
    
    
    
}


// MARK: - Delegate & Dataspurce UITableView

enum CustomSections: CaseIterable
{
    case avatar, userName, graph
    
    static func numberOfSections() -> Int
    {
        return self.allCases.count
    }
    
    static func getSection(_ section: Int) -> CustomSections
    {
        return self.allCases[section]
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomSections.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CustomSections.getSection(indexPath.row) {
        
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.avatarCell, for: indexPath)
            if let cell = cell as? AvatarCell {
                cell.setUpView()
                return cell
            }
        case .userName:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.usernameCell, for: indexPath)
            if let cell = cell as? UsernameCell {
                cell.setUpView()
                return cell
            }
        case .graph:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.graphCell, for: indexPath)
            if let cell = cell as? GraphCell {
                cell.textLabel?.text = "Gráfica"
                cell.textLabel?.textAlignment = .center
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch CustomSections.getSection(indexPath.row) {
        case .avatar:
            print(" row avatar ")
        case .userName:
            print(" row userName ")
        case .graph:
            let detalle: UIViewController = GraphDetailViewController()
            //self.present(detalle, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch CustomSections.getSection(indexPath.row) {
        case .avatar:
            return 90.0
        case .userName:
            return 45.0
        case .graph:
            return 45.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        let cornerRadius = Constants.Value.cornerRadius
        var corners: UIRectCorner = []

        if indexPath.row == 0
        {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
    }
    
    
}
