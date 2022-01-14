//
//  APIClient.swift
//  Diablo3ItemsBrowser
//
//  Created by Коптев Олег Станиславович on 24.12.2021.
//

import Foundation

class APIClient {
    private let baseUrl: URL?
    private let decoder: JSONDecoder
    
    static let shared = APIClient(baseUrl: "http://localhost:8080")
    
    required init(baseUrl: String) {
        self.baseUrl = URL(string: baseUrl)
        self.decoder = JSONDecoder()
    }
    
    func get(from endpoint: String, callback: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: endpoint, relativeTo: baseUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            callback(Result {
                guard error == nil else { throw error! }
                
                guard let response = response,
                      let httpResponse = response as? HTTPURLResponse else {
                          preconditionFailure("cannot cast response to HTTPURLReponse")
                      }
                
                guard 200..<300 ~= httpResponse.statusCode else {
//                    throw APIRequestError
//                        .badStatusCode(httpResponse.statusCode)
                    preconditionFailure("bad code \(httpResponse.statusCode)")
                    
                }
                
                guard let data = data else {
//                    throw APIRequestError.noData
                    preconditionFailure("no data")
                }
                
                return data
            })
        }.resume()
    }
}
