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
	"Random Section 1",
	"Section 2: CC",
	"Basic Bass Clef",
	"Advanced Bass Clef",
    "Generated Lessons"
]

// MARK: Tutorials content

let testTutorialContent = [
	TutorialPageContent(content: NoteTutorial(clef: Clef.trebleClef, notesToDraw: [Note.n12]), text: "This is note G4."),
	TutorialPageContent(content: NoteTutorial(clef: Clef.trebleClef, notesToDraw: [Note.n8, Note.n18]), text: "This is note D5 and A3"),
	TutorialPageContent(content: NoteTutorial(clef: Clef.trebleClef, notesToDraw: [Note.n12, Note.n11, Note.n10, Note.n9]), text: "G4, A4, B4, C5"),
	TutorialPageContent(content: NoteTutorial(clef: Clef.bassClef, notesToDraw: [Note.n12, Note.n11, Note.n10, Note.n9]), text: "B2, C3, D3, E3"),
	TutorialPageContent(content: UIImage(named: "gup-vertical"), text: "This is a PUG")
]

// MARK: Lesson plan

var lessons: [[Lesson]] = [
	[
		TutorialLesson(
			index: 1,
			title: "Tutorial",
			description: "A simple tutorial test",
			clef: nil,
			color: ColorPalette.PeterRiver,
			pages: testTutorialContent),
		NoteLesson(
			index: 2,
			title: "G4 to G5",
			description: "One octave from G4 to G5, with gaussian randomisation",
			clef: Clef.trebleClef,
			color: ColorPalette.Orange,
			noteSet: notesInRange(from: Note.n5, to: Note.n12),
			gauss: true),
		NoteLesson(
			index: 3,
			title: "G4 to G5",
			description: "One octave from G4 to G5, with liniear randomisation",
			clef: Clef.trebleClef,
			color: ColorPalette.BelizeHole,
			noteSet: notesInRange(from: Note.n5, to: Note.n12),
			gauss: false)
	],
	[
		NoteLesson(
			index: 4,
			title: "CC",
			description: "Only C present on extended clef",
			clef: Clef.trebleClef,
			color: ColorPalette.Amethyst,
			noteSet: [Note.n2, Note.n9, Note.n16],
			gauss: false),
	],
	[
		NoteLesson(
			index: 5,
			title: "Basic",
			description: "Bass clef practice",
			clef: Clef.bassClef,
			color: ColorPalette.Pomegrante,
			noteSet: notesInRange(from: Note.n4, to: Note.n16),
			gauss: true)
	],
	[
		NoteLesson(
			index: 6,
			title: "Upper",
			description: "Upper range bass clef practice",
			clef: Clef.bassClef,
			color: ColorPalette.GreenSee,
			noteSet: notesInRange(from: Note.n1, to: Note.n5),
			gauss: false),
		NoteLesson(
			index: 7,
			title: "Lower",
			description: "Lower range bass clef practice",
			clef: Clef.bassClef,
			color: ColorPalette.Asbestos,
			noteSet: notesInRange(from: Note.n14, to: Note.n19),
			gauss: false),
        NoteLesson(
            index: 8,
            title: "Tests",
            description: "Some meaningless description",
            clef: Clef.trebleClef,
            color: ColorPalette.Carrot,
            noteSet: notesInRange(from: Note.n14, to: Note.n19),
            gauss: true)
	],
	[
        NoteLesson(
            index: 9,
            title: "10 worst",
            description: "10 worst notes from treble clef",
            clef: Clef.trebleClef,
            color: ColorPalette.Torquoise,
            noteSet: nil,
            gauss: true),
        NoteLesson(
            index: 10,
            title: "10 worst",
            description: "10 worst notes from bass clef",
            clef: Clef.bassClef,
            color: ColorPalette.SunFlower,
            noteSet: nil,
            gauss: true)
    ]
]


func notesInRange(from: Note, to: Note) -> [Note] {
	var noteSet = [Note]()
	for i in from.rawValue...to.rawValue {
		noteSet.append(Note(rawValue: i)!)
	}
	return noteSet
}
