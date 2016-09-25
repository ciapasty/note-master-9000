//
//  LessonMiniature.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 25/09/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class LessonMiniature: UIView {

	var lesson: Lesson? {
		didSet {
			setNeedsDisplay()
		}
	}
	
	private struct Constants {
		static let LessonIconBorderWidth: CGFloat = 3.0
		static let LessonIconBackgroundAlpha: CGFloat = 0.5
	}
	
    override func draw(_ rect: CGRect) {
		layer.sublayers = nil
		// Background fill
		ColorPalette.Clouds.set()
		UIBezierPath(rect: rect).fill()
		
		if let ls = lesson {
			// Miniature circle
			let circleRect = CGRect(x: Constants.LessonIconBorderWidth/2,
			                      y: Constants.LessonIconBorderWidth/2,
			                      width: rect.width-Constants.LessonIconBorderWidth,
			                      height: rect.height-Constants.LessonIconBorderWidth)
			
			let circle = UIBezierPath(ovalIn: circleRect)
			circle.lineWidth = Constants.LessonIconBorderWidth
			
			ls.color.set()
			circle.stroke()
			
			ls.color.withAlphaComponent(Constants.LessonIconBackgroundAlpha).set()
			circle.fill()
			
			let imgLayer = CALayer()
			imgLayer.frame = circleRect
			if let clef = ls.clef {
				imgLayer.contents = UIImage(named: clef.rawValue+"_small")?.cgImage
			} else {
				imgLayer.contents = UIImage(named: "questionmark_small")?.cgImage
			}
			imgLayer.contentsGravity = kCAGravityResizeAspect
			
			layer.addSublayer(imgLayer)
					
			if ls.complete {
				let completeSing = UIBezierPath(ovalIn: CGRect(x: rect.width*2/3,
				                                               y: 0,
				                                               width: rect.height/3,
				                                               height: rect.height/3))
				ColorPalette.Nephritis.set()
				completeSing.fill()
			}
		}
    }
}
