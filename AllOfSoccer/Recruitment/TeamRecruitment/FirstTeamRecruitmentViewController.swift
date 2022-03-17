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

    @IBOutlet private weak var selectTimeLabel: UILabel?

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.destination is SecondTeamRecruitmentViewController {
            print("중현: 필요한 데이터를 넘긴다.")
        }
    }

    private func setMatchButton() {
        [self.sixMatchButton, self.elevenMatchButton, self.manMatchButton, self.womanMatchButton, self.mixMatchButton, self.futsalShoesButton, self.soccerShoesButton].forEach { $0.addTarget(self, action: #selector(matchButtonTouchUp), for: .touchUpInside)
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

    @objc func matchButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
    }
}

extension FirstTeamRecruitmentViewController:
    RecruitmentCalendarViewDelegate {

    func cancelButtonDidSelected(_ view: RecruitmentCalendarView) {
        view.removeFromSuperview()
    }

    func okButtonDidSelected(_ view: RecruitmentCalendarView, selectedDate: String) {
        self.selectTimeLabel?.text = selectedDate
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
