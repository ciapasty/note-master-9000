//
//  LessonPlan.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 31/07/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import Foundation

// MARK: Lesson section names

let lessonsSections = [
	"Basic Treble Clef",
	"Advanced Treble Clef",
	"Basic Bass Clef",
	"Advanced Bass Clef"]

// MARK: Lesson plan

var lessons: [[Lesson]] = [
	[
		TutorialLesson(title: "Tutorial", clef: Clef.trebleClef, color: palette.blue, images: ["trebleClef", "bassClef"], texts: ["This is treble clef", "This is a bass clef"]),
		NoteLesson(title: "Basic", clef: Clef.trebleClef, color: palette.blue, fromNote: Note.N5, toNote: Note.N15, gauss: true),
		NoteLesson(title: "Extended", clef: Clef.trebleClef, color: palette.red, fromNote: Note.N1, toNote: Note.N19, gauss: false)
	],
	[
		NoteLesson(title: "A B C D E", clef: Clef.trebleClef, color: palette.green, fromNote: Note.N7, toNote: Note.N11, gauss: false),
	],
	[
		NoteLesson(title: "Basic", clef: Clef.bassClef, color: palette.orange, fromNote: Note.N4, toNote: Note.N16, gauss: true)
	],
	[
		NoteLesson(title: "Upper", clef: Clef.bassClef, color: palette.purple, fromNote: Note.N1, toNote: Note.N5, gauss: false),
		NoteLesson(title: "Lower", clef: Clef.bassClef, color: palette.yellow, fromNote: Note.N14, toNote: Note.N19, gauss: false)
	]
]