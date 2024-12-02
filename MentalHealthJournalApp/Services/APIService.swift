//
//  APIService.swift
//  MentalHealthJournalApp
//
//  Created by Debasish Chowdhury on 2024-11-28.
//

import Foundation

class APIService {
    static let shared = APIService()
    let baseURL = "https://game-pal-fj5v7g.uc.r.appspot.com"
    func generatePrompts(moods: [String], previousConversation: [Message], completion: @escaping (Message?) -> Void) {
            guard let url = URL(string: "\(baseURL)/generate_prompts") else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let conversation = previousConversation.map { ["role": $0.role.rawValue, "content": $0.content] }
            
            let body: [String: Any] = [
                "mood": moods,
                "previous_conversation": conversation
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let content = json["content"] as? String {
                    let suggestedResponses = json["suggested_responses"] as? [String]
                    let assistantMessage = Message(role: .assistant, content: content, suggestedResponses: suggestedResponses)
                    completion(assistantMessage)
                } else {
                    completion(nil)
                }
            }.resume()
        }

}
