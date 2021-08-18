//
//  SearchPlaceView.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/17.
//

import UIKit
import SearchTextField

class SearchPlaceView: UIView {

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
        textField.maxNumberOfResults = 4
        textField.maxResultsListHeight = 244
        textField.inlineMode = false
        textField.tableYOffset = 20
        return textField
    }()

    lazy private var textFieldButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = CGFloat(5)
        let buttonImage = UIImage(named: "search")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1)
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

    private func loadView() {
        setupInputPlaceTextField()
        setupViewConstraint()
        setupSuperView()
    }

    private func setupViewConstraint() {
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32)
        ])

        self.addSubview(self.textFieldView)
        self.textFieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textFieldView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.textFieldView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 33),
            self.textFieldView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -31),
            self.textFieldView.heightAnchor.constraint(equalToConstant: 56)
        ])

        self.textFieldView.addSubview(self.textFieldButton)
        self.textFieldButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textFieldButton.topAnchor.constraint(equalTo: self.textFieldView.topAnchor, constant: 6),
            self.textFieldButton.bottomAnchor.constraint(equalTo: self.textFieldView.bottomAnchor, constant: -6),
            self.textFieldButton.trailingAnchor.constraint(equalTo: self.textFieldView.trailingAnchor, constant: -6),
            self.textFieldButton.widthAnchor.constraint(equalToConstant: 44)
        ])

        self.textFieldView.addSubview(self.inputPlaceTextField)
        self.inputPlaceTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.inputPlaceTextField.centerYAnchor.constraint(equalTo: self.textFieldView.centerYAnchor),
            self.inputPlaceTextField.leadingAnchor.constraint(equalTo: self.textFieldView.leadingAnchor, constant: 16),
            self.inputPlaceTextField.trailingAnchor.constraint(equalTo: self.textFieldButton.leadingAnchor, constant: -16),
        ])

        self.addSubview(self.okAndCancelStackView)
        self.okAndCancelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.okAndCancelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            self.okAndCancelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.okAndCancelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            self.okAndCancelStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupSuperView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = CGFloat(12)
    }

    private func setupInputPlaceTextField() {
        let item1 = SearchTextFieldItem(title: "Blue", subtitle: "Color", image: UIImage(named: "icon_blue"))
        let item2 = SearchTextFieldItem(title: "Red", subtitle: "Color", image: UIImage(named: "icon_red"))
        let item3 = SearchTextFieldItem(title: "Yellow", subtitle: "Color", image: UIImage(named: "icon_yellow"))
        self.inputPlaceTextField.filterItems([item1, item2, item3])
    }

    @objc private func cancelButtonTouchUp(sender: UIButton) {
        print("취소버튼이 클릭되었습니다.")
    }

    @objc private func okButtonTouchUp(sender: UIButton) {
        print("확인버튼이 클릭되었습니다.")
    }
}

extension UITextField {
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil){
        if let left = left {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        if let right = right {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

