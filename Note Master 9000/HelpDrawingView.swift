//
//  HelpDrawingView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 10/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class HelpDrawingView: UIImageView {

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		
		let layer = CATextLayer()
		
		layer.string = "ASDF"
		layer.font = UIFont(name: "Helvetica", size: 50)
		layer.foregroundColor = UIColor.blackColor().CGColor
		
		self.layer.addSublayer(layer)
		
	}
	
	/*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
