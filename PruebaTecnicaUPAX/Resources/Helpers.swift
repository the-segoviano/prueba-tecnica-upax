//
//  Helpers.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 17/01/22.
//

import UIKit



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


extension UITableViewCell {
    
    func releaseView() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
}



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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ChartTableViewCell.self, forCellReuseIdentifier: "ChartTableViewCell")
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

extension GraphDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath)
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
        return self.view.frame.width
    }
    
}


// MARK: - QuestionsResponse
struct QuestionsResponse: Codable {
    let colors: [String]
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let total: Int
    let text: String
    let chartData: [ChartDatum]
}

// MARK: - ChartDatum
struct ChartDatum: Codable {
    let text: String
    let percetnage: Int
}




class ChartTableViewCell: BaseTableViewCell {
    
    func setupView(with question: Question, with colors: [String]) {
        
        let titleLabelChart: UILabel = UILabel()
        titleLabelChart.translatesAutoresizingMaskIntoConstraints = false
        titleLabelChart.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabelChart.text = question.text
        titleLabelChart.textAlignment = .center
        titleLabelChart.numberOfLines = 0
        
        addSubview(titleLabelChart)
        titleLabelChart.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        titleLabelChart.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        titleLabelChart.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.generateGraph(with: question, with: colors)
        
    }
    
    
    private func generateGraph(with question: Question, with colors: [String]){
        
        
        let pieChartView = PieChartView()
        let padding: CGFloat = 20
        let height: CGFloat = (frame.height - padding * 3) / 2
        pieChartView.frame = CGRect(x: 0, y: padding + 45, width: frame.size.width, height: height)
        var labelledSegments: [LabelledSegment] = [LabelledSegment](), i: Int = 0
        question.chartData.forEach {
            labelledSegments.append(
                LabelledSegment(color: UIColor(hexString: colors[i]),
                                name: $0.text,
                                value: CGFloat($0.percetnage)
                )
            )
            i += 1
        }
        pieChartView.segments = labelledSegments
        pieChartView.segmentLabelFont = .systemFont(ofSize: 10)
        addSubview(pieChartView)
        
    }
    

}



