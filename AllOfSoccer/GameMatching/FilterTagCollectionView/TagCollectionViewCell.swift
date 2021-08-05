//
//  GameMatchingTagCollectionViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/25.
//

import UIKit

protocol TagCollectionViewCellTapped: AnyObject {
    func cellDidSelected(_ cell: TagCollectionViewCell)
}

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagButton: RoundButton!
    weak var delegate: TagCollectionViewCellTapped?

    @IBAction private func tagButtonTouchUp(_ sender: RoundButton) {
        self.delegate?.cellDidSelected(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tagButton.isSelected = false
    }

    func configure(_ tagCellData: TagCellModel, _ resetButtonIsSelected: Bool) {
        guard let tagCellTitle = tagCellData.tagCellTitle else { return }
        guard let tagCellIsSelected = tagCellData.tagCellIsSelected else { return }

        self.tagButton.setTitle(tagCellData.tagCellTitle, for: .normal)

        self.tagButton.isSelected = tagCellIsSelected
        if self.tagButton.isSelected {
            self.tagButton.backgroundColor = UIColor.init(named: "tagBackTouchUpColor")
            self.tagButton.setTitleColor(.white, for: .normal)
            self.tagButton.isSelected = false
        } else {
            self.tagButton.backgroundColor = UIColor.init(named: "tagBackNoneTouchUpColor")
            self.tagButton.setTitleColor(UIColor.init(named: "tagTitleNoneTouchUpColor"), for: .selected)
            self.tagButton.isSelected = true
        }

        if resetButtonIsSelected {
            self.tagButton.isSelected = false
            self.tagButton.backgroundColor = UIColor.init(named: "tagBackNoneTouchUpColor")
            self.tagButton.setTitleColor(UIColor.init(named: "tagTitleNoneTouchUpColor"), for: .normal)
        }
    }
}
