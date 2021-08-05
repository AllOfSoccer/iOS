//
//  GameMatchingTagCollectionViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/25.
//

import UIKit

class FilterTagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 18
        let didDeSelectedbackgroundColor = UIColor(red: 246.0/255.0, green: 247.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        let didDeSelectedTitleColor = UIColor(red: 157.0/255.0, green: 159.0/255.0, blue: 160.0/255.0, alpha: 1)
        self.contentView.backgroundColor = didDeSelectedbackgroundColor
        self.tagLabel.textColor = didDeSelectedTitleColor
        self.tagImageView.tintColor = didDeSelectedTitleColor
    }

    override var isSelected: Bool {
        didSet {
            let didSelectedBackgroundColor = UIColor(red: 236.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0)
            let didDeSelectedbackgroundColor = UIColor(red: 246.0/255.0, green: 247.0/255.0, blue: 250.0/255.0, alpha: 1.0)
            let didSelectedTitleColor = UIColor.white
            let didDeSelectedTitleColor = UIColor(red: 157.0/255.0, green: 159.0/255.0, blue: 160.0/255.0, alpha: 1)

            self.contentView.backgroundColor = isSelected ? didSelectedBackgroundColor : didDeSelectedbackgroundColor
            self.tagLabel.textColor = isSelected ? didSelectedTitleColor : didDeSelectedTitleColor
            self.tagImageView.tintColor = isSelected ? didSelectedTitleColor : didDeSelectedTitleColor
        }
    }

    func configure(_ model: FilterTagModel) {
        self.tagLabel.text = model.title
    }
}
