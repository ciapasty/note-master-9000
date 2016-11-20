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
    }

    override func draw(_ rect: CGRect) {
        //super.draw(rect)
        
        tintColor.set()
        
        let pathH = UIBezierPath()
        let pathV = UIBezierPath()
        pathH.lineWidth = Constants.StaffHorizontalLineWidth
        pathV.lineWidth = Constants.StaffVerticalLineWidth
        
        // Horizontal lines
        for i in 3...7 {
            pathH.move(to: CGPoint(x: bounds.width/20, y: bounds.height*CGFloat(Double(i)/10.0)))
            pathH.addLine(to: CGPoint(x: bounds.width*19/20, y: bounds.height*CGFloat(Double(i)/10.0)))
        }
        
        // Vertical line
        pathV.move(to: CGPoint(x: bounds.width/20, y: bounds.height*3/10-0.5))
        pathV.addLine(to: CGPoint(x: bounds.width/20, y: bounds.height*7/10+0.5))
        
        pathH.stroke()
        pathV.stroke()
    }

}
