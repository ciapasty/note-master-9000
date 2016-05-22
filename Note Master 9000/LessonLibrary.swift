//
//  LessonLibrary.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 02/04/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit
import Foundation

// MARK: Lesson structure

public struct noteLesson {
	let title: String
	let clef: Clef
	let noteRange: (Int,Int)
	let gauss: Bool
	let color: MyColor
	var complete: Bool = false
	
	init(title: String, clef: Clef, fromNote: Note, toNote: Note, gauss: Bool, color: MyColor) {
		self.title = title
		self.clef = clef
		self.noteRange = (fromNote.rawValue, toNote.rawValue)
		self.gauss = gauss
		self.color = color
	}
	
	init() {
		self.init(title: "", clef: Clef.trebleClef, fromNote: Note.N1, toNote: Note.N1, gauss: true, color: palette.blue)
	}
}

// MARK: Lesson section names

public let lessonsSections = [
	"Basic Treble Clef",
	"Advanced Treble Clef",
	"Basic Bass Clef",
	"Advanced Bass Clef"]

// MARK: Lesson plan

public var lessons: [[noteLesson]] = [
	[
		noteLesson(title: "Basic", clef: Clef.trebleClef, fromNote: Note.N5, toNote: Note.N15, gauss: true, color: palette.blue),
		noteLesson(title: "Extended", clef: Clef.trebleClef, fromNote: Note.N1, toNote: Note.N19, gauss: false, color: palette.red)
	],
	[
		noteLesson(title: "A B C D E", clef: Clef.trebleClef, fromNote: Note.N7, toNote: Note.N11, gauss: false, color: palette.green),
	],
	[
		noteLesson(title: "Basic", clef: Clef.bassClef, fromNote: Note.N4, toNote: Note.N16, gauss: true, color: palette.orange)
	],
	[
		noteLesson(title: "Upper", clef: Clef.bassClef, fromNote: Note.N1, toNote: Note.N5, gauss: false, color: palette.purple),
		noteLesson(title: "Lower", clef: Clef.bassClef, fromNote: Note.N14, toNote: Note.N19, gauss: false, color: palette.yellow)
	]
]