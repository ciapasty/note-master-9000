//
//  StaffImageView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 22/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class StaffDrawingView: UIView {
	
	// MARK: Note Drawing
	
	func drawNote(note: Note, color: UIColor, animated: Bool){
		self.layer.sublayers = nil
		
		let noteHeight = self.frame.height/12
		let noteWidth = noteHeight*1.5
		let noteRect = CGRect(
			x: (self.frame.width*3/5)-(noteWidth/2),
			y: (self.frame.height*CGFloat(Double(note.rawValue)/20.0))-(noteHeight/2),
			width: noteWidth, height: noteHeight)
		
		self.layer.addSublayer(drawAddLines(note))
		self.layer.addSublayer(drawNoteLayer(note, noteRect: noteRect, color: color))
	}
	
	func drawNoteLayer(note: Note, noteRect: CGRect, color: UIColor) -> CALayer {
		let notePath = UIBezierPath(ovalInRect: CGRect(x: 0-noteRect.width/2, y: 0-noteRect.height/2, width: noteRect.width, height: noteRect.height))
		let noteLayer = CAShapeLayer()
		
		var rotation:CATransform3D = noteLayer.transform
		rotation = CATransform3DRotate(rotation, 0.4, 0.0, 0.0, -1.0)
		noteLayer.transform = rotation
		noteLayer.position = CGPointMake(self.frame.width*3/5, (self.frame.height*CGFloat(Double(note.rawValue)/20.0)))
		
		noteLayer.path = notePath.CGPath
		noteLayer.lineWidth = 1.0
		noteLayer.strokeColor = color.CGColor
		noteLayer.fillColor = color.CGColor
		
		return noteLayer
	}
	
	func drawNoteStem(note: Note, noteRect: CGRect, color: UIColor) -> CALayer {
		let noteStemPath = UIBezierPath()
		let noteStemLayer = CAShapeLayer()
		
		if note.rawValue < 10 {
			noteStemPath.moveToPoint(CGPointMake(noteRect.origin.x+1.5, noteRect.origin.y+noteRect.height/1.5))
			noteStemPath.addLineToPoint(CGPointMake(noteRect.origin.x+1.5, (noteRect.origin.y+noteRect.height/1.5)+(self.frame.height*3.4/10)))
		} else {
			noteStemPath.moveToPoint(CGPointMake(noteRect.origin.x+noteRect.width-1.5, noteRect.origin.y+noteRect.height/2.5))
			noteStemPath.addLineToPoint(CGPointMake(noteRect.origin.x+noteRect.width-1.5, (noteRect.origin.y+noteRect.height/2.5)-(self.frame.height*3.4/10)))
		}
		
		noteStemLayer.path = noteStemPath.CGPath
		noteStemLayer.lineWidth = 2.0
		noteStemLayer.strokeColor = color.CGColor
		
		return noteStemLayer
	}
	
	func drawAddLines(note : Note) -> CALayer {

		let lineStart = self.frame.width/2
		let lineEnd = self.frame.width*7/10
		let linePath = UIBezierPath()
		let lineLayer = CAShapeLayer()
		
		if note.rawValue < 5 {
			linePath.moveToPoint(CGPointMake(lineStart, self.frame.height*2/10))
			linePath.addLineToPoint(CGPointMake(lineEnd, self.frame.height*2/10))
			if note.rawValue < 3 {
				linePath.moveToPoint(CGPointMake(lineStart, self.frame.height/10))
				linePath.addLineToPoint(CGPointMake(lineEnd, self.frame.height/10.0))
			}
		}
		
		if note.rawValue > 15 {
			linePath.moveToPoint(CGPointMake(lineStart, self.frame.height*8/10))
			linePath.addLineToPoint(CGPointMake(lineEnd, self.frame.height*8/10))
			if note.rawValue > 17 {
				linePath.moveToPoint(CGPointMake(lineStart, self.frame.height*9/10))
				linePath.addLineToPoint(CGPointMake(lineEnd, self.frame.height*9/10))
			}
		}
		
		lineLayer.path = linePath.CGPath
		lineLayer.lineWidth = 1.0
		lineLayer.strokeColor = palette.dark.base().CGColor
		return lineLayer
		
	}
	
	// MARK: Ghost note drawing
	
	func drawGhostNote(note: Note, progress: Float) {
		let layer = CALayer()
		
		let noteHeight = self.frame.height/12
		let noteWidth = noteHeight*1.5
		let noteRect = CGRect(
			x: (self.frame.width*3/5)-(noteWidth/2),
			y: (self.frame.height*CGFloat(Double(note.rawValue)/20.0))-(noteHeight/2),
			width: noteWidth, height: noteHeight)
		
		layer.frame = self.frame
		
		layer.addSublayer(drawNoteLayer(note, noteRect: noteRect, color: palette.green.trans()))
		layer.addSublayer(drawNoteStem(note, noteRect: noteRect, color: palette.green.trans()))
		
		self.layer.addSublayer(layer)
		
		let anim = CAKeyframeAnimation(keyPath: "position")
		anim.path = drawGhostPath(progress).CGPath
		anim.duration = 0.5
		
		var scaling:CATransform3D = layer.transform
		scaling = CATransform3DScale(scaling, 0.01, 0.01, 1.0)
		let scale = CABasicAnimation(keyPath: "transform")
		scale.duration = 0.5
		scale.toValue = NSValue.init(CATransform3D: scaling)
		
		layer.addAnimation(scale, forKey: "transformAnimation")
		layer.addAnimation(anim, forKey: "animate position along path")
		
	}
	
	func drawGhostPath(progress: Float) -> UIBezierPath {
		//let layer = CAShapeLayer()
		let bezierStart = CGPoint(x: self.frame.width/2,
		                          y: self.frame.height/2)
		let bezierEnd = CGPoint(x: self.frame.width*CGFloat(progress),
		                        y: 0)
		let control = CGPoint(x: self.frame.width/2, y: 0)
		let path = UIBezierPath()
		
		path.moveToPoint(bezierStart)
		path.addQuadCurveToPoint(bezierEnd, controlPoint: control)
		
		return path
	}
	
	// MARK: Staff Drawing
	
	func drawStaff(clef clef: Clef?, animated anim: Bool) {
		self.layer.sublayers = nil
		self.layer.addSublayer(drawStaffLayer(anim))
		if (clef != nil) {
			self.layer.addSublayer(drawClefLayer(clef!))
		}
	}
	
	func drawStaffLayer(animated: Bool) -> CALayer {
		
		let staffPathH = UIBezierPath()
		let staffPathV = UIBezierPath()
		let staffLayerH = CAShapeLayer()
		let staffLayerV = CAShapeLayer()
		let staffLayer = CALayer()
		
		// Horizontal lines
		for i in 3...7 {
			staffPathH.moveToPoint(CGPointMake(self.frame.width/20, self.frame.height*CGFloat(Double(i)/10.0)))
			staffPathH.addLineToPoint(CGPointMake(self.frame.width*19/20, self.frame.height*CGFloat(Double(i)/10.0)))
		}
		
		staffLayerH.path = staffPathH.CGPath
		staffLayerH.lineWidth = 1.0
		staffLayerH.strokeColor = palette.dark.base().CGColor
		
		staffLayer.addSublayer(staffLayerH)
		
		// Horizontal line animation
		if animated {
			let animateHorizontal = CABasicAnimation(keyPath: "strokeEnd")
			animateHorizontal.duration = 0.7
			animateHorizontal.fromValue = 0.0
			animateHorizontal.toValue = 1.0
			staffLayerH.addAnimation(animateHorizontal, forKey: "animate stroke end animation")
		}
		
		// Vertical line
		staffPathV.moveToPoint(CGPointMake(self.frame.width/20, self.frame.height*3/10-0.5))
		staffPathV.addLineToPoint(CGPointMake(self.frame.width/20, self.frame.height*7/10+0.5))
		
		staffLayerV.path = staffPathV.CGPath
		staffLayerV.lineWidth = 3.0
		staffLayerV.strokeColor = palette.dark.base().CGColor
		
		staffLayer.addSublayer(staffLayerV)
		
		// Vertical lines animation
		if animated {
			let animateVertical = CABasicAnimation(keyPath: "strokeEnd")
			animateVertical.duration = 0.8*0.7
			animateVertical.fromValue = 0.0
			animateVertical.toValue = 1.0
			staffLayerV.addAnimation(animateVertical, forKey: "animate stroke end animation")
		}
		
		return staffLayer
	}
	
	// MARK: Clef drawing
	
	func drawClefLayer (clef: Clef) -> CALayer {
		let clefLayer = CALayer()
		
		let height = CGFloat(self.frame.height*0.68)
		let posX = CGFloat(self.frame.width*0.05)
		let posY = CGFloat(5+(self.frame.height-height)/2)
		
		clefLayer.frame = CGRect(x: posX, y: posY, width: height*0.48, height: height)
		clefLayer.contents = UIImage(named: clef.rawValue)?.CGImage
		clefLayer.contentsGravity = kCAGravityResizeAspect
		
		return clefLayer
	}
}

// MARK: Clef enumerator

public enum Clef: String {
	case trebleClef, bassClef
}
