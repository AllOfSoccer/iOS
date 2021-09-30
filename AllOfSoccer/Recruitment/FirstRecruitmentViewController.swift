//
//  SecondRecruitmentViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/12.
//

import UIKit

class FirstRecruitmentViewController: UIViewController {

    private let searchPlaceView = SearchPlaceView()
    private let recruitmentCalendarView = RecruitmentCalendarView()
    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    @IBOutlet weak var sixMatchButton: SelectTableButton!
    @IBOutlet weak var elevenMatchButton: SelectTableButton!
    @IBOutlet weak var manMatchButton: SelectTableButton!
    @IBOutlet weak var womanMatchButton: SelectTableButton!
    @IBOutlet weak var mixMatchButton: SelectTableButton!
    @IBOutlet weak var futsalShoesButton: SelectTableButton!
    @IBOutlet weak var soccerShoesButton: SelectTableButton!

    @IBAction private func calendarButtonTouchUp(_ sender: UIButton) {
        self.recruitmentCalendarView.isHidden = false
        self.backgroundView.isHidden = false
    }

    @IBAction private func placeButtonTouchUp(_ sender: UIButton) {
        self.searchPlaceView.isHidden = false
        self.backgroundView.isHidden = false
    }

    @IBAction private func backButtonItemTouchUp(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setMatchButton()
        setupViewConstraint()

        self.backgroundView.isHidden = true
        self.searchPlaceView.isHidden = true
        self.recruitmentCalendarView.isHidden = true

        self.recruitmentCalendarView.delegate = self
        self.searchPlaceView.delegate = self
    }

    private func setMatchButton() {
        self.sixMatchButton.addTarget(self, action: #selector(sixMatchButtonTouchUp), for: .touchUpInside)
        self.elevenMatchButton.addTarget(self, action: #selector(elevenMatchButtonTouchUp), for: .touchUpInside)
        self.manMatchButton.addTarget(self, action: #selector(manMatchButtonTouchUp), for: .touchUpInside)
        self.womanMatchButton.addTarget(self, action: #selector(womanMatchButtonTouchUp), for: .touchUpInside)
        self.mixMatchButton.addTarget(self, action: #selector(mixMatchButtonTouchUp), for: .touchUpInside)
        self.futsalShoesButton.addTarget(self, action: #selector(futsalShoesButtonTouchUp), for: .touchUpInside)
        self.soccerShoesButton.addTarget(self, action: #selector(soccerShoesButtonTouchUp), for: .touchUpInside)
    }

    private func setupViewConstraint() {
        guard let navigationController = self.navigationController else { return }
        navigationController.view.addSubview(self.backgroundView)
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.backgroundView.topAnchor.constraint(equalTo: navigationController.view.topAnchor, constant: 0),
            self.backgroundView.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor, constant: 0),
            self.backgroundView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor, constant: 0),
            self.backgroundView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor, constant: 0)
        ])

        self.searchPlaceView.backgroundColor = .white
        self.backgroundView.addSubview(self.searchPlaceView)
        self.searchPlaceView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.searchPlaceView.topAnchor.constraint(equalTo: self.backgroundView.topAnchor, constant: 167),
            self.searchPlaceView.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -167),
            self.searchPlaceView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 20),
            self.searchPlaceView.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -20)
        ])

        self.recruitmentCalendarView.backgroundColor = .white
        self.backgroundView.addSubview(self.recruitmentCalendarView)
        self.recruitmentCalendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.recruitmentCalendarView.topAnchor.constraint(equalTo: self.backgroundView.topAnchor, constant: 167),
            self.recruitmentCalendarView.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -167),
            self.recruitmentCalendarView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 20),
            self.recruitmentCalendarView.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -20)
        ])
    }

    @objc func sixMatchButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }

    @objc func elevenMatchButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }

    @objc func manMatchButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }

    @objc func womanMatchButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }

    @objc func mixMatchButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }

    @objc func futsalShoesButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }

    @objc func soccerShoesButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }
}

extension FirstRecruitmentViewController:
    RecruitmentCalendarViewDelegate {

    func cancelButtonDidSelected(_ sender: RecruitmentCalendarView) {
        self.backgroundView.isHidden = true
        self.recruitmentCalendarView.isHidden = true
    }

    // 향후 데이터 처리를 할 함수
    func okButtonDidSelected(_ sender: RecruitmentCalendarView) {
        self.backgroundView.isHidden = true
        self.recruitmentCalendarView.isHidden = true
    }
}

extension FirstRecruitmentViewController: SearchPlaceViewDelegate {
    func cancelButtonDidSelected(_ sender: SearchPlaceView) {
        self.backgroundView.isHidden = true
        self.searchPlaceView.isHidden = true
    }

    func okButtonDidSelected(_ sender: SearchPlaceView) {
        self.backgroundView.isHidden = true
        self.searchPlaceView.isHidden = true
    }
}
