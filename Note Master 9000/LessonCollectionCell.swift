//
//  LessonCollectionCell.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 02/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class LessonCollectionCell: UICollectionViewCell {
	
	// MARK: Outlets
	
	@IBOutlet weak var lessonImg: UIImageView!
	@IBOutlet weak var lessonTitle: UILabel!
	
	// MARK: Properties
	
	var lesson: noteLesson = noteLesson() {
		didSet {
			setupCell()
		}
	}
	
	// MARK: Initialization
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		//fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Setup/Drawing
	
	private func setupCell() {
		lessonTitle.text = lesson.title
		drawCircle(lesson.complete)
	}
	
	func drawCircle(complete: Bool) {
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
		imgLayer.contents = UIImage(named: lesson.clef.rawValue+"_small")?.CGImage
		imgLayer.contentsGravity = kCAGravityResizeAspect
		
		if complete {
			layer.borderColor = palette.green.dark().CGColor
			layer.backgroundColor = palette.green.trans().CGColor
			layer.cornerRadius = layer.frame.width/2
			lessonTitle.textColor = palette.green.dark()
		} else {
			layer.borderColor = palette.dark.base().CGColor
			layer.backgroundColor = lesson.color.base().CGColor
			layer.cornerRadius = layer.frame.width/2
			lessonTitle.textColor = palette.dark.base()
		}
		
		lessonImg.layer.addSublayer(layer)
		lessonImg.layer.addSublayer(imgLayer)
	}
}
