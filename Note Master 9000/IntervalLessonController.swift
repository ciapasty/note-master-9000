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
    - Dynamic UI? -> third (expanding to) -> major/minor
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

class IntervalLessonController: UIViewController {
    
    @IBOutlet weak var staffView: StaffView!
    @IBOutlet weak var clefImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // Model
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
            progressBar?.progress = lessonProgress
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - Setup methods
    
    private func setupViews() {
        staffView.tintColor = ColorPalette.MidnightBlue
        
        progressBar.tintColor = ColorPalette.Nephritis
        progressBar.progress = lessonProgress
        
        view.backgroundColor = ColorPalette.Clouds
    }
    
    private func setupLesson() {
        clefImageView.image = UIImage(named: lesson!.clef!.rawValue)?.withRenderingMode(.alwaysTemplate)
        clefImageView.tintColor = ColorPalette.MidnightBlue
        
        staffView.setNeedsDisplay()
    }
}
