//
//  DetailGameMatchingViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/07.
//

import UIKit

class DetailGameMatchingViewController: UIViewController {

    @IBAction func backButtonTouchUp(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationViewController()
        
    }

    private func setupNavigationViewController() {

    }
}
