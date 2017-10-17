//
//  StaffDrawingView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 28/09/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class StaffDrawingView: UIView {
	
	// MARK: Constants
	
	private struct Constants {
		static let NoteBodyLineWidth: CGFloat = 1.0
		static let NoteStemLineWidth: CGFloat = 2.0
		static let GhostNoteAnimationDuration: Double = 0.5
		static let StaffVerticalLinesWidth: CGFloat = 3.0
		static let StaffHorizontalLinesWidth: CGFloat = 1.0
		static let StaffVerticalLinesAnimationDuration: Double = 0.56
		static let StaffHorizontalLinesAnimationDuration: Double = 0.7
	}
    
	// MARK: Note Drawing
	
	func drawNotes(_ notes: [Note]){
		layer.sublayers = nil
		for (index, note) in notes.enumerated() {
			let noteLayer = CALayer()
			var noteRect = getRect(for: note)
			let noteDistance = ((bounds.width*3/4) / CGFloat(notes.count+1))
			
			noteRect.origin.x = (bounds.width/5) + (noteDistance*CGFloat(index+1))
			
			noteLayer.addSublayer(drawNoteLayer(note, noteRect: noteRect, color: ColorPalette.MidnightBlue))
			noteLayer.addSublayer(drawNoteStem(note, noteRect: noteRect, color: ColorPalette.MidnightBlue))
			
			layer.addSublayer(drawAddLines(for: note, at: noteRect.origin.x))
			layer.addSublayer(noteLayer)
		}
	}
	
	private func drawNoteLayer(_ note: Note, noteRect: CGRect, color: UIColor) -> CALayer {
		let notePath = UIBezierPath(ovalIn: CGRect(x: 0-noteRect.width/2, y: 0-noteRect.height/2, width: noteRect.width, height: noteRect.height))
		let noteLayer = CAShapeLayer()
		
		var rotation:CATransform3D = noteLayer.transform
		rotation = CATransform3DRotate(rotation, 0.4, 0.0, 0.0, -1.0)
		noteLayer.transform = rotation
		noteLayer.position = CGPoint(x: noteRect.origin.x+noteRect.width/2, y: (frame.height*CGFloat(Double(note.rawValue)/20.0)))
		
		noteLayer.path = notePath.cgPath
		noteLayer.lineWidth = Constants.NoteBodyLineWidth
		noteLayer.strokeColor = color.cgColor
		noteLayer.fillColor = color.cgColor
		
		return noteLayer
	}
	
	private func drawNoteStem(_ note: Note, noteRect: CGRect, color: UIColor) -> CALayer {
		let noteStemPath = UIBezierPath()
		let noteStemLayer = CAShapeLayer()
		
		if note.rawValue < 10 {
			noteStemPath.move(to: CGPoint(x: noteRect.origin.x+1.5, y: noteRect.origin.y+noteRect.height/1.5))
			noteStemPath.addLine(to: CGPoint(x: noteRect.origin.x+1.5, y: (noteRect.origin.y+noteRect.height/1.5)+(frame.height*3.4/10)))
		} else {
			noteStemPath.move(to: CGPoint(x: noteRect.origin.x+noteRect.width-1.5, y: noteRect.origin.y+noteRect.height/2.5))
			noteStemPath.addLine(to: CGPoint(x: noteRect.origin.x+noteRect.width-1.5, y: (noteRect.origin.y+noteRect.height/2.5)-(frame.height*3.4/10)))
		}
		
		noteStemLayer.path = noteStemPath.cgPath
		noteStemLayer.lineWidth = Constants.NoteStemLineWidth
		noteStemLayer.strokeColor = color.cgColor
		
		return noteStemLayer
	}
	
	private func getRect(for note: Note) -> CGRect {
		let noteHeight = frame.height/12
		let noteWidth = noteHeight*1.5
		
		let noteDistance = ((bounds.width*3/4) / 2)
		
		let noteRect = CGRect(
			x: (bounds.width/5) + noteDistance,
			y: (frame.height*CGFloat(Double(note.rawValue)/20.0))-(noteHeight/2),
			width: noteWidth, height: noteHeight)
		return noteRect
	}
	
	private func drawAddLines(for note: Note, at width: CGFloat) -> CALayer {
		let lineWidth = bounds.width/5
		let noteWidth = bounds.height/8
		let lineStart = width + (noteWidth/2) - lineWidth/2
		let lineEnd = width + (noteWidth/2) + lineWidth/2
		let linePath = UIBezierPath()
		let lineLayer = CAShapeLayer()
		
		if note.rawValue > 15 {
			linePath.move(to: CGPoint(x: lineStart, y: bounds.height*8/10))
			linePath.addLine(to: CGPoint(x: lineEnd, y: bounds.height*8/10))
			if note.rawValue > 17 {
				linePath.move(to: CGPoint(x: lineStart, y: bounds.height*9/10))
				linePath.addLine(to: CGPoint(x: lineEnd, y: bounds.height*9/10))
			}
		}
		
		if note.rawValue < 5 {
			linePath.move(to: CGPoint(x: lineStart, y: bounds.height*2/10))
			linePath.addLine(to: CGPoint(x: lineEnd, y: bounds.height*2/10))
			if note.rawValue < 3 {
				linePath.move(to: CGPoint(x: lineStart, y: bounds.height/10))
				linePath.addLine(to: CGPoint(x: lineEnd, y: bounds.height/10.0))
			}
		}
		
		lineLayer.path = linePath.cgPath
		lineLayer.lineWidth = Constants.StaffHorizontalLinesWidth
		lineLayer.strokeColor = ColorPalette.MidnightBlue.cgColor
		return lineLayer
	}
	
	// MARK: Ghost note drawing
	
	func drawGhostNote(_ note: Note, progress: Float) {
		let layer = CALayer()
		
		layer.frame = frame
		
		layer.addSublayer(drawNoteLayer(note, noteRect: getRect(for: note), color: ColorPalette.Nephritis.withAlphaComponent(0.7)))
		layer.addSublayer(drawNoteStem(note, noteRect: getRect(for: note), color: ColorPalette.Nephritis.withAlphaComponent(0.7)))
		
		self.layer.addSublayer(layer)
		
		let anim = CAKeyframeAnimation(keyPath: "position")
		anim.path = drawGhostPath(progress).cgPath
		anim.duration = Constants.GhostNoteAnimationDuration
		
		var scaling:CATransform3D = layer.transform
		scaling = CATransform3DScale(scaling, 0.01, 0.01, 1.0)
		let scale = CABasicAnimation(keyPath: "transform")
		scale.duration = Constants.GhostNoteAnimationDuration
		scale.toValue = NSValue.init(caTransform3D: scaling)
		
		layer.add(scale, forKey: "transformAnimation")
		layer.add(anim, forKey: "animate position along path")
		
	}
	
	private func drawGhostPath(_ progress: Float) -> UIBezierPath {
		//let layer = CAShapeLayer()
		let bezierStart = CGPoint(x: frame.width/2,
		                          y: frame.height/2)
		let bezierEnd = CGPoint(x: frame.width*CGFloat(progress),
		                        y: 0)
		let control = CGPoint(x: frame.width/2, y: 0)
		let path = UIBezierPath()
		
		path.move(to: bezierStart)
		path.addQuadCurve(to: bezierEnd, controlPoint: control)
		
		return path
	}
	
	// MARK: Staff Drawing
	
	func drawStaff(withClef clef: Clef?, animated anim: Bool) {
		layer.sublayers = nil
		let staffLayer = CALayer()
		staffLayer.addSublayer(drawStaffLayer(anim))
		if (clef != nil) {
			staffLayer.addSublayer(drawClefLayer(clef!))
		}
		layer.addSublayer(staffLayer)
	}
	
	private func drawStaffLayer(_ animated: Bool) -> CALayer {
		
		let staffPathH = UIBezierPath()
		let staffPathV = UIBezierPath()
		let staffLayerH = CAShapeLayer()
		let staffLayerV = CAShapeLayer()
		let staffLayer = CALayer()
		
		// Horizontal lines
		for i in 3...7 {
			staffPathH.move(to: CGPoint(x: frame.width/20, y: frame.height*CGFloat(Double(i)/10.0)))
			staffPathH.addLine(to: CGPoint(x: frame.width*19/20, y: frame.height*CGFloat(Double(i)/10.0)))
		}
		
		staffLayerH.path = staffPathH.cgPath
		staffLayerH.lineWidth = Constants.StaffHorizontalLinesWidth
		staffLayerH.strokeColor = ColorPalette.MidnightBlue.cgColor
		
		staffLayer.addSublayer(staffLayerH)
		
		// Horizontal line animation
		if animated {
			let animateHorizontal = CABasicAnimation(keyPath: "strokeEnd")
			animateHorizontal.duration = Constants.StaffHorizontalLinesAnimationDuration
			animateHorizontal.fromValue = 0.0
			animateHorizontal.toValue = 1.0
			staffLayerH.add(animateHorizontal, forKey: "animate stroke end animation")
		}
		
		// Vertical line
		staffPathV.move(to: CGPoint(x: frame.width/20, y: frame.height*3/10-0.5))
		staffPathV.addLine(to: CGPoint(x: frame.width/20, y: frame.height*7/10+0.5))
		
		staffLayerV.path = staffPathV.cgPath
		staffLayerV.lineWidth = Constants.StaffVerticalLinesWidth
		staffLayerV.strokeColor = ColorPalette.MidnightBlue.cgColor
		
		staffLayer.addSublayer(staffLayerV)
		
		// Vertical lines animation
		if animated {
			let animateVertical = CABasicAnimation(keyPath: "strokeEnd")
			animateVertical.duration = Constants.StaffVerticalLinesAnimationDuration
			animateVertical.fromValue = 0.0
			animateVertical.toValue = 1.0
			staffLayerV.add(animateVertical, forKey: "animate stroke end animation")
		}
		
		return staffLayer
	}
	
	// MARK: Clef drawing
	
	private func drawClefLayer (_ clef: Clef) -> CALayer {
		let clefLayer = CALayer()
		
		let height = CGFloat(frame.height*0.68)
		let posX = CGFloat(frame.width*0.045)
		let posY = CGFloat(5+(frame.height-height)/2)
		
		clefLayer.frame = CGRect(x: posX, y: posY, width: height*0.48, height: height)
		clefLayer.contents = UIImage(named: clef.rawValue)?.cgImage
		clefLayer.contentsGravity = kCAGravityResizeAspect
		
		return clefLayer
	}
}
