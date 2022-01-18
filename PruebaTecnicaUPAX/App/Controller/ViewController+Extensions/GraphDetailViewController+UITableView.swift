//
//  GraphDetailViewController+UITableView.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 18/01/22.
//

import UIKit

extension GraphDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.IdForCell.chartTableViewCell, for: indexPath)
        if let cell = cell as? ChartTableViewCell {
            cell.releaseView()
            cell.setupView(with: questions[indexPath.row], with: colors)
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height
    }
    
}
