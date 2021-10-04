//
//  IntroductionDetailView.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/11.
//

import UIKit

enum Comment: Int {
    case first
    case second
    case third
    case fourth
    case fifth

    var content: String {
        switch self {
        case .first: return "편하게 연락주세요."
        case .second: return "매너있게 운동하실 분 기다립니다."
        case .third: return "문자로 연락주세요."
        case .fourth: return "연락시 팀 소개 부탁드립니다."
        case .fifth: return "직접입력"
        }
    }
}

protocol IntroductionDetailViewDelegate: AnyObject {
    func cancelButtonDidSelected(_ view: IntroductionDetailView)
    func OKButtonDidSelected(_ view: IntroductionDetailView, _ model: [Comment])
}

class IntroductionDetailView: UIView {

    weak var delegate: IntroductionDetailViewDelegate?
    private var commentsModel: [Comment] = []

    private var firstCommentButton = UIButton()
    private var secondCommentButton = UIButton()
    private var thirdCommentButton = UIButton()
    private var fourthCommentButton = UIButton()
    private var fifthCommentButton = UIButton()

    private lazy var commentsButtons: [UIButton] = [firstCommentButton, secondCommentButton, thirdCommentButton, fourthCommentButton, fifthCommentButton]

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1).cgColor
        button.clipsToBounds = true
        button.setBackgroundColor(UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonDidSelected), for: .touchUpInside)

        return button
    }()

    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.setBackgroundColor(UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1).cgColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(OKButtonDidSelected), for: .touchUpInside)

        return button
    }()

    private lazy var commentsButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstCommentButton, secondCommentButton, thirdCommentButton, fourthCommentButton, fifthCommentButton])

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var OKCancelButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, okButton])

        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()

    @objc private func checkButtonTouchUp(_ sender: UIButton) {
        print("CheckButton이 클릭되었습니다.")

        sender.isSelected = sender.isSelected == true ? false : true
        sender.tintColor = sender.isSelected == true ? UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1) : UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
    }

    @objc func cancelButtonDidSelected(sender: UIButton) {
        print("cancelButton이 클릭되었습니다")
        self.delegate?.cancelButtonDidSelected(self)
    }

    @objc func OKButtonDidSelected(sender: UIButton) {
        print("OKButton이 클릭되었습니다")
        self.commentsModel = self.commentsButtons.filter { $0.isSelected }.compactMap { Comment(rawValue: $0.tag) }
        self.delegate?.OKButtonDidSelected(self, self.commentsModel)
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

        setView()
        setCommentButton()
        setConstraint()
    }

    private func setView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
    }

    private func setCommentButton() {

        self.firstCommentButton = self.checkButton(Comment.first)
        self.secondCommentButton = self.checkButton(Comment.second)
        self.thirdCommentButton = self.checkButton(Comment.third)
        self.fourthCommentButton = self.checkButton(Comment.fourth)
        self.fifthCommentButton = self.checkButton(Comment.fifth)
    }

    private func setConstraint() {
        self.addsubviews([self.commentsButtonStackView, self.OKCancelButtonStackView])

        NSLayoutConstraint.activate([
            self.OKCancelButtonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.OKCancelButtonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            self.OKCancelButtonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            self.OKCancelButtonStackView.heightAnchor.constraint(equalToConstant: 40),

            self.commentsButtonStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            self.commentsButtonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.commentsButtonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            self.commentsButtonStackView.bottomAnchor.constraint(equalTo: self.OKCancelButtonStackView.topAnchor, constant: -30)
        ])
    }

    private func checkButton(_ commentType: Comment) -> UIButton {
        let button = UIButton()

        let nonCheckedBoxImage = UIImage(systemName: "checkmark.circle")
        let checkedBoxImage = UIImage(systemName: "checkmark.circle.fill")
        button.setImage(nonCheckedBoxImage, for: .normal)
        button.setImage(checkedBoxImage, for: .selected)
        button.tintColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.setTitle(commentType.content, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.tag = commentType.rawValue

        button.addTarget(self, action: #selector(checkButtonTouchUp), for: .touchUpInside)

        return button
    }

    internal func clearView() {

        self.commentsModel = []

        self.commentsButtons.forEach {
            $0.isSelected = false
            $0.tintColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
            $0.layoutIfNeeded()
        }
    }
}
