//
//  MyPageChangeTeamInfoViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/20.
//

import UIKit

class MyPageChangeTeamInfoViewController: UIViewController {

    @IBOutlet private var ageLabels: [UILabel]!
    @IBOutlet private weak var skillLabels: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        setNavigationController()
        setAgeSliderLabelsLayout()
        setSkillSliderLabelsLayout()
    }

    private func setNavigationController() {
        self.navigationController?.navigationBar.topItem?.title = "팀 정보 변경"
    }

    private func setAgeSliderLabelsLayout() {
        let ageSliderLabelsXPosition = createLabelXPositions(slider: self.ageSlider)
        setupLabelConstraint(labelXPositons: ageSliderLabelsXPosition, slider: self.ageSlider ,labels: self.ageSliderLabels)
    }

    private func setSkillSliderLabelsLayout() {
        let skillSliderLabelsXPosition = createLabelXPositions(slider: self.skillSlider)
        setupLabelConstraint(labelXPositons: skillSliderLabelsXPosition, slider: self.skillSlider, labels: self.skillSliderLabels)
    }

    private func setupLabelConstraint(labelXPositons: [CGFloat],slider: UISlider, labels: [UILabel]) {
        for index in 0...6 {
            labels[index].translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labels[index].topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 4),
                labels[index].centerXAnchor.constraint(equalTo: slider.leadingAnchor, constant: labelXPositons[index])
            ])
        }
    }

    private func createLabelXPositions(slider: UISlider) -> [CGFloat] {
        let sliderLinePadding: CGFloat = ((slider.currentThumbImage?.size.width)! / 2)
        let sliderLineWidth = slider.frame.width - ((sliderLinePadding) * 2)
        let offset = (sliderLineWidth / 6)
        let firstLabelXPosition = sliderLinePadding - 2

        var arrayLabelXPosition: [CGFloat] = []
        arrayLabelXPosition.append(firstLabelXPosition)
        for index in 1..<7 {
            let offset = (offset * CGFloat(index))
            let labelXPosition = firstLabelXPosition + offset
            arrayLabelXPosition.append(labelXPosition)
        }

        return arrayLabelXPosition
    }
}
