//
//  ServiceProvider.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/02.
//

import Foundation

class ServiceProvider {

    static let shared = ServiceProvider()

    private let defaultSession = URLSession(configuration: .default)

    private init() { }

    func  getLoginData(parameters: [String: Any], completion: @escaping (Result<[LoginModel]?, APIError>) -> Void) {
        let url = NetworkConfig.LoginURL
        let resource = Network.Resource<[LoginModel]>(url: url, parameters: parameters)
        defaultSession.load(resource) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
