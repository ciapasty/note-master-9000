//
//  LessonCollectionCell.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 02/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class LessonCollectionCell: UICollectionViewCell {
	
	// MARK: Properties
	
	var clef: Clef?
	var color: UIColor?
	var lesson: Lesson? {
		didSet {
			lessonTitle.text = lesson!.title
			clef = lesson!.clef
			color = lesson!.color
			drawLessonMiniatureLayer(withCompletion: lesson!.complete)
		}
	}
	
	// MARK: Outlets
	
	@IBOutlet weak var lessonImg: UIView!
	@IBOutlet weak var lessonTitle: UILabel!
	
	// MARK: Setup/Drawing
	
	private func drawLessonMiniatureLayer(withCompletion complete: Bool) {
		lessonImg.layer.sublayers = nil
		
		let layer = CAShapeLayer()
		let imgLayer = CALayer()
		
		layer.frame = CGRect(
			x: ((lessonImg.frame.width-lessonImg.frame.height)/2)-5,
			y: -5,
			width: lessonImg.frame.height+10,
		    height: lessonImg.frame.height+10)
		
		layer.borderWidth = 2.0
		
		imgLayer.frame = CGRect(origin: CGPointZero, size: lessonImg.frame.size)
		imgLayer.contents = UIImage(named: clef!.rawValue+"_small")?.CGImage
		imgLayer.contentsGravity = kCAGravityResizeAspect
		
		if complete {
			layer.borderColor = ColorPalette.Nephritis.CGColor
			layer.backgroundColor = ColorPalette.Amethyst.colorWithAlphaComponent(0.7).CGColor
			layer.cornerRadius = layer.frame.width/2
			lessonTitle.textColor = ColorPalette.Nephritis
		} else {
			layer.borderColor = ColorPalette.MidnightBlue.CGColor
			layer.backgroundColor = color!.CGColor
			layer.cornerRadius = layer.frame.width/2
			lessonTitle.textColor = ColorPalette.MidnightBlue
		}
		
		lessonImg.layer.addSublayer(layer)
		lessonImg.layer.addSublayer(imgLayer)
	}
}
