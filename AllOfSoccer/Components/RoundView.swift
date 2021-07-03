//
//  RoundView.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/03.
//

import UIKit

@IBDesignable
final class RoundView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
}

