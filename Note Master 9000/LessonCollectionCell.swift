//
//  LessonCollectionCell.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 02/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class LessonCollectionCell: UICollectionViewCell {
	
	@IBOutlet weak var lessonImg: UIImageView!
	@IBOutlet weak var lessonTitle: UILabel!
	
	var lesson: noteLesson = noteLesson() {
		didSet {
			setupCell()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		//fatalError("init(coder:) has not been implemented")
	}
	
	private func setupCell() {
		lessonImg.image = UIImage(named: lesson.clef.rawValue)
		lessonImg.image = lessonImg.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
		lessonImg.tintColor = palette.dark
		
		lessonTitle.text = lesson.title
		drawCircle(lesson.complete)
	}
	
	func drawCircle(complete: Bool) {
		lessonImg.layer.sublayers = nil
		
		let layer = CAShapeLayer()
		
		layer.frame = CGRect(
			x: ((lessonImg.frame.width-lessonImg.frame.height)/2)-5,
			y: -5,
			width: lessonImg.frame.height+10,
		    height: lessonImg.frame.height+10)
		
		layer.borderWidth = 2.0
		
		if complete {
			layer.borderColor = palette.green.CGColor
			layer.backgroundColor = palette.greenTrans.CGColor
			layer.cornerRadius = layer.frame.width/2
			lessonTitle.textColor = palette.green
		} else {
			layer.borderColor = palette.dark.CGColor
			//layer.backgroundColor = palette.blueTrans.CGColor
			lessonImg.backgroundColor = palette.blueTrans
			layer.cornerRadius = layer.frame.width/2
		}
		
		lessonImg.layer.addSublayer(layer)
	}
}
