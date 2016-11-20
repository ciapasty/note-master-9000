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
    - Alternating at once, sequential
 
 Additional functionality:
 - Guess the place of second note
 
 Model:
 - class InvervalsLesson: Lesson
 */

import UIKit

class IntervalsLessonController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
