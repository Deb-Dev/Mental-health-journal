//
//  APIResponseModels.swift
//  MentalHealthJournalApp
//
//  Created by Debasish Chowdhury on 2024-12-02.
//
import Foundation

struct GeneratePromptsResponse: Codable {
    let content: String
    let suggestedResponses: [String]?
}
