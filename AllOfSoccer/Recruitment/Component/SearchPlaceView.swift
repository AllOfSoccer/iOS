//
//  SearchPlaceView.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/17.
//

import UIKit
import SearchTextField
import SwiftUI

protocol SearchPlaceViewDelegate: AnyObject {
    func cancelButtonDidSelected(_ view: SearchPlaceView)
    func okButtonDidSelected(_ view: SearchPlaceView)
}

class SearchPlaceView: UIView {

    weak var delegate: SearchPlaceViewDelegate?

    private var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    lazy private var textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1)
        view.layer.cornerRadius = 6
        return view
    }()

    lazy private var inputPlaceTextField: SearchTextField = {
        let textField = SearchTextField()
        textField.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1)
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        var placeholder = NSAttributedString(string: "장소를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 157/255, green: 159/255, blue: 160/255, alpha: 1)])
        textField.attributedPlaceholder = placeholder
        textField.layer.cornerRadius = 6
        textField.theme.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textField.theme.subtitleFontColor = UIColor(red: 157/255, green: 159/255, blue: 160/255, alpha: 1)
        textField.maxNumberOfResults = 10
        textField.maxResultsListHeight = 244
        textField.inlineMode = false
        textField.tableYOffset = 20
        textField.startVisibleWithoutInteraction = true
        textField.forceNoFiltering = true

        return textField
    }()

    lazy private var textFieldButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = CGFloat(5)
        let buttonImage = UIImage(named: "search")
        button.setImage(buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(buttonImage?.withRenderingMode(.alwaysTemplate), for: .disabled)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)

        return button
    }()

    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "경기 장소"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        return label
    }()

    lazy private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1)
        button.layer.cornerRadius = CGFloat(8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(cancelButtonTouchUp), for: .touchUpInside)

        return button
    }()

    lazy private var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1)
        button.layer.cornerRadius = CGFloat(8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(okButtonTouchUp), for: .touchUpInside)

        return button
    }()

    lazy private var okAndCancelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.cancelButton, self.okButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        return stackView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadView()
    }

    private func loadView() {

        setSuperView()
        setupInputPlaceTextField()
        setViewConstraint()
    }

    private func setViewConstraint() {

        self.addsubviews(self.baseView)
        self.baseView.addsubviews(self.titleLabel, self.textFieldView, self.okAndCancelStackView)
        self.textFieldView.addsubviews(self.textFieldButton, self.inputPlaceTextField)

        NSLayoutConstraint.activate([

            self.baseView.topAnchor.constraint(equalTo: self.topAnchor, constant: 168),
            self.baseView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.baseView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.baseView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -168),

            self.titleLabel.topAnchor.constraint(equalTo: self.baseView.topAnchor, constant: 30),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),

            self.textFieldView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.textFieldView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 33),
            self.textFieldView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -31),
            self.textFieldView.heightAnchor.constraint(equalToConstant: 56),

            self.textFieldButton.topAnchor.constraint(equalTo: self.textFieldView.topAnchor, constant: 6),
            self.textFieldButton.bottomAnchor.constraint(equalTo: self.textFieldView.bottomAnchor, constant: -6),
            self.textFieldButton.trailingAnchor.constraint(equalTo: self.textFieldView.trailingAnchor, constant: -6),
            self.textFieldButton.widthAnchor.constraint(equalToConstant: 44),

            self.inputPlaceTextField.centerYAnchor.constraint(equalTo: self.textFieldView.centerYAnchor),
            self.inputPlaceTextField.leadingAnchor.constraint(equalTo: self.textFieldView.leadingAnchor, constant: 16),
            self.inputPlaceTextField.trailingAnchor.constraint(equalTo: self.textFieldButton.leadingAnchor, constant: -16),

            self.okAndCancelStackView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor, constant: -24),
            self.okAndCancelStackView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
            self.okAndCancelStackView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32),
            self.okAndCancelStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setSuperView() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }

    private func setupInputPlaceTextField() {
        let item1 = SearchTextFieldItem(title: "Blue", subtitle: "Color", image: UIImage(named: "icon_blue"))
        let item2 = SearchTextFieldItem(title: "Red", subtitle: "Color", image: UIImage(named: "icon_red"))
        let item3 = SearchTextFieldItem(title: "Yellow", subtitle: "Color", image: UIImage(named: "icon_yellow"))
        self.inputPlaceTextField.filterItems([item1, item2, item3])
    }

    @objc private func cancelButtonTouchUp(sender: UIButton) {
        self.delegate?.cancelButtonDidSelected(self)
    }

    @objc private func okButtonTouchUp(sender: UIButton) {
        self.delegate?.okButtonDidSelected(self)
    }

    @objc private func searchButtonTapped() {
        guard let searchText = self.inputPlaceTextField.text, self.inputPlaceTextField.text?.isEmpty == false  else {
            return
        }

        SearchPlaceAPI.request(searchText: searchText) { [weak self] result in
            switch result {
            case .success(let items):
                print("wndgus: items \(items.map { $0.title })")

                let filterItem = items.map { SearchTextFieldItem(title: $0.title) }

                DispatchQueue.main.async {
                    self?.inputPlaceTextField.filterItems(filterItem)

                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

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
