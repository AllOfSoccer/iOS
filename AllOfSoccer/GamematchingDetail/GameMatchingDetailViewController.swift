//
//  GameMatchingDetailViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/15.
//

import UIKit

class GameMatchingDetailViewController: UIViewController {

    lazy var likeBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage.init(systemName: "heart"), style: .plain, target: self, action: #selector(likeBarbuttonTouchUp(_:)))
        button.tintColor = .black
        return button
    }()

    lazy var shareBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "ShareNetwork"), style: .plain, target: self, action: #selector(shareBarButtonTouchup(_:)))
        button.tintColor = .black
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
    }

    private func setupNavigationItem() {
        self.navigationItem.title = "팀 모집"
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        self.navigationController?.navigationBar.topItem?.title = ""

        self.navigationItem.rightBarButtonItems = [self.likeBarButton, self.shareBarButton]
    }

    @objc private func likeBarbuttonTouchUp(_ sender: UIBarButtonItem) {
        print("likeBarButton이 찍혔습니다.")
    }

    @objc private func shareBarButtonTouchup(_ sender: UIBarButtonItem) {
        print("shareBarButton이 찍혔습니다.")
    }
}
