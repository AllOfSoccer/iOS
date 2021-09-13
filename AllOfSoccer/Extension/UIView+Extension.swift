//
//  UIView+Extension.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/12.
//

import UIKit

extension UIView {
    func addsubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }

    func addsubviews(_ views: [UIView]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}
