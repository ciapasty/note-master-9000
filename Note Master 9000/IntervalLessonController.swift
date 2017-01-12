//
//  IntervalsLessonController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 20/11/2016.
//  Copyright © 2016 Mattijah. All rights reserved.
//


/*
 View responsibilities:
 - Show appropriate controls for currently trained intervals
    - How many intervals at once?
    - Dynamic UI? -> third (expanding to?) -> major/minor
 - Draw staff
 - Draw treble/bass clef
 - Draw two notes
    - With accidentals? -> makes interval practice more robust
 - Show lesson progess
 - Play both notes
    - Alternating: at once, sequential
 
 Additional functionality:
 - Guess the place of second note
 
 Model:
 - class InvervalsLesson: Lesson
 */

import UIKit
import GameplayKit

class IntervalLessonController: UIViewController {
    
    @IBOutlet weak var staffView: StaffView!
    @IBOutlet weak var clefImageView: UIImageView!
    @IBOutlet weak var noteView1: NoteView!
    @IBOutlet weak var noteView2: NoteView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // MARK: - Model
    var lesson: IntervalLesson? {
        didSet {
            if lesson != nil {
                setupLesson()
            }
        }
    }
    
    // MARK: -
    var parentVC: LessonsViewController?

    private var lessonProgress: Float = 0.0 {
        didSet {
            progressBar?.setProgress(lessonProgress, animated: true)
        }
    }
    
    private var baseNote: Note? {
        didSet {
            // TEMPORARY??
            if baseNote != nil {
                intervalNote = getNote(forInterval: currentInterval!, from: baseNote!)
                drawNotes()
            }
        }
    }
    private var previousNote: Note?
    private var intervalNote: Note?
    private var currentInterval: Interval? {
        didSet {
            //print(currentInterval!)
            
            if noteSet!.count > 1 {
                previousNote = baseNote
                baseNote = randomNote()
            } else {
                baseNote = noteSet![0]
            }
        }
    }
    private var noteSet: [Note]?
    private var intervalSet: [Interval]?
    private var notesDict: [Note: (name: String, position: Int)]?
    
    private struct Constants {
        static let BasicAnimationDuration: Double = 0.4
        static let ButtonAnimationStartDelay: Double = 0.5
        static let ButtonAnimationDelay: Double = 0.1
        static let ButtonAnimationDamping: CGFloat = 0.6
        static let ClefAnimationDamping: CGFloat = 0.8
        static let ButtonAnimationVelocity: CGFloat = 1.0
        static let NoteVibrateAnimationVelocity: CGFloat = 8.0
        static let NoteVibrateAnimationDamping: CGFloat = 0.05
        static let NoteVibrateAnimationOffset: CGFloat = 7
        static let WrongAnimationVelocity: CGFloat = 8.0
        static let WrongAnimationDamping: CGFloat = 0.1
        static let WrongAnimationOffset: CGFloat = 12
        
        static let RequiredCorrectNotes = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - Setup methods
    
    private func setupViews() {
        staffView.tintColor = ColorPalette.MidnightBlue
        clefImageView.tintColor = ColorPalette.MidnightBlue
        noteView1.tintColor = ColorPalette.MidnightBlue
        noteView2.tintColor = ColorPalette.MidnightBlue

        progressBar.tintColor = ColorPalette.Nephritis
        progressBar.progress = lessonProgress
        
        view.backgroundColor = ColorPalette.Clouds
    }
    
    private func setupLesson() {
        clefImageView.image = UIImage(named: lesson!.clef!.rawValue)?.withRenderingMode(.alwaysTemplate)
        
        switch lesson!.clef! {
        case .trebleClef:
            notesDict = trebleClefNotesDict
        case .bassClef:
            fatalError("bassClefNotesDict not yet implemented!") // This will most probably change
            //notesDict = bassClefNotesDict
        }
        
        if lesson!.intervalSet == nil {
//            var set = [Interval]()
//            managedObjectContext?.performAndWait {
//                set = IntervalCorrectness.fetchWorstNotes(inClef: ls.clef!, recordsCount: 10, in: self.managedObjectContext!)!
//            }
            
            //TEMP
            intervalSet = [.unison, .minorSecond, .majorSecond, .minorThird, .majorThird, .fourth, .tritone, .fifth, .minorSixth, .majorSixth, .minorSeventh, .majorSeventh, .octave]
        } else {
            intervalSet = lesson!.intervalSet
        }
        
        if lesson!.noteSet == nil {
            noteSet = notesInRange(from: Note(rawValue: intervalSet!.last!.rawValue)!, to: .n32)
        } else {
            noteSet = lesson!.noteSet!
        }
        
        currentInterval = randomInterval()
        
        staffView.animated = true
        staffView.setNeedsDisplay()
        clefSlideIn()
        notesSlideIn(withDelay: 0.8, animateBaseNote: true)
    }
    
    // MARK: - Drawing methods
    
    private func drawNotes() {
        staffView.removeAdditionalLines()
        
        if notesDict![baseNote!]!.name.contains("#") {
            noteView1.accidental = .sharp
        } else {
            noteView1.accidental = nil
        }
        noteView1.center = CGPoint(x: staffView.bounds.width/2+10, y: (staffView.bounds.height*CGFloat(Double(notesDict![baseNote!]!.position)/20.0)))
        drawAdditionalLines(forNoteAt: notesDict![baseNote!]!.position, Width: staffView.bounds.width/2+10)
        
        if notesDict![intervalNote!]!.name.contains("#") {
            noteView2.accidental = .sharp
        } else {
            noteView2.accidental = nil
        }
        noteView2.center = CGPoint(x: staffView.bounds.width*3/4+10, y: (staffView.bounds.height*CGFloat(Double(notesDict![intervalNote!]!.position)/20.0)))
        drawAdditionalLines(forNoteAt: notesDict![intervalNote!]!.position, Width: staffView.bounds.width*3/4+10)
        
        notesSlideIn(withDelay: 0, animateBaseNote: noteSet!.count > 1)
    }
    
    private func drawAdditionalLines(forNoteAt position: Int, Width width: CGFloat) {
        if position > 15 {
            staffView.drawAddLines(at: width, atTop: false, twoLines: false)
            if position > 17 {
                staffView.drawAddLines(at: width, atTop: false, twoLines: true)
            }
        }
        if position < 5 {
            staffView.drawAddLines(at: width, atTop: true, twoLines: false)
            if position < 3 {
                staffView.drawAddLines(at: width, atTop: true, twoLines: true)
            }
        }
    }
    
    // MARK: - Helper methods
    
    // DEBUG
    @IBAction func noteUp(_ sender: UIButton) {
        baseNote = Note(rawValue: baseNote!.rawValue-1)
    }
    
    @IBAction func noteDown(_ sender: UIButton) {
        baseNote = Note(rawValue: baseNote!.rawValue+1)
    }
    
    @IBAction func randomize(_ sender: UIButton) {
        currentInterval = randomInterval()
    }
    
    private func randomNote() -> Note {
        let note = noteSet![GKGaussianDistribution(randomSource: GKRandomSource(),
                                                               lowestValue: 0,
                                                               highestValue: noteSet!.count-1).nextInt()]
        
        if note == previousNote {
            return randomNote()
        } else {
            return note
        }
    }
    
    private func randomInterval() -> Interval {
        return intervalSet![Int(arc4random_uniform(UInt32(intervalSet!.count)))]
    }
    
    private func getNote(forInterval interval: Interval, from bNote: Note) -> Note {
        return Note(rawValue: bNote.rawValue-interval.rawValue)!
    }
    
    // MARK: - Animations
    
    private func clefSlideIn() {
        clefImageView.center.x += self.view.bounds.width
        UIView.animate(withDuration: Constants.BasicAnimationDuration, delay: Constants.ButtonAnimationStartDelay+0.1, usingSpringWithDamping: Constants.ClefAnimationDamping, initialSpringVelocity: Constants.ButtonAnimationVelocity, options: [], animations: {
            self.clefImageView.center.x -= self.view.bounds.width
        }, completion: { finished in
            self.staffView.animated = false
        })
    }
    
    private func notesSlideIn(withDelay delay: TimeInterval, animateBaseNote baseAnim: Bool) {
        if baseAnim {
            animateSlideIn(for: noteView1, withDelay: delay)
        }
        animateSlideIn(for: noteView2, withDelay: delay + 0.2)
    }
    
    private func animateSlideIn(for noteView: UIView, withDelay delay: TimeInterval) {
        noteView.center.x += self.view.bounds.width
        UIView.animate(withDuration: Constants.BasicAnimationDuration/2, delay: delay, options: [.curveEaseIn], animations: {
            noteView.center.x -= self.view.bounds.width
        }, completion: { finished in
            self.animateVibration(for: noteView)
        })
    }
    
    private func animateVibration(for noteView: UIView) {
        noteView.center.x += Constants.NoteVibrateAnimationOffset
        UIView.animate(withDuration: Constants.BasicAnimationDuration, delay: 0.0, usingSpringWithDamping: Constants.NoteVibrateAnimationDamping, initialSpringVelocity: Constants.NoteVibrateAnimationVelocity, options: [], animations: { () -> Void in
            noteView.center.x -= Constants.NoteVibrateAnimationOffset
        }, completion: nil)
    }
    
}
