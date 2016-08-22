//
//  HelpDrawingView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 10/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class HelpDrawingView: UIView {
	
	// MARK: Properties

	let trebleHelp = ["E", "D", "C", "B", "A", "G", "F"]
	let bassHelp = ["G", "F", "E", "D", "C", "B", "A"]
	
	// MARK: Initialization
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		
		self.backgroundColor = palette.light.trans()
	}
	
	/*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	// MARK: Drawing
	
	func drawHelp(clef: Clef) {
		
		let letterFrame = CGRect(x: self.bounds.origin.x,
		                         y: self.bounds.origin.y,
		                         width: self.bounds.height/10,
		                         height: self.bounds.height/10)
		
		let helpOrigin = CGPoint(x: self.bounds.origin.x+letterFrame.width/2,
		                         y: self.bounds.origin.y+letterFrame.height/2)
		
		for i in 6...12 {
			let layer = CATextLayer()
			
			layer.frame = letterFrame
			layer.contentsScale = UIScreen.mainScreen().scale
			layer.alignmentMode = kCAAlignmentCenter
			layer.font = UIFont.systemFontOfSize(1, weight: UIFontWeightLight)
			layer.fontSize = self.frame.height/10
			
			if clef == Clef.trebleClef {
				layer.string = trebleHelp[i-6]
			} else if clef == Clef.bassClef {
				layer.string = bassHelp[i-6]
			}
			
			layer.foregroundColor = palette.dark.base().CGColor
			
			if i % 2 == 0 {
				layer.position = CGPoint(x: helpOrigin.x,
				                         y: helpOrigin.y+(self.bounds.height*CGFloat(Double(i)/20.0))-(self.bounds.height/100))
			} else {
				layer.position = CGPoint(x: helpOrigin.x+letterFrame.width*3/4,
				                         y: helpOrigin.y+(self.bounds.height*CGFloat(Double(i)/20.0))-(self.bounds.height/100))
			}
			
			self.layer.addSublayer(layer)
		}
		
	}

}
