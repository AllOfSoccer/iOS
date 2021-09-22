//
//  SkillSlider.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/10.
//

import UIKit

class SkillSlider: UIControl {

    var minimumValue: CGFloat = 0
    var maximumValue: CGFloat = 1
    var value: CGFloat = 0.5

    var thumbImage = UIImage.init(systemName: "circle.fill")

    private let trackLayer = CALayer()
    private let thumbImageView = UIImageView()

    private var previousLocation = CGPoint()

    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setSkillSlider()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setSkillSlider()
    }

    private func setSkillSlider() {
        self.trackLayer.frame = bounds.insetBy(dx: 0.0, dy: 6)
        self.trackLayer.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).cgColor
        layer.addSublayer(trackLayer)

        thumbImageView.image = thumbImage
        addSubview(thumbImageView)

        updateLayerFrames()
    }

    // 1
    private func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: 6)
        trackLayer.cornerRadius = 3
        trackLayer.setNeedsDisplay()
        thumbImageView.frame = CGRect(origin: thumbOriginForValue(value),
                                      size: CGSize(width: 20, height: 20))
        thumbImageView.tintColor = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1)
    }
    // 2
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }
    // 3
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - thumbImage!.size.width / 2.0
        return CGPoint(x: x, y: (bounds.height - thumbImage!.size.height) / 2.0)
    }
}

extension SkillSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // 1
        previousLocation = touch.location(in: self)

        // 2
        if thumbImageView.frame.contains(previousLocation) {
            thumbImageView.isHighlighted = true
        }

        // 3
        return thumbImageView.isHighlighted
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        // 1
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width

        previousLocation = location

        // 2
        if thumbImageView.isHighlighted {
            value += deltaValue
            value = boundValue(value, toLowerValue: minimumValue, upperValue: maximumValue)
        }

        // 3
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        updateLayerFrames()

        CATransaction.commit()

        sendActions(for: .valueChanged)

        return true
    }

    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        thumbImageView.isHighlighted = false
    }
}
