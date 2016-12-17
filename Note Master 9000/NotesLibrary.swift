//
//  NotesLibrary.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 29/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import Foundation

enum Clef: String {
	case trebleClef, bassClef
}

enum Note: Int {
	case n1 = 1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19
    case n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32
}

enum Interval: Int {
    case unison = 0, minorSecond, majorSecond, minorThird, majorThird, fourth, tritone, fifth, minorSixth, majorSixth, minorSeventh, majorSeventh, octave // = 12
}

let trebleNotesNameValueDict = [
	"E": 0,
	"D": 1,
	"C": 2,
	"B": 3,
	"A": 4,
	"G": 5,
	"F": 6
]

let bassNotesNameValueDict = [
	"G": 0,
	"F": 1,
	"E": 2,
	"D": 3,
	"C": 4,
	"B": 5,
	"A": 6
]

let trebleClefNotesDict = [
    Note.n1: ("D6", 1),
    Note.n2: ("C#6", 2),
    Note.n3: ("C6", 2),
    Note.n4: ("B5", 3),
    Note.n5: ("A#5", 4),
    Note.n6: ("A5", 4),
    Note.n7: ("G#5", 5),
    Note.n8: ("G5", 5),
    Note.n9: ("F#5", 6),
    Note.n10: ("F5", 6),
    Note.n11: ("E5", 7),
    Note.n12: ("D#5", 8),
    Note.n13: ("D5", 8),
    Note.n14: ("C#5", 9),
    Note.n15: ("C5", 9),
    Note.n16: ("B4", 10),
    Note.n17: ("A#4", 11),
    Note.n18: ("A4", 11),
    Note.n19: ("G#4", 12),
    Note.n20: ("G4", 12),
    Note.n21: ("F#4", 13),
    Note.n22: ("F4", 13),
    Note.n23: ("E4", 14),
    Note.n24: ("D#4", 15),
    Note.n25: ("D4", 15),
    Note.n26: ("C#4", 16),
    Note.n27: ("C4", 16),
    Note.n28: ("B3", 17),
    Note.n29: ("A#3", 18),
    Note.n30: ("A3", 18),
    Note.n31: ("G#3", 19),
    Note.n32: ("G3", 19)
]

let trebleNotesNameDict = [
	Note.n1: "D6",
	Note.n2: "C6",
	Note.n3: "B5",
	Note.n4: "A5",
	Note.n5: "G5",
	Note.n6: "F5",
	Note.n7: "E5",
	Note.n8: "D5",
	Note.n9: "C5",
	Note.n10: "B4",
	Note.n11: "A4",
	Note.n12: "G4",
	Note.n13: "F4",
	Note.n14: "E4",
	Note.n15: "D4",
	Note.n16: "C4",
	Note.n17: "B3",
	Note.n18: "A3",
	Note.n19: "G3"
]

let bassNotesNameDict = [
	Note.n1: "F4",
	Note.n2: "E4",
	Note.n3: "D4",
	Note.n4: "C4",
	Note.n5: "B3",
	Note.n6: "A3",
	Note.n7: "G3",
	Note.n8: "F3",
	Note.n9: "E3",
	Note.n10: "D3",
	Note.n11: "C3",
	Note.n12: "B2",
	Note.n13: "A2",
	Note.n14: "G2",
	Note.n15: "F2",
	Note.n16: "E2",
	Note.n17: "D2",
	Note.n18: "C2",
	Note.n19: "B1"
]
