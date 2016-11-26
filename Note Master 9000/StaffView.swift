//
//  StaffView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 20/11/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

@IBDesignable
class StaffView: UIView {
    
    private struct Constants {
        static let StaffVerticalLineWidth: CGFloat = 3.0
        static let StaffHorizontalLineWidth: CGFloat = 1.0
        static let StaffVerticalLineAnimationDuration: Double = 0.56
        static let StaffHorizontalLineAnimationDuration: Double = 0.7
    }

    override func draw(_ rect: CGRect) {
        layer.sublayers = nil
        layer.addSublayer(drawStaffLayer(false))
    }
    
    private func drawStaffLayer(_ animated: Bool) -> CALayer {
        
        let staffPathH = UIBezierPath()
        let staffPathV = UIBezierPath()
        let staffLayerH = CAShapeLayer()
        let staffLayerV = CAShapeLayer()
        let staffLayer = CALayer()
        
        // Horizontal lines
        for i in 3...7 {
            staffPathH.move(to: CGPoint(x: frame.width/20, y: frame.height*CGFloat(Double(i)/10.0)))
            staffPathH.addLine(to: CGPoint(x: frame.width*19/20, y: frame.height*CGFloat(Double(i)/10.0)))
        }
        
        staffLayerH.path = staffPathH.cgPath
        staffLayerH.lineWidth = Constants.StaffHorizontalLineWidth
        staffLayerH.strokeColor = tintColor.cgColor
        
        staffLayer.addSublayer(staffLayerH)
        
        // Horizontal line animation
        if animated {
            let animateHorizontal = CABasicAnimation(keyPath: "strokeEnd")
            animateHorizontal.duration = Constants.StaffHorizontalLineAnimationDuration
            animateHorizontal.fromValue = 0.0
            animateHorizontal.toValue = 1.0
            staffLayerH.add(animateHorizontal, forKey: "HorizontalLinesAnimation")
        }
        
        // Vertical line
        staffPathV.move(to: CGPoint(x: frame.width/20, y: frame.height*3/10-0.5))
        staffPathV.addLine(to: CGPoint(x: frame.width/20, y: frame.height*7/10+0.5))
        
        staffLayerV.path = staffPathV.cgPath
        staffLayerV.lineWidth = Constants.StaffVerticalLineWidth
        staffLayerV.strokeColor = tintColor.cgColor
        
        staffLayer.addSublayer(staffLayerV)
        
        // Vertical lines animation
        if animated {
            let animateVertical = CABasicAnimation(keyPath: "strokeEnd")
            animateVertical.duration = Constants.StaffVerticalLineAnimationDuration
            animateVertical.fromValue = 0.0
            animateVertical.toValue = 1.0
            staffLayerV.add(animateVertical, forKey: "VerticalLinesAnimation")
        }
        
        return staffLayer
    }
    
    private func drawAddLines(for note: Note, at width: CGFloat) -> CALayer {
        let lineWidth = bounds.width/5
        let noteWidth = bounds.height/8
        let lineStart = width + (noteWidth/2) - lineWidth/2
        let lineEnd = width + (noteWidth/2) + lineWidth/2
        let linePath = UIBezierPath()
        let lineLayer = CAShapeLayer()
        
        if note.rawValue > 15 {
            linePath.move(to: CGPoint(x: lineStart, y: bounds.height*8/10))
            linePath.addLine(to: CGPoint(x: lineEnd, y: bounds.height*8/10))
            if note.rawValue > 17 {
                linePath.move(to: CGPoint(x: lineStart, y: bounds.height*9/10))
                linePath.addLine(to: CGPoint(x: lineEnd, y: bounds.height*9/10))
            }
        }
        
        if note.rawValue < 5 {
            linePath.move(to: CGPoint(x: lineStart, y: bounds.height*2/10))
            linePath.addLine(to: CGPoint(x: lineEnd, y: bounds.height*2/10))
            if note.rawValue < 3 {
                linePath.move(to: CGPoint(x: lineStart, y: bounds.height/10))
                linePath.addLine(to: CGPoint(x: lineEnd, y: bounds.height/10.0))
            }
        }
        
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = Constants.StaffHorizontalLineWidth
        lineLayer.strokeColor = tintColor.cgColor
        return lineLayer
    }
}
