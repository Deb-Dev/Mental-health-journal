//
//  APIServiceError.swift
//  MentalHealthJournalApp
//
//  Created by Debasish Chowdhury on 2024-12-02.
//
import Foundation

enum APIServiceError: Error {
    case invalidURL
    case requestFailed(Error)
    case serverError(Int) // HTTP status code
    case noData
    case decodingError(Error)
    case unknown
}

extension APIServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed(let error):
            return "Request failed with error: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)."
        case .noData:
            return "No data received from the server."
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
