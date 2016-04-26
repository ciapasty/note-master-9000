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
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		//fatalError("init(coder:) has not been implemented")
	}
	
	private func setupCell() {
		lessonImg.image = UIImage(named: lesson.clef.rawValue)
		lessonTitle.text = lesson.title
		drawCircle(lesson.complete)
	}
	
	func drawCircle(complete: Bool) {
		lessonImg.layer.sublayers = nil
		
		let layer = CAShapeLayer()
		let green = UIColor(red: 32.0/255.0,
		                    green: 179.0/255.0,
		                    blue: 49.0/255.0,
		                    alpha: 1.0)
		let greenAlpha = UIColor(red: 42.0/255.0,
		                         green: 189.0/255.0,
		                         blue: 59.0/255.0,
		                         alpha: 0.8)
		layer.frame = CGRect(
			x: ((lessonImg.frame.width-lessonImg.frame.height)/2)-5,
			y: -5,
			width: lessonImg.frame.height+10,
		    height: lessonImg.frame.height+10)
		
		layer.borderWidth = 2.0
		
		if complete {
			layer.borderColor = green.CGColor
			layer.backgroundColor = greenAlpha.CGColor
			layer.cornerRadius = layer.frame.width/2
			lessonTitle.textColor = green
		} else {
			layer.borderColor = UIColor.darkGrayColor().CGColor
			layer.cornerRadius = layer.frame.width/2
		}
		
		lessonImg.layer.addSublayer(layer)
	}
}
