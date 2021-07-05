//
//  GameMatchingViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/04.
//

import UIKit
import FSCalendar

class GameMatchingViewController: UIViewController {

    @IBOutlet weak var teamMatchButton: SelectTableButton!
    @IBOutlet weak var manMatchButton: SelectTableButton!
    @IBOutlet weak var selectedLineCenterConstraint: NSLayoutConstraint!

    @IBAction func teamMatchButtonTouchUp(_ sender: Any) {
        teamMatchButton.isSelected = true
        manMatchButton.isSelected = false

        UIView.animate(withDuration: 0.1) {
            self.selectedLineCenterConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        selectedLineCenterConstraint.constant = 0
    }

    @IBAction func manMatchButtonTouchUp(_ sender: Any) {
        teamMatchButton.isSelected = false
        manMatchButton.isSelected = true

        let constant = manMatchButton.center.x - teamMatchButton.center.x

        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.selectedLineCenterConstraint.constant = constant
            self?.view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
