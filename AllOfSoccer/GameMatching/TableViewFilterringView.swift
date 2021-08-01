//
//  TableViewFilterringView.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/01.
//

import UIKit

class TableViewFilterringView: UIView {

    private var tableViewFilterringCheckButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "tagBackTouchUpColor")
        return button
    }()

    private lazy var tableViewFilterringContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.text = "정렬기준"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

        let firstCheckView = checkView("거리순")
        let secondCheckView = checkView("최신 등록순")
        let thirdCheckView = checkView("경기 날짜/시간순")

        let stackV = UIStackView(arrangedSubviews: [firstCheckView, secondCheckView, thirdCheckView])
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.axis = .vertical
        stackV.spacing = 42
        stackV.distribution = .fillEqually

        view.addSubview(stackV)
        NSLayoutConstraint.activate([
            stackV.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            stackV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19)
        ])

        return view
    }()

    private func checkView(_ labelTitle: String) -> UIView {
        let view = UIView()

        let checkBox = UIButton()
        let nonCheckedBoxImage = UIImage(systemName: "checkmark.circle")
        let checkedBoxImage = UIImage(systemName: "checkmark.circle.fill")
        checkBox.setImage(nonCheckedBoxImage, for: .normal)
        checkBox.setImage(checkedBoxImage, for: .selected)
        checkBox.frame.size = CGSize(width: 22, height: 22)

        view.addSubview(checkBox)
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            checkBox.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let distanceLabel = UILabel()
        distanceLabel.textColor = .black
        distanceLabel.text = labelTitle
        distanceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        view.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            distanceLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 8),
            distanceLabel.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor)
        ])

        return view
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }

    private func loadView() {
        self.backgroundColor = .yellow

        let tableViewFilterringCheckButton = tableViewFilterringCheckButton
        self.addSubview(tableViewFilterringCheckButton)
        tableViewFilterringCheckButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewFilterringCheckButton.widthAnchor.constraint(equalTo: self.widthAnchor),
            tableViewFilterringCheckButton.heightAnchor.constraint(equalToConstant: 63),
            tableViewFilterringCheckButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])

        let tableViewFilterringContentView = tableViewFilterringContentView
        self.addSubview(tableViewFilterringContentView)
        tableViewFilterringContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewFilterringContentView.widthAnchor.constraint(equalTo: self.widthAnchor),
            tableViewFilterringContentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            tableViewFilterringContentView.bottomAnchor.constraint(equalTo: tableViewFilterringCheckButton.topAnchor, constant: 0)
        ])
    }
}
