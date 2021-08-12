//
//  SecondRecruitmentViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/12.
//

import UIKit

class SecondRecruitmentViewController: UIViewController {

    private let recruitmentCalendarView = RecruitmentCalendarView()
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.recruitmentCalendarView.backgroundColor = .green
        self.view.addSubview(self.recruitmentCalendarView)
        self.recruitmentCalendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.recruitmentCalendarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 167),
            self.recruitmentCalendarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -167),
            self.recruitmentCalendarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.recruitmentCalendarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
}
