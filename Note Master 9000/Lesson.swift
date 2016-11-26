//
//  LessonLibrary.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 02/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

enum LessonState: String {
	case new, opened, finished, infinite
}

class Lesson {
	let index: Int
	let title: String
	let description: String
	let clef: Clef?
	let color: UIColor
	var state: LessonState?
	
    init(index: Int, title: String, description: String, clef: Clef?, color: UIColor, state: LessonState? = nil) {
		self.index = index
		self.title = title
		self.description = description
		self.clef = clef
		self.color = color
        self.state = state
	}
}

class NoteLesson: Lesson {
	let noteSet: [Note]?
	let gauss: Bool
	
	init(index: Int, title: String, description: String, clef: Clef?, color: UIColor, noteSet: [Note]?, gauss: Bool, state: LessonState? = nil) {
		self.noteSet = noteSet
		self.gauss = gauss
		
        super.init(index: index, title: title, description: description, clef: clef, color: color, state: state)
	}
}

class TutorialLesson: Lesson {
	let pages: [TutorialPageContent]
	
	init(index: Int, title: String, description: String, clef: Clef?, color: UIColor, pages: [TutorialPageContent], state: LessonState? = nil) {
		self.pages = pages
		
		super.init(index: index, title: title, description: description, clef: clef, color: color, state: state)
	}
}

class IntervalLesson: Lesson {
    let intervalSet: [Interval]?
    
    init(index: Int, title: String, description: String, clef: Clef?, color: UIColor, intervalSet: [Interval]?, state: LessonState? = nil) {
        self.intervalSet = intervalSet
        
        super.init(index: index, title: title, description: description, clef: clef, color: color, state: state)
    }
}

class TutorialPageContent {
	let content: AnyObject?
	let text: String
	
	init (content: AnyObject?, text: String) {
		self.content = content
		self.text = text
	}
}

class NoteTutorial {
	let clef: Clef?
	let notesToDraw: [Note]
	
	init(clef: Clef?, notesToDraw: [Note]) {
		self.clef = clef
		self.notesToDraw = notesToDraw
	}
}
