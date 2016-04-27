//
//  HelpDrawingView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 10/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class HelpDrawingView: UIImageView {

	let trebleHelp = ["E", "D", "C", "B", "A", "G", "F"]
	let bassHelp = ["G", "F", "E", "D", "C", "B", "A"]
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		
		self.backgroundColor = UIColor(white: 1, alpha: 0.7)
	}
	
	/*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	func drawHelp(clef: Clef) {
		
		for i in 6...12 {
			let layer = CATextLayer()
			
			layer.frame = self.frame
			layer.contentsScale = UIScreen.mainScreen().scale
			layer.font = UIFont.systemFontOfSize(1, weight: UIFontWeightLight)
			layer.fontSize = self.frame.height/10
			
			layer.shadowOffset = CGSize(width: 1, height: 1)
			layer.shadowColor = UIColor.whiteColor().CGColor
			layer.shadowRadius = 2.0
			layer.shadowOpacity = 0.8
			
			if clef == Clef.trebleClef {
				layer.string = trebleHelp[i-6]
			} else if clef == Clef.bassClef {
				layer.string = bassHelp[i-6]
			}
			
			layer.foregroundColor = UIColor.blackColor().CGColor
			
			if i % 2 == 0 {
				layer.position = CGPoint(x: (self.bounds.width*11/20),
				                         y: (self.bounds.height/2)+(self.bounds.height*CGFloat(Double(i)/20.0))-(self.frame.height/100))
			} else {
				layer.position = CGPoint(x: (self.bounds.width*19/20),
				                         y: (self.bounds.height/2)+(self.bounds.height*CGFloat(Double(i)/20.0))-(self.frame.height/100))
			}
			
			
			self.layer.addSublayer(layer)
		}
		
	}

}
