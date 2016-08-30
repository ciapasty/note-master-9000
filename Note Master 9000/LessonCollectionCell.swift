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
	
	// Mark: Constants
	
	private struct Constants {
		static let LessonIconLayerVerticalMargin: CGFloat = 5.0
		static let LessonIconLayerHorizontalMargin: CGFloat = 10
		static let LessonIconLayerBorderWidth: CGFloat = 3.0
		static let LassonIconLayerBackgroundAlpha: CGFloat = 0.5
	}
	
	// MARK: Setup/Drawing
	
	private func drawLessonMiniatureLayer(withCompletion complete: Bool) {
		lessonImg.layer.sublayers = nil
		
		let layer = CAShapeLayer()
		let imgLayer = CALayer()
		
		layer.frame = CGRect(
			x: ((lessonImg.frame.width-lessonImg.frame.height)/2)-Constants.LessonIconLayerVerticalMargin,
			y: -Constants.LessonIconLayerVerticalMargin,
			width: lessonImg.frame.height+Constants.LessonIconLayerHorizontalMargin,
		    height: lessonImg.frame.height+Constants.LessonIconLayerHorizontalMargin)
		
		layer.borderWidth = Constants.LessonIconLayerBorderWidth
		layer.borderColor = color!.CGColor
		layer.backgroundColor = color!.colorWithAlphaComponent(Constants.LassonIconLayerBackgroundAlpha).CGColor
		layer.cornerRadius = layer.frame.width/2
		lessonTitle.textColor = ColorPalette.MidnightBlue
		
		imgLayer.frame = CGRect(origin: CGPointZero, size: lessonImg.frame.size)
		imgLayer.contents = UIImage(named: clef!.rawValue+"_small")?.CGImage
		imgLayer.contentsGravity = kCAGravityResizeAspect
		
		
		if complete {
			// TODO: Add completion sing to lesson icon
		}
		
		lessonImg.layer.addSublayer(layer)
		lessonImg.layer.addSublayer(imgLayer)
	}
}
