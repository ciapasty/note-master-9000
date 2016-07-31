//
//  LessonLibrary.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 02/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import Foundation

class Lesson {
	let title: String
	let clef: Clef
	let color: MyColor
	var complete: Bool = false
	
	init(title: String, clef: Clef, color: MyColor) {
		self.title = title
		self.clef = clef
		self.color = color
	}
}

class NoteLesson: Lesson {
	let noteRange: (Int,Int)
	let gauss: Bool
	
	init(title: String, clef: Clef, color: MyColor, fromNote: Note, toNote: Note, gauss: Bool) {
		self.noteRange = (fromNote.rawValue, toNote.rawValue)
		self.gauss = gauss
		
		super.init(title: title, clef: clef, color: color)
	}
}

class TutorialLesson: Lesson {
	let imageNames: [String]
	let imageTexts: [String]
	
	init(title: String, clef: Clef, color: MyColor, images: [String], texts: [String]) {
		self.imageNames = images
		self.imageTexts = texts
		
		super.init(title: title, clef: clef, color: color)
	}
}