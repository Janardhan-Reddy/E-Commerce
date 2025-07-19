//
//  ConcaveTopShape.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 19/07/25.
//

import UIKit



class SideCurveBottomView: UIView {

    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        layer.insertSublayer(shapeLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applySideCurvedBottomShape()
    }

    private func applySideCurvedBottomShape() {
        let width = bounds.width
        let height = bounds.height
        let curveRadius: CGFloat = 30
        let flatWidth = width * 0.5  // Adjust the flat section width

        let path = UIBezierPath()
        
        // Top Left → Top Right
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height - curveRadius))

        // Right Curve (down and in)
        path.addQuadCurve(to: CGPoint(x: width - curveRadius, y: height),
                          controlPoint: CGPoint(x: width, y: height))

        // Flat Bottom Middle
        path.addLine(to: CGPoint(x: curveRadius, y: height))

        // Left Curve (up and in)
        path.addQuadCurve(to: CGPoint(x: 0, y: height - curveRadius),
                          controlPoint: CGPoint(x: 0, y: height))

        path.close()

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(named: "CurveRed")?.cgColor
    }
}
