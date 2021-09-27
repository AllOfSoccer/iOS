//
//  URLSession+Extension.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/02.
//

import Foundation

extension URLSession {

    func load<T>(_ resorce: Network.Resource<T>, completion: @escaping (Result<T?, APIError>) -> Void) {
        dataTask(with: resorce.urlRequest) { data, response, _ in
            if let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) {
                completion(.success(data.flatMap(resorce.parse)))
            } else {
                completion(.failure(.noData))
            }
        }.resume()
    }
}
