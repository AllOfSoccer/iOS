//
//  SelectTableButton.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/05.
//

import UIKit

class SelectTableButton: UIButton {

    @IBInspectable var normalBackgroundColor: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1) {
        didSet {
            update()
        }
    }

    @IBInspectable var selectBackgroundColor: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1) {
        didSet {
            update()
        }
    }

    @IBInspectable var normalTitleColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            update()
        }
    }

    @IBInspectable var selectTitleColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            update()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            update()
        }
    }

    @IBInspectable var normalBorderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            update()
        }
    }

    @IBInspectable var selectBorderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            update()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            update()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        update()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        update()
    }

    override func prepareForInterfaceBuilder() {
        update()
    }

    private func update() {
        layer.cornerRadius = cornerRadius
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(selectTitleColor, for: .selected)
        backgroundColor = isSelected ? selectBackgroundColor : normalBackgroundColor
        layer.borderColor = isSelected ? selectBorderColor.cgColor : normalBorderColor.cgColor
        layer.borderWidth = borderWidth
        contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        tintColor = UIColor.clear
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setTitleColor(UIColor.black, for: .selected)
//        setTitleColor(UIColor.systemGray5, for: .normal)
//        tintColor = .clear
//
//        self.backgroundColor = self.isSelected ? UIColor
//    }
}
