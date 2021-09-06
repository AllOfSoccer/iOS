//
//  RecruitmentViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/10.
//

import UIKit
import RangeSeekSlider

class SecondRecruitmentViewController: UIViewController {

    @IBOutlet private weak var rangeSlider: RangeSeekSlider!

    @IBOutlet private weak var firstAgeLabel: UILabel!
    @IBOutlet private weak var secondAgeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let rangeSliderLinePadding: CGFloat = 16
//        let rangeSliderLineWidth = UIScreen.main.bounds.size.width - (2 * rangeSliderLinePadding)
        let rangeSliderLineWidth = rangeSlider.frame.width - (2 * rangeSliderLinePadding)
        var offset = rangeSliderLineWidth / 6
        let firstLabelXPosition = rangeSliderLinePadding
        var arrayLabelXPosition: [CGFloat] = []

        arrayLabelXPosition.append(firstLabelXPosition)
        for index in 1..<7 {
//            let tempOffset = offset * CGFloat(index)
//            print(offset)
            let offset = (offset * CGFloat(index))
            let labelXPosition = firstLabelXPosition + offset
            arrayLabelXPosition.append(labelXPosition)
        }
        print(arrayLabelXPosition)


        self.firstAgeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.firstAgeLabel.topAnchor.constraint(equalTo: self.rangeSlider.bottomAnchor, constant: 4),
            self.firstAgeLabel.centerXAnchor.constraint(equalTo: self.rangeSlider.leadingAnchor, constant: 16)
        ])

        self.secondAgeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.secondAgeLabel.topAnchor.constraint(equalTo: self.rangeSlider.bottomAnchor, constant: 4),
            self.secondAgeLabel.centerXAnchor.constraint(equalTo: self.rangeSlider.leadingAnchor, constant: 207)
        ])
    }
}
