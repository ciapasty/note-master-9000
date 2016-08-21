//
//  NotesLibrary.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 29/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import Foundation

enum Note: Int {
	case N1 = 1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19
}

let trebleNotesNameValueDict = [
	"E": 0,
	"D": 1,
	"C": 2,
	"B": 3,
	"A": 4,
	"G": 5,
	"F": 6]

let bassNotesNameValueDict = [
	"G": 0,
	"F": 1,
	"E": 2,
	"D": 3,
	"C": 4,
	"B": 5,
	"A": 6]

let trebleNotesNameDict = [
	Note.N1: "D6",
	Note.N2: "C6",
	Note.N3: "B5",
	Note.N4: "A5",
	Note.N5: "G5",
	Note.N6: "F5",
	Note.N7: "E5",
	Note.N8: "D5",
	Note.N9: "C5",
	Note.N10: "B4",
	Note.N11: "A4",
	Note.N12: "G4",
	Note.N13: "F4",
	Note.N14: "E4",
	Note.N15: "D4",
	Note.N16: "C4",
	Note.N17: "B3",
	Note.N18: "A3",
	Note.N19: "G3"
]

let bassNotesNameDict = [
	Note.N1: "F4",
	Note.N2: "E4",
	Note.N3: "D4",
	Note.N4: "C4",
	Note.N5: "B3",
	Note.N6: "A3",
	Note.N7: "G3",
	Note.N8: "F3",
	Note.N9: "E3",
	Note.N10: "D3",
	Note.N11: "C3",
	Note.N12: "B2",
	Note.N13: "A2",
	Note.N14: "G2",
	Note.N15: "F2",
	Note.N16: "E2",
	Note.N17: "D2",
	Note.N18: "C2",
	Note.N19: "B1"
]