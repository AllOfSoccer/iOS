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

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchPlaceResultCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        return tableView
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
        self.baseView.addsubviews(self.titleLabel, self.textFieldView, self.okAndCancelStackView, self.tableView)
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
            self.okAndCancelStackView.heightAnchor.constraint(equalToConstant: 40),

            self.tableView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
            self.tableView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32),
            self.tableView.topAnchor.constraint(equalTo: inputPlaceTextField.bottomAnchor, constant: 20),
            self.tableView.bottomAnchor.constraint(equalTo: self.okAndCancelStackView.topAnchor, constant: -20)
        ])
    }

    private func setSuperView() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }

    private func setupInputPlaceTextField() {
        self.inputPlaceTextField.filterItems([])
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
                let filterItem = items.map { SearchTextFieldItem(title: $0.title) }

                DispatchQueue.main.async {
                    self?.inputPlaceTextField.filterItems(filterItem)
                    self?.searchItem = items
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private var searchItem: [SearchPlaceAPI.Item] = []
}

extension SearchPlaceView: UITableViewDelegate {

}

extension SearchPlaceView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.searchItem.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SearchPlaceResultCell")

        cell.textLabel?.text = self.searchItem[safe: indexPath.row]?.title ?? "실패-조중현"
        cell.detailTextLabel?.text = self.searchItem[safe: indexPath.row]?.address ?? "실패-조중현"

        return cell
    }

}
