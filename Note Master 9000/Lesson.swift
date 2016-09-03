//
//  LessonLibrary.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 02/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class Lesson {
	let title: String
	let description: String
	let clef: Clef
	let color: UIColor
	var complete: Bool = false
	
	init(title: String, description: String, clef: Clef, color: UIColor) {
		self.title = title
		self.description = description
		self.clef = clef
		self.color = color
	}
}

class NoteLesson: Lesson {
	let noteRange: (Int,Int)
	let gauss: Bool
	
	init(title: String, description: String, clef: Clef, color: UIColor, fromNote: Note, toNote: Note, gauss: Bool) {
		self.noteRange = (fromNote.rawValue, toNote.rawValue)
		self.gauss = gauss
		
		super.init(title: title, description: description, clef: clef, color: color)
	}
}

class TutorialLesson: Lesson {
	let imageNames: [String]
	let imageTexts: [String]
	
	init(title: String, description: String, clef: Clef, color: UIColor, images: [String], texts: [String]) {
		self.imageNames = images
		self.imageTexts = texts
		
		super.init(title: title, description: description, clef: clef, color: color)
	}
}