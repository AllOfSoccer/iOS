//
//  SecondRecruitmentViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/12.
//

import UIKit

class FirstTeamRecruitmentViewController: UIViewController {

    @IBOutlet private weak var sixMatchButton: IBSelectTableButton?
    @IBOutlet private weak var elevenMatchButton: IBSelectTableButton?
    @IBOutlet private weak var manMatchButton: IBSelectTableButton?
    @IBOutlet private weak var womanMatchButton: IBSelectTableButton?
    @IBOutlet private weak var mixMatchButton: IBSelectTableButton?
    @IBOutlet private weak var futsalShoesButton: IBSelectTableButton?
    @IBOutlet private weak var soccerShoesButton: IBSelectTableButton?

    @IBAction private func calendarButtonTouchUp(_ sender: UIButton) {
        let recruitmentCalendarView = RecruitmentCalendarView()
        recruitmentCalendarView.delegate = self
        self.subviewConstraints(view: recruitmentCalendarView)
    }

    @IBAction private func placeButtonTouchUp(_ sender: UIButton) {
        let searchPlaceView = SearchPlaceView()
        searchPlaceView.delegate = self
        self.subviewConstraints(view: searchPlaceView)
    }

    @IBAction private func backButtonItemTouchUp(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func informationCheckButtonTouchUp(_ sender: IBSelectTableButton) {
        sender.isSelected = sender.isSelected ? false : true
    }

    @IBAction func callPreviousInformationButtonTouchUp(_ sender: UIButton) {
        let callPreviousInformationView = CallPreviusMatchingInformationView()
        callPreviousInformationView.delegate = self
        self.subviewConstraints(view: callPreviousInformationView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setMatchButton()
    }

    private func setMatchButton() {
        self.sixMatchButton?.addTarget(self, action: #selector(sixMatchButtonTouchUp), for: .touchUpInside)
        self.elevenMatchButton?.addTarget(self, action: #selector(elevenMatchButtonTouchUp), for: .touchUpInside)
        self.manMatchButton?.addTarget(self, action: #selector(manMatchButtonTouchUp), for: .touchUpInside)
        self.womanMatchButton?.addTarget(self, action: #selector(womanMatchButtonTouchUp), for: .touchUpInside)
        self.mixMatchButton?.addTarget(self, action: #selector(mixMatchButtonTouchUp), for: .touchUpInside)
        self.futsalShoesButton?.addTarget(self, action: #selector(futsalShoesButtonTouchUp), for: .touchUpInside)
        self.soccerShoesButton?.addTarget(self, action: #selector(soccerShoesButtonTouchUp), for: .touchUpInside)
    }

    private func subviewConstraints(view: UIView) {
        guard let navigationController = self.navigationController else { return }
        navigationController.view.addsubviews(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: navigationController.view.topAnchor, constant: 0),
            view.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor, constant: 0)
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

extension FirstTeamRecruitmentViewController:
    RecruitmentCalendarViewDelegate {

    func cancelButtonDidSelected(_ view: RecruitmentCalendarView) {
        view.removeFromSuperview()
    }

    func okButtonDidSelected(_ view: RecruitmentCalendarView, selectedDate: [String]) {
        view.removeFromSuperview()
    }
}

extension FirstTeamRecruitmentViewController: SearchPlaceViewDelegate {
    func cancelButtonDidSelected(_ view: SearchPlaceView) {
        view.removeFromSuperview()
    }

    func okButtonDidSelected(_ view: SearchPlaceView) {
        view.removeFromSuperview()
    }
}

extension FirstTeamRecruitmentViewController: CallPreviusMatchingInformationViewDelegate {

    func cancelButtonDidSelected(_ view: CallPreviusMatchingInformationView) {
        view.removeFromSuperview()
    }
    func OKButtonDidSelected(_ view: CallPreviusMatchingInformationView) {
        view.removeFromSuperview()
    }
}
