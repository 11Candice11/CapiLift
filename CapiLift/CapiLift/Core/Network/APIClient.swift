//
//  APIClient.swift
//  CapiLift
//
//  Created by Candice Yeatman on 2026/05/27.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case unauthorized
    case serverError(Int)
    case decodingError(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:           return "Invalid URL"
        case .unauthorized:         return "Session expired. Please sign in again."
        case .serverError(let c):   return "Server error (\(c))"
        case .decodingError(let e): return "Data error: \(e.localizedDescription)"
        case .unknown(let e):       return e.localizedDescription
        }
    }
}

actor APIClient {
    static let shared = APIClient()

    private let baseURL = "https://api.capilift.co.za"
    private let session = URLSession.shared
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy  = .convertFromSnakeCase
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        body: (any Encodable)? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = KeychainService.shared.getToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy  = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            req.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await session.data(for: req)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.unknown(URLError(.badServerResponse))
        }

        switch http.statusCode {
        case 200...299: break
        case 401: throw APIError.unauthorized
        default:  throw APIError.serverError(http.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
