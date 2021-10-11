//
//  MainRecruitmentViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/10/01.
//

import UIKit

class FirstManRecruitmentViewController: UIViewController {

    @IBAction private func backButtonItemTouchUp(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func informationRecordButton(_ sender: IBSelectTableButton) {

        sender.isSelected = sender.isSelected ? false : true
    }


    override func viewDidLoad() {
        super.viewDidLoad()


    }
}
