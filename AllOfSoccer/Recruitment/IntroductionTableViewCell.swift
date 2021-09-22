//
//  IntroductionTableViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/08.
//

import UIKit

protocol IntroductionTableViewCellDelegate: AnyObject {
    func removeButtonDidSeleced(_ tableviewCell: IntroductionTableViewCell)
    func updownButtonDidSelected(_ tableviewCell: IntroductionTableViewCell)
}

class IntroductionTableViewCell: UITableViewCell {

    weak var delegate: IntroductionTableViewCellDelegate?

    @IBOutlet private weak var contentsLabel: UILabel!
    @IBOutlet private weak var removeButton: UIButton!

    @IBAction func removeButtonDidSelected(_ sender: UIButton) {
        self.delegate?.removeButtonDidSeleced(self)
    }

    @IBAction func updownButtonDidSelected(_ sender: Any) {
        self.delegate?.updownButtonDidSelected(self)
    }

    func configure(_ model: Comment) {
        self.contentsLabel.text = model.content
    }
}
