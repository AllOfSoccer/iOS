//
//  SearchPlaceAPI.swift
//  AllOfSoccer
//
//  Created by 조중현 on 2022/03/04.
//

import Foundation

internal struct SearchPlaceAPI {

    enum RequestError: Error {
        case parsingError
        case errorExist
        case dataIsNil
    }

    static func request(searchText: String, completion: @escaping (Result<[Item], RequestError>) -> Void) {
        let urlString = "https://openapi.naver.com/v1/search/local.json?query=\(searchText)&display=10".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: urlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.addValue("IgvVcqCnm3_RhM7INYwu", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("0FTVxW906A", forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.errorExist))
                return
            }

            guard let data = data else {
                completion(.failure(.dataIsNil))
                return
            }

            do {
                let result = try JSONDecoder().decode(SearchPlaceAPI.ResponseValue.self, from: data)
                completion(.success(result.items))
            } catch {
                completion(.failure(.parsingError))
            }
        }.resume()
    }

    struct ResponseValue: Codable {
        let lastBuildDate: String
        let total, start, display: Int
        let items: [Item]

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.lastBuildDate = try container.decode(String.self, forKey: .lastBuildDate)
            self.total = try container.decode(Int.self, forKey: .total)
            self.start = try container.decode(Int.self, forKey: .start)
            self.display = try container.decode(Int.self, forKey: .display)
            self.items = try container.decode([Item].self, forKey: .items)
        }
    }

    // MARK: - Item
    struct Item: Codable {
        let title: String
        let link: String
        let category, telephone, address: String
        let roadAddress, mapx, mapy: String
        let itemDescription: String?

        enum CodingKeys: String, CodingKey {
            case title, link, category
            case itemDescription
            case telephone, address, roadAddress, mapx, mapy
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.title = try container.decode(String.self, forKey: .title)
            self.link = try container.decode(String.self, forKey: .link)
            self.category = try container.decode(String.self, forKey: .category)
            self.itemDescription = try? container.decode(String.self, forKey: .itemDescription)
            self.address = try container.decode(String.self, forKey: .address)
            self.roadAddress = try container.decode(String.self, forKey: .roadAddress)
            self.mapx = try container.decode(String.self, forKey: .mapx)
            self.mapy = try container.decode(String.self, forKey: .mapy)

            self.telephone = try container.decode(String.self, forKey: .telephone)
        }
    }

}
