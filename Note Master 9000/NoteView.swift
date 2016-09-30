//
//  BasicStaffView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 26/09/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

enum StemOrientation {
	case up, down
}

class NoteView: UIView {
	
	var color: UIColor = ColorPalette.MidnightBlue {
		didSet {
			setNeedsDisplay()
		}
	}
	var stem: StemOrientation?
	
	private struct Constants {
		static let NoteBodyLineWidth: CGFloat = 1.0
		static let NoteStemLineWidth: CGFloat = 2.0
		static let StaffHorizontalLinesWidth: CGFloat = 1.0
		static let GhostNoteAnimationDuration: Double = 0.5
	}
	
	override func draw(_ rect: CGRect) {
		layer.sublayers = nil
		// Background fill
		ColorPalette.Clouds.set()
		UIBezierPath(rect: rect).fill()
		
		if stem != nil {
			ColorPalette.MidnightBlue.set()
			let stemPath = UIBezierPath()
			
			switch stem! {
			case .up:
				let noteRect = CGRect(x: 0, y: rect.height*3/4, width: rect.width, height: rect.height/4)
				drawNoteCircle(inRect: noteRect)
				stemPath.move(to: CGPoint(x: rect.width, y: 0))
				stemPath.addLine(to: CGPoint(x: rect.width, y: rect.height*7/8))
			case .down:
				let noteRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height/4)
				drawNoteCircle(inRect: noteRect)
				stemPath.move(to: CGPoint(x: 0, y: rect.height*1/8))
				stemPath.addLine(to: CGPoint(x: 0, y: rect.height))
			}
			
			stemPath.stroke()
		}
	}
	
	private func drawNoteCircle(inRect rect: CGRect) {
		// MARK: TODO -> tilted circle
		let notePath = UIBezierPath(ovalIn: rect)
		notePath.fill()
	}
}
