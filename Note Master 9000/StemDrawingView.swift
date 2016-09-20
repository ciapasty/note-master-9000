//
//  DrawNotesImageView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 28/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

// MARK: UIView Extension

extension UIView {
	func dg_center(_ usePresentationLayerIfPossible: Bool) -> CGPoint {
		if usePresentationLayerIfPossible, let presentationLayer = layer.presentation() {
			return presentationLayer.position
		}
		return center
	}
}

class StemDrawingView: UIView {
	
	// MARK: Properties
	
	var note: Note? = nil
	let pathLayer = CAShapeLayer()
	
	private var width = CGFloat()
	private var height = CGFloat()
	private var noteHeight = CGFloat()
	private var noteWidth = CGFloat()
	private var noteRect = CGRect()
	
	private let controlPoint = UIView()
	private var displayLink: CADisplayLink!
	private var animating = false {
		didSet {
			self.isUserInteractionEnabled = !animating
			displayLink.isPaused = !animating
		}
	}
	
	// MARK: Initialization

	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		
		controlPoint.frame = CGRect(x: 0.0, y: 0.0, width: 3.0, height: 3.0)
		controlPoint.backgroundColor = UIColor.clear
		self.addSubview(controlPoint)
		
		pathLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
		
		pathLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
		pathLayer.fillRule = kCAFillModeRemoved
		pathLayer.fillColor = UIColor.clear.cgColor
		pathLayer.lineWidth = 2
		pathLayer.strokeColor = ColorPalette.MidnightBlue.cgColor
		
		self.layer.addSublayer(pathLayer)
		
		//updatePathLayer()
		
		displayLink = CADisplayLink(target: self, selector: #selector(self.updatePathLayer))
		displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
		displayLink.isPaused = true
	}
	
	//MARK: Note stem drawing/animation
	
	func animateNoteStem() {
		if note!.rawValue < 10 {
			controlPoint.center = CGPoint(x: noteRect.origin.x+1.5+(height*0.05),
			                              y: noteRect.origin.y+noteRect.height/1.5+(height*1.7/10))
		} else {
			controlPoint.center = CGPoint(x: noteRect.origin.x+noteRect.width-1.5+(height*0.05),
			                              y: noteRect.origin.y+noteRect.height/2.5-(height*1.7/10))
		}
		updatePathLayer()
		animating = true
		UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.05, initialSpringVelocity: 8.0, options: [], animations: { () -> Void in
			if self.note!.rawValue < 10 {
				self.controlPoint.center = CGPoint(x: self.noteRect.origin.x+1.5,
					y: self.noteRect.origin.y+self.noteRect.height/1.5+(self.height*1.7/10))
			} else {
				self.controlPoint.center = CGPoint(x: self.noteRect.origin.x+self.noteRect.width-1.5,
					y: self.noteRect.origin.y+self.noteRect.height/2.5-(self.height*1.7/10))
			}
			}, completion: { _ in
				self.animating = false
		})
	}
	
	func updatePathLayer() {
		pathLayer.path = currentPath(note!)
	}
	
	private func currentPath(_ note: Note) -> CGPath {
		let bezierPath = UIBezierPath()
		
		if note.rawValue < 10 {
			bezierPath.move(to: CGPoint(x: noteRect.origin.x+1.5, y: noteRect.origin.y+noteRect.height/1.5))
			bezierPath.addQuadCurve(to: CGPoint(x: noteRect.origin.x+1.5, y: (noteRect.origin.y+noteRect.height/1.5)+(height*3.4/10)), controlPoint: controlPoint.dg_center(animating))
		} else {
			bezierPath.move(to: CGPoint(x: noteRect.origin.x+noteRect.width-1.5, y: noteRect.origin.y+noteRect.height/2.5))
			bezierPath.addQuadCurve(to: CGPoint(x: noteRect.origin.x+noteRect.width-1.5, y: (noteRect.origin.y+noteRect.height/2.5)-(height*3.4/10)), controlPoint: controlPoint.dg_center(animating))
		}
		
		return bezierPath.cgPath
	}
	
	func setupStem(_ note: Note, animated: Bool) {
		width = self.bounds.width
		height = self.bounds.height
		noteHeight = height/12
		noteWidth = noteHeight*1.5
		noteRect = CGRect(
			x: (width*3/5)-(noteWidth/2),
			y: (height*CGFloat(Double(note.rawValue)/20.0))-(noteHeight/2),
			width: noteWidth, height: noteHeight)
		
		self.note = note
		
		if note.rawValue < 10 {
			controlPoint.center = CGPoint(x: noteRect.origin.x+1.5,
			                              y: noteRect.origin.y+noteRect.height/1.5+(height*1.7/10))
		} else {
			controlPoint.center = CGPoint(x: noteRect.origin.x+noteRect.width-1.5,
			                              y: noteRect.origin.y+noteRect.height/2.5-(height*1.7/10))
		}
		updatePathLayer()
	}
	
	private func drawNoteStem(_ note: Note, noteRect: CGRect) -> CALayer {
		let noteStemPath = UIBezierPath()
		let noteStemLayer = CAShapeLayer()
		
		noteStemLayer.path = noteStemPath.cgPath
		noteStemLayer.lineWidth = 2.0
		noteStemLayer.strokeColor = ColorPalette.MidnightBlue.cgColor
		
		return noteStemLayer
	}
	
	

}
