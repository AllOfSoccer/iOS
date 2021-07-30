//
//  GameMatchingTagCollectionViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/25.
//

import UIKit

protocol TagCollectionViewCellTapped: AnyObject {
    func cellButtonTapped(_ button: RoundButton)
}

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var tagButton: RoundButton!
    weak var delegate: TagCollectionViewCellTapped?

    @IBAction private func tagButtonTouchUp(_ sender: RoundButton) {
        if self.tagButton.isSelected {
            self.tagButton.isSelected = false
            self.tagButton.backgroundColor = UIColor.init(named: "tagBackNoneTouchUpColor")
            self.tagButton.setTitleColor(UIColor.init(named: "tagTitleNoneTouchUpColor"), for: .normal)
        } else {
            self.tagButton.isSelected = true
            self.tagButton.backgroundColor = UIColor.init(named: "tagBackTouchUpColor")
            self.tagButton.setTitleColor(.white, for: .selected)
        }
        self.delegate?.cellButtonTapped(self.tagButton)
    }

    func configure(_ tagCellName: String, _ resetButtonIsSelected: Bool) {
        self.tagButton.setTitle(tagCellName, for: .normal)
        if resetButtonIsSelected {
            self.tagButton.isSelected = false
            self.tagButton.backgroundColor = UIColor.init(named: "tagBackNoneTouchUpColor")
            self.tagButton.setTitleColor(UIColor.init(named: "tagTitleNoneTouchUpColor"), for: .normal)
        }
    }
}
