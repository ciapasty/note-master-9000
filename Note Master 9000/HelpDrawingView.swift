//
//  HelpDrawingView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 10/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class HelpDrawingView: UIView {
	
	// MARK: Constants
	
	private struct Constants {
		static let TrebleClefNoteNames = ["E", "D", "C", "B", "A", "G", "F"]
		static let BassClefNoteNames = ["G", "F", "E", "D", "C", "B", "A"]
	}
	
	// MARK: Initialization
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		
		backgroundColor = ColorPalette.Clouds.withAlphaComponent(0.5)
	}
	
	/*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	// MARK: Drawing
	
	func drawHelp(_ clef: Clef) {
		layer.sublayers = nil
		let letterFrame = CGRect(x: bounds.origin.x,
		                         y: bounds.origin.y,
		                         width: bounds.height/10,
		                         height: bounds.height/10)
		
		let helpOrigin = CGPoint(x: bounds.origin.x+letterFrame.width/2,
		                         y: bounds.origin.y+letterFrame.height/2)
		
		for i in 6...12 {
			let layer = CATextLayer()
			
			layer.frame = letterFrame
			layer.contentsScale = UIScreen.main.scale
			layer.alignmentMode = kCAAlignmentCenter
			layer.font = UIFont.systemFont(ofSize: 1, weight: UIFontWeightLight)
			layer.fontSize = frame.height/10
			
			if clef == Clef.trebleClef {
				layer.string = Constants.TrebleClefNoteNames[i-6]
			} else if clef == Clef.bassClef {
				layer.string = Constants.BassClefNoteNames[i-6]
			}
			
			layer.foregroundColor = ColorPalette.MidnightBlue.cgColor
			
			if i % 2 == 0 {
				layer.position = CGPoint(x: helpOrigin.x,
				                         y: helpOrigin.y+(bounds.height*CGFloat(Double(i)/20.0))-(bounds.height/100))
			} else {
				layer.position = CGPoint(x: helpOrigin.x+letterFrame.width*3/4,
				                         y: helpOrigin.y+(bounds.height*CGFloat(Double(i)/20.0))-(bounds.height/100))
			}
			
			self.layer.addSublayer(layer)
		}
		
	}

}
