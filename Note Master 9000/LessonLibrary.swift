//
//  LessonLibrary.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 02/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import Foundation

public struct noteLesson {
	let title: String
	let clef: Clef
	let noteRange: (Int,Int)
	let gauss: Bool
	var complete: Bool = false
	
	init(title: String, clef: Clef, fromNote: Note, toNote: Note, gauss: Bool) {
		self.title = title
		self.clef = clef
		self.noteRange = (fromNote.rawValue, toNote.rawValue)
		self.gauss = gauss
	}
	
	init() {
		self.init(title: "", clef: Clef.trebleClef, fromNote: Note.N1, toNote: Note.N1, gauss: true)
	}
}

public let lessonsSections = [
	"Basic Treble Clef",
	"Advanced Treble Clef",
	"Basic Bass Clef",
	"Advanced Bass Clef"]

public var lessons: [[noteLesson]] = [
	[
		noteLesson(title: "Basic", clef: Clef.trebleClef, fromNote: Note.N5, toNote: Note.N15, gauss: true),
		noteLesson(title: "Extended", clef: Clef.trebleClef, fromNote: Note.N1, toNote: Note.N19, gauss: false)
	],
	[
		noteLesson(title: "A B C D E", clef: Clef.trebleClef, fromNote: Note.N7, toNote: Note.N11, gauss: false),
		noteLesson(title: "E F G A B", clef: Clef.trebleClef, fromNote: Note.N10, toNote: Note.N14, gauss: false),
		noteLesson(title: "Full, Lin", clef: Clef.trebleClef, fromNote: Note.N4, toNote: Note.N16, gauss: false),
		noteLesson(title: "A B C D E", clef: Clef.trebleClef, fromNote: Note.N7, toNote: Note.N11, gauss: false),
		noteLesson(title: "E F G A B", clef: Clef.trebleClef, fromNote: Note.N10, toNote: Note.N14, gauss: false),
		noteLesson(title: "Full, Lin", clef: Clef.trebleClef, fromNote: Note.N4, toNote: Note.N16, gauss: false),
		noteLesson(title: "A B C D E", clef: Clef.trebleClef, fromNote: Note.N7, toNote: Note.N11, gauss: false),
		noteLesson(title: "E F G A B", clef: Clef.trebleClef, fromNote: Note.N10, toNote: Note.N14, gauss: false),
		noteLesson(title: "Full, Lin", clef: Clef.trebleClef, fromNote: Note.N4, toNote: Note.N16, gauss: false)
	],
	[
		noteLesson(title: "Basic", clef: Clef.bassClef, fromNote: Note.N4, toNote: Note.N16, gauss: true)
	],
	[
		noteLesson(title: "Upper", clef: Clef.bassClef, fromNote: Note.N1, toNote: Note.N5, gauss: false),
		noteLesson(title: "Lower", clef: Clef.bassClef, fromNote: Note.N14, toNote: Note.N19, gauss: false)
	]
]