//
//  ViewController+UITableView.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 18/01/22.
//

import UIKit


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
                cell.setUpView()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch CustomSections.getSection(indexPath.row) {
        case .avatar:
            self.handleEventCamera()
        case .userName: break;
        case .graph:
            let detalle: UIViewController = GraphDetailViewController()
            let nav = UINavigationController(rootViewController: detalle)
            self.present(nav, animated: true, completion: nil)
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
