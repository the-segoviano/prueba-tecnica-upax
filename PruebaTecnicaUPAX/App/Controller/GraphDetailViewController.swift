//
//  GraphDetailViewController.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 18/01/22.
//

import UIKit

class GraphDetailViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.IdForCell.genericCell)
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: Constants.IdForCell.chartTableViewCell)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: Constants.Strings.close,
                                                                  style: .plain, target: self, action: #selector(self.closeDetail))
        setupTableView()
    }
    
    @objc private func closeDetail(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView(){
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        tableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getGraphs()
        
    }
    
    
    var questions: [Question] = [Question]()
    
    var colors: [String] = [String]()
    
    private func getGraphs(){
        let session: URLSession = URLSession.shared
        let url: URL = URL(string: "https://us-central1-bibliotecadecontenido.cloudfunctions.net/helloWorld")!
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                //print("Client error!")
                return
            }
            guard
                let httpURLResponse = response as? HTTPURLResponse, (200...299).contains(httpURLResponse.statusCode),
                let mimeType = response?.mimeType, mimeType == "application/json",
                let data = data, error == nil
            else { return }
            
            do {
                
                let jsonDecoder = JSONDecoder()
                
                let result = try jsonDecoder.decode(QuestionsResponse.self, from: data)
                if result.questions.count > 0 {
                    self.colors.append(contentsOf: result.colors)
                    self.questions.append(contentsOf: result.questions)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            } catch let error {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
}


