//
//  MyPageViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/04.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet private weak var mywritingButton: UIButton!
    @IBOutlet private weak var myfavoriteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mywritingButton.centerVertically(4)
        self.myfavoriteButton.centerVertically(4)
    }
}
