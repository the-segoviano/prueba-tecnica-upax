//
//  QuestionsResponse.swift
//  PruebaTecnicaUPAX
//
//  Created by Luis Segoviano on 18/01/22.
//

import Foundation

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
