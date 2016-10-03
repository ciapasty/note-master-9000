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
		static let ImageRectMargin: CGFloat = 4.0
		static let IconBorderWidth: CGFloat = 3.0
		static let IconBackgroundAlpha: CGFloat = 0.6
	}
	
    override func draw(_ rect: CGRect) {
		layer.sublayers = nil
		// Background fill
		ColorPalette.Clouds.set()
		UIBezierPath(rect: rect).fill()
		
		if let ls = lesson {
			let rectWithMargin = CGRect(x: Constants.ImageRectMargin,
			                      y: Constants.ImageRectMargin,
			                      width: rect.width-2*Constants.ImageRectMargin,
			                      height: rect.height-2*Constants.ImageRectMargin)
			// Miniature circle

			let circle = UIBezierPath(ovalIn: rect)
			
			ls.color.withAlphaComponent(Constants.IconBackgroundAlpha).set()
			circle.fill()
			
			//drawDiamond(rect) // Alternative layout design
			
			let imgLayer = CALayer()
			imgLayer.frame = rectWithMargin
			if let clef = ls.clef {
				imgLayer.contents = UIImage(named: clef.rawValue+"_small")?.cgImage
			} else {
				imgLayer.contents = UIImage(named: "questionmark_small")?.cgImage
			}
			imgLayer.contentsGravity = kCAGravityResizeAspect
			
			layer.addSublayer(imgLayer)
					
			switch ls.state {
			case .new:
				drawMiniCircle(colored: ColorPalette.SunFlower)
			case .neutral:
				break
			case .completed:
				drawMiniCircle(colored: ColorPalette.Nephritis)
			}
		}
    }
	
	private func drawMiniCircle(colored color: UIColor) {
		let circle = UIBezierPath(ovalIn: CGRect(x: bounds.width*2/3,
		                                               y: 0,
		                                               width: bounds.height/3,
		                                               height: bounds.height/3))
		color.set()
		circle.fill()
	}
	
	private func drawDiamond (_ rect: CGRect) {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let topPoint = CGPoint(x: rect.width*5/6, y: 0)
		let bottomPoint = CGPoint(x: rect.width*1/6, y: rect.height)
		let leftPoint = CGPoint(x: rect.width*1/6, y: rect.height*1/6)
		let rightPoint = CGPoint(x: rect.width*5/6, y: rect.height*5/6)
		
		let lightTriangle = UIBezierPath()
		lightTriangle.move(to: topPoint)
		lightTriangle.addLine(to: leftPoint)
		lightTriangle.addLine(to: bottomPoint)
		lesson!.color.withAlphaComponent(0.6).set()
		lightTriangle.fill()
		
		let medTriangle1 = UIBezierPath()
		medTriangle1.move(to: leftPoint)
		medTriangle1.addLine(to: center)
		medTriangle1.addLine(to: bottomPoint)
		lesson!.color.withAlphaComponent(0.7).set()
		medTriangle1.fill()
		
		let medTriangle2 = UIBezierPath()
		medTriangle2.move(to: topPoint)
		medTriangle2.addLine(to: rightPoint)
		medTriangle2.addLine(to: center)
		lesson!.color.withAlphaComponent(0.9).set()
		medTriangle2.fill()
		
		let darkTriangle = UIBezierPath()
		darkTriangle.move(to: center)
		darkTriangle.addLine(to: rightPoint)
		darkTriangle.addLine(to: bottomPoint)
		lesson!.color.set()
		darkTriangle.fill()
	}
}
