//
//  StaffView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 30/09/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class StaffView: UIView {
	
	var clef: Clef? {
		didSet {
			setNeedsDisplay()
		}
	}
	var notes: [Note]? {
		didSet {
			setNeedsDisplay()
		}
	}
	
	private struct Constants {
		static let StaffVerticalLinesWidth: CGFloat = 3.0
		static let StaffHorizontalLinesWidth: CGFloat = 1.0
		static let StaffVerticalLinesAnimationDuration: Double = 0.56
		static let StaffHorizontalLinesAnimationDuration: Double = 0.7
		static let GhostNoteAnimationDuration: Double = 0.5
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	convenience init(frame: CGRect, withClef clef: Clef?, withNotes notes: [Note]?) {
		self.init(frame: frame)
		self.clef = clef
		self.notes = notes
	}

    override func draw(_ rect: CGRect) {
		layer.sublayers = nil
		// Background fill
		ColorPalette.Clouds.set()
		UIBezierPath(rect: rect).fill()
		
		let staffPathH = UIBezierPath()
		let staffPathV = UIBezierPath()
		
		
		
		staffPathH.lineWidth = Constants.StaffHorizontalLinesWidth
		staffPathV.lineWidth = Constants.StaffVerticalLinesWidth
		
		for i in 3...7 {
			staffPathH.move(to: CGPoint(x: frame.width/20, y: frame.height*CGFloat(Double(i)/10.0)))
			staffPathH.addLine(to: CGPoint(x: frame.width*19/20, y: frame.height*CGFloat(Double(i)/10.0)))
		}
		
		staffPathV.move(to: CGPoint(x: frame.width/20, y: frame.height*3/10-0.5))
		staffPathV.addLine(to: CGPoint(x: frame.width/20, y: frame.height*7/10+0.5))
		
		ColorPalette.MidnightBlue.set()
		staffPathH.stroke()
		staffPathV.stroke()
		
		if clef != nil {
			layer.addSublayer(drawClefLayer(clef!))
		}
		
		if let notes = self.notes {
			if notes.count != 0 {
				for (index, note) in notes.enumerated() {
					var noteOrigin = CGPoint()
					let noteWidth = rect.height/10
					let noteDistance = ((rect.width*2/3) / CGFloat(notes.count+1)) - noteWidth/2
					
					noteOrigin.x = (rect.width/3) + (noteDistance*CGFloat(index+1))
					
					if note.rawValue < 10 {
						noteOrigin.y = rect.height*CGFloat(Double(note.rawValue)-1)/20.0
						let noteRect = CGRect(origin: noteOrigin, size: CGSize(width: noteWidth, height: rect.height*2/5))
						let noteView = NoteView(frame: noteRect, withStemPointing: .down)
						self.addSubview(noteView)
					} else {
						noteOrigin.y = rect.height*CGFloat(Double(note.rawValue)-7)/20.0
						let noteRect = CGRect(origin: noteOrigin, size: CGSize(width: noteWidth, height: rect.height*2/5))
						let noteView = NoteView(frame: noteRect, withStemPointing: .up)
						self.addSubview(noteView)
					}
				}
			}
		}
    }

	private func drawClefLayer (_ clef: Clef) -> CALayer {
		let clefLayer = CALayer()
		
		let height = CGFloat(frame.height*0.68)
		let posX = CGFloat(frame.width*0.05)
		let posY = CGFloat(5+(frame.height-height)/2)
		
		clefLayer.frame = CGRect(x: posX, y: posY, width: height*0.48, height: height)
		clefLayer.contents = UIImage(named: clef.rawValue)?.cgImage
		clefLayer.contentsGravity = kCAGravityResizeAspect
		
		return clefLayer
	}
}
