//
//  SelectTableButton.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/05.
//

import UIKit

class SelectTableButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.black, for: .selected)
        setTitleColor(UIColor.systemGray5, for: .normal)
        tintColor = .clear
    }
}
