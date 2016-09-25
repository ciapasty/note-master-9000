//
//  LessonCollectionCell.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 02/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class LessonCollectionCell: UICollectionViewCell {
	
	// MARK: Model
	
	var lesson: Lesson? {
		didSet {
			lessonTitle.text = lesson!.title
			lessonTitle.textColor = ColorPalette.MidnightBlue
			lessonImg.lesson = lesson
		}
	}
	
	// MARK: Outlets
	
	@IBOutlet weak var lessonImg: LessonMiniature!
	@IBOutlet weak var lessonTitle: UILabel!
	
}
