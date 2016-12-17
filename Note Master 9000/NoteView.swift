//
//  NoteView.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 18/11/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//

/*
 
 flat - ♭
 sharp - ♯
 natural - ♮
 
*/

import UIKit

public enum Accidental {
    case sharp, flat, natural
}

@IBDesignable
class NoteView: UIView {
    
    public var isStemUp: Bool? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var accidental: Accidental? = nil {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var noteRect = CGRect()
    
    private struct Constants {
        static let NoteBodyLineWidth: CGFloat = 1.0
        static let NoteStemLineWidth: CGFloat = 2.0
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if superview != nil {
            noteRect = getRect()
            drawNote()
        }
    }
    
    func drawNote(){
        layer.sublayers = nil
        layer.addSublayer(drawNoteLayer())
        if isStemUp != nil {
            layer.addSublayer(drawNoteStem())
        }
        if accidental != nil {
            layer.addSublayer(drawAccidental())
        }
    }
    
    private func drawNoteLayer() -> CALayer {
        let notePath = UIBezierPath(ovalIn: CGRect(x: 0-noteRect.width/2, y: 0-noteRect.height/2, width: noteRect.width, height: noteRect.height))
        let noteLayer = CAShapeLayer()
        
        var rotation:CATransform3D = noteLayer.transform
        rotation = CATransform3DRotate(rotation, 0.4, 0.0, 0.0, -1.0)
        noteLayer.transform = rotation
        noteLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        noteLayer.path = notePath.cgPath
        noteLayer.lineWidth = Constants.NoteBodyLineWidth
        noteLayer.strokeColor = tintColor.cgColor
        noteLayer.fillColor = tintColor.cgColor
        
        return noteLayer
    }
    
    private func drawNoteStem() -> CALayer {
        let noteStemPath = UIBezierPath()
        let noteStemLayer = CAShapeLayer()
        
        if isStemUp! {
            let x = (bounds.midX+noteRect.width/2)-1.5
            let y = bounds.midY-noteRect.height/10
            noteStemPath.move(to: CGPoint(x: x, y: y))
            noteStemPath.addLine(to: CGPoint(x: x, y: y+noteRect.height/10-((superview?.bounds.width)!*3.5/10)))
        } else {
            let x = (bounds.midX-noteRect.width/2)+1.5
            let y = bounds.midY+noteRect.height/10
            noteStemPath.move(to: CGPoint(x: x, y: y))
            noteStemPath.addLine(to: CGPoint(x: x, y: y-noteRect.height/10+((superview?.bounds.width)!*3.5/10)))
        }
        
        noteStemLayer.path = noteStemPath.cgPath
        noteStemLayer.lineWidth = Constants.NoteStemLineWidth
        noteStemLayer.strokeColor = tintColor.cgColor
        
        return noteStemLayer
    }
    
    private func drawAccidental() -> CALayer {
        let accLayer = CATextLayer()
        accLayer.frame = CGRect(x: -noteRect.width*0.95, y: noteRect.origin.y*0.3, width: noteRect.width*4, height: noteRect.height*4)
        
        switch accidental! {
        case .sharp:
            accLayer.string = "♯"
        case .flat:
            accLayer.string = "♭"
        case .natural:
            accLayer.string = "♮"
        }
        
        accLayer.foregroundColor = tintColor.cgColor
        accLayer.contentsScale = UIScreen.main.scale
        accLayer.fontSize = (superview?.bounds.width)!/6.5
        
        return accLayer
    }
    
    private func getRect() -> CGRect {
        let noteHeight = (superview?.bounds.width)!/12
        let noteWidth = noteHeight*1.5
        return CGRect(x: -noteWidth/2, y: -noteHeight/2, width: noteWidth, height: noteHeight)
    }

}
