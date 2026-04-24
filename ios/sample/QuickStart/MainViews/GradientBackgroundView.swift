//
//  GradientBackgroundView.swift
//  QuickStart
//

import UIKit

/// Aurora/glassmorphism ambient glow background with three radial gradient orbs
class GradientBackgroundView: UIView {
    // MARK: - Orb Configuration
    private struct Orb {
        let color: UIColor
        let center: CGPoint  // Relative (0~1)
        let radius: CGFloat  // Points
    }

    private let orbs: [Orb] = [
        Orb(
            color: UIColor(red: 0.831, green: 0.902, blue: 0.271, alpha: 0.33),  // #D4E645, 33%
            center: CGPoint(x: 0.70, y: 0.30),
            radius: 300
        ),
        Orb(
            color: UIColor(red: 0.961, green: 0.902, blue: 0.259, alpha: 0.25),  // #F5E642, 25%
            center: CGPoint(x: 0.30, y: 0.70),
            radius: 250
        ),
        Orb(
            color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.08),       // #FFFFFF, 8%
            center: CGPoint(x: 0.50, y: 0.50),
            radius: 200
        )
    ]

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.051, green: 0.051, blue: 0.051, alpha: 1.0)  // #0D0D0D
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(red: 0.051, green: 0.051, blue: 0.051, alpha: 1.0)
    }

    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Fill base color
        context.setFillColor(UIColor(red: 0.051, green: 0.051, blue: 0.051, alpha: 1.0).cgColor)
        context.fill(rect)

        // Draw each radial gradient orb
        for orb in self.orbs {
            let centerPoint = CGPoint(
                x: rect.width * orb.center.x,
                y: rect.height * orb.center.y
            )

            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            orb.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [
                CGColor(colorSpace: colorSpace, components: [red, green, blue, alpha])!,
                CGColor(colorSpace: colorSpace, components: [red, green, blue, 0.0])!
            ]
            let locations: [CGFloat] = [0.0, 1.0]

            guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: locations
            ) else { continue }

            context.drawRadialGradient(
                gradient,
                startCenter: centerPoint,
                startRadius: 0,
                endCenter: centerPoint,
                endRadius: orb.radius,
                options: []
            )
        }
    }
}
