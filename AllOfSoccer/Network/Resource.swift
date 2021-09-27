//
//  Resource.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/02.
//

import Foundation

struct Network {

}

extension Network {
    struct Resource<T> {
        var urlRequest: URLRequest
        let parse: (Data) -> T?
    }
}

extension Network.Resource where T: Codable {
    init(url: URL) {
        self.urlRequest = URLRequest(url: url)
        self.parse = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }

    init(url: String, parameters: [String: Any]) {
        var component = URLComponents(string: url)
        var componentParameters = [URLQueryItem]()
        for (name,value) in parameters {
            if name.isEmpty { continue }
            componentParameters.append(URLQueryItem(name: name, value: "\(value)"))
        }

        if !componentParameters.isEmpty {
            component?.queryItems = componentParameters
        }
        if let componentURL = component?.url {
            self.urlRequest = URLRequest(url: componentURL)
        } else {
            self.urlRequest = URLRequest(url: URL(string: url)!)
        }

        self.parse = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }

    init<HttpBody: Encodable>(postmodel: HttpBody,url: URL, method: HttpMethod) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = method.rawValue

        switch method {
        case .post, .delete, .patch, .put:
            self.urlRequest.httpBody = try? JSONEncoder().encode(postmodel)
            self.urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        default: break
        }
        self.parse = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
}
