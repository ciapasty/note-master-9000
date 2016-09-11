//
//  LessonPlan.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 31/07/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

// MARK: Lesson section names

let lessonsSections = [
	"Basic Treble Clef",
	"Advanced Treble Clef",
	"Basic Bass Clef",
	"Advanced Bass Clef"]

let testTutorialContent = [
	TutorialPageContent(content: NoteTutorial(clef: Clef.trebleClef, notesToDraw: [Note.N12]), text: "This is note G."),
	TutorialPageContent(content: NoteTutorial(clef: Clef.bassClef, notesToDraw: [Note.N8]), text: "This is note F."),
	TutorialPageContent(content: NoteTutorial(clef: nil, notesToDraw: [Note.N10, Note.N16]), text: "Some random text"),
	TutorialPageContent(content: UIImage(named: "gup-vertical"), text: "This is a PUG")
]

// MARK: Lesson plan

var lessons: [[Lesson]] = [
	[
		TutorialLesson(
			index: 1,
			title: "Tutorial",
			description: "A simple tutorial test",
			clef: Clef.trebleClef,
			color: ColorPalette.PeterRiver,
			pages: testTutorialContent),
		NoteLesson(
			index: 2,
			title: "Basic",
			description: "Basic treble clef practice with gauss randomization",
			clef: Clef.trebleClef,
			color: ColorPalette.Orange,
			fromNote: Note.N5, toNote: Note.N15,
			gauss: true),
		NoteLesson(
			index: 3,
			title: "Extended",
			description: "Treble clef practice with full note range and linear randomization",
			clef: Clef.trebleClef,
			color: ColorPalette.BelizeHole,
			fromNote: Note.N1, toNote: Note.N19,
			gauss: false)
	],
	[
		NoteLesson(
			index: 4,
			title: "A B C D E",
			description: "Practice covering only narrow note range",
			clef: Clef.trebleClef,
			color: ColorPalette.Wisteria,
			fromNote: Note.N7, toNote: Note.N11,
			gauss: false),
	],
	[
		NoteLesson(
			index: 5,
			title: "Basic",
			description: "Bass clef practice",
			clef: Clef.bassClef,
			color: ColorPalette.Pomegrante,
			fromNote: Note.N4, toNote: Note.N16,
			gauss: true)
	],
	[
		NoteLesson(
			index: 6,
			title: "Upper",
			description: "Upper range bass clef practice",
			clef: Clef.bassClef,
			color: ColorPalette.GreenSee,
			fromNote: Note.N1, toNote: Note.N5,
			gauss: false),
		NoteLesson(
			index: 7,
			title: "Lower",
			description: "Lower range bass clef practice",
			clef: Clef.bassClef,
			color: ColorPalette.Asbestos,
			fromNote: Note.N14, toNote: Note.N19,
			gauss: false)
	]
]