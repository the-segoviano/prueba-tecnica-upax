//
//  ViewController.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 16/01/22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Scope
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.IdForCell.genericCell)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var sendButton: UIButton = {
        let button = BaseButton.standardButton(withTitle: Constants.Strings.send)
        // button.addTarget(self, action: #selector(updateData), for: .touchUpInside)
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
        tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        view.addSubview(sendButton)
        sendButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: Constants.Value.htButton).isActive = true
        sendButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }
    

}


// MARK: - Delegate & Dataspurce UITableView

enum CustomSections: CaseIterable
{
    case userName, avatar, graph
    
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
        case .userName:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.genericCell, for: indexPath)
            cell.textLabel?.text = "Username"
            return cell
            
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.genericCell, for: indexPath)
            cell.textLabel?.text = "Avatar"
            return cell
            
        case .graph:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.genericCell, for: indexPath)
            cell.textLabel?.text = "Gráfica"
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        let cornerRadius = 15.0 //Constants.Value.cornerRadius
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
