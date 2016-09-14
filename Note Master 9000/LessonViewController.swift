//
//  LessonViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 11/09/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController {
	
	@IBOutlet weak var tutorialLessonContainer: UIView!
	@IBOutlet weak var noteLessonContainer: UIView!
	
	@IBOutlet weak var welcomeView: UIView!
	@IBOutlet weak var lessonNumberLabel: UILabel!
	@IBOutlet weak var lessonTitleLabel: UILabel!
	@IBOutlet weak var lessonDescriptionLabel: UILabel!
	
	@IBOutlet weak var finishedView: UIView!
	@IBOutlet weak var finishedLabel: UILabel!
	@IBOutlet weak var nextLessonButton: UIButton!
	@IBOutlet weak var lessonPlanButton: UIButton!

	// MARK: Model
	var lessonIndexPath: NSIndexPath? {
		didSet {
			if let indexPath = lessonIndexPath {
				if let nl = lessons[indexPath.section][indexPath.row] as? NoteLesson {
					tutorialLesson = nil
					noteLesson =  nl
					lesson = nl as Lesson
				} else if let tl = lessons[indexPath.section][indexPath.row] as? TutorialLesson {
					tutorialLesson = tl
					noteLesson = nil
					lesson = tl as Lesson
				}
			}
		}
	}
	
	private var lesson: Lesson?
	private var tutorialLesson: TutorialLesson?
	private var noteLesson: NoteLesson?
	
	private var noteLessonVC: BasicClefViewController?
	private var tutorialLessonVC: TutorialViewController?
	private var navBar: UINavigationBar?
	
	private struct Constants {
		static let BasicAnimationDuration: Double = 0.4
		static let EmbedTutorialLessonSegue = "embedTutorialLesson"
		static let EmbedNoteLessonSegue = "embedNoteLesson"
		static let BackToLessonsCollectionSegue = "backToLessonPlan"
	}
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navBar = navigationController?.navigationBar
		
		view.backgroundColor = ColorPalette.Clouds
		setupNavBar()
		setupWelcomeView()
    }
	
	@IBAction func hideWelcomeView(sender: UITapGestureRecognizer) {
		// TODO: Prepare views in containers
		hideWelcomeViewAnimation()
		setupTutorialView(tutorialLesson)
		setupNoteView(noteLesson)
	}
	
	@IBAction func goToNextLesson() {
		// TODO: Show welcomeView for next lesson
		// TODO: Switch visible containerView in background
		// TODO: Configure visible view in background
	}

	@IBAction func endLesson(sender: AnyObject) {
		lessonFinished()
	}
	// MARK: - Setup methods
	
	private func setupTutorialView(lesson: TutorialLesson?) {
		if lesson != nil {
			tutorialLessonVC?.lesson = lesson
			noteLessonContainer.hidden = true
			tutorialLessonContainer.hidden = false
		}
	}
	
	private func setupNoteView(lesson: NoteLesson?) {
		if lesson != nil {
			noteLessonVC?.lesson = lesson
			noteLessonContainer.hidden = false
			tutorialLessonContainer.hidden = true
		}
	}
	
	private func setupNavBar() {
		if lesson!.color == ColorPalette.Orange {
			let textColor = ColorPalette.WetAsphalt
			navBar!.barStyle = .Default
			navBar!.tintColor = textColor
			navBar!.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
		} else {
			let textColor = ColorPalette.Clouds
			navBar!.barStyle = .Black
			navBar!.tintColor = textColor
			navBar!.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
		}
		
		navBar!.barTintColor = lesson!.color //ColorPalette.MidnightBlue
		//navBar!.alpha = 0.0
		
		navigationItem.title = lesson!.title
	}
	
	private func setupWelcomeView() {
		if lesson!.color == ColorPalette.Orange {
			let textColor = ColorPalette.WetAsphalt
			lessonNumberLabel?.textColor = textColor
			lessonTitleLabel?.textColor = textColor
			lessonDescriptionLabel?.textColor = textColor
		} else {
			let textColor = ColorPalette.Clouds
			lessonNumberLabel?.textColor = textColor
			lessonTitleLabel?.textColor = textColor
			lessonDescriptionLabel?.textColor = textColor
		}
		welcomeView?.backgroundColor = lesson!.color
		
		lessonNumberLabel?.text = "Lesson \(lesson!.index)"
		lessonTitleLabel?.text = lesson!.title
		lessonDescriptionLabel?.text = lesson!.description
	}
	
	private func setupFinishedView() {
		if lesson!.color == ColorPalette.Orange {
			let textColor = ColorPalette.WetAsphalt
			finishedLabel?.textColor = textColor
			lessonPlanButton?.setTitleColor(textColor, forState: .Normal)
			nextLessonButton?.setTitleColor(textColor, forState: .Normal)
		} else {
			let textColor = ColorPalette.Clouds
			finishedLabel?.textColor = textColor
			lessonPlanButton?.setTitleColor(textColor, forState: .Normal)
			nextLessonButton?.setTitleColor(textColor, forState: .Normal)
		}
		finishedView?.backgroundColor = lesson!.color
	}
	
	private func lessonFinished() {
		setupFinishedView()
		showFinishedViewAnimation()
	}
	
    // MARK: - Navigation
	
	@IBAction func exitButtonTap(sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .Alert)
		let exitAction = UIAlertAction(title: "Quit", style: .Default, handler: {
			(_)in
			self.performSegueWithIdentifier(Constants.BackToLessonsCollectionSegue, sender: self)
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		
		alert.addAction(exitAction)
		alert.addAction(cancelAction)
		
		let subview = alert.view.subviews.first! as UIView
		let alertContentView = subview.subviews.first! as UIView
		alertContentView.backgroundColor = ColorPalette.Clouds
		
		self.presentViewController(alert, animated: true, completion: nil)
		
		alert.view.tintColor = (lessons[lessonIndexPath!.section][lessonIndexPath!.row] as Lesson).color
	}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == Constants.EmbedTutorialLessonSegue {
			tutorialLessonVC = segue.destinationViewController as? TutorialViewController
		}
		if segue.identifier == Constants.EmbedNoteLessonSegue {
			noteLessonVC = segue.destinationViewController as? BasicClefViewController
		}
    }
	
	// MARK: - Helper functions
	
	private func nextLessonIndexPath(indexPath: NSIndexPath) -> NSIndexPath? {
		if lessons[indexPath.section].endIndex > indexPath.row+1 {
			return NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
		} else if lessons.endIndex > indexPath.section+1 {
			return NSIndexPath(forRow: 0, inSection: indexPath.section+1)
		} else {
			return nil
		}
	}
	
	// MARK: - Animations
	
	private func showWelcomeViewAnimation() {
		welcomeView.center.x += self.view.bounds.width
		welcomeView.hidden = false
		UIView.animateWithDuration(Constants.BasicAnimationDuration, animations: {
			self.welcomeView.center.x -= self.view.bounds.width
		}) { finished in
			
		}
	}
	
	private func hideWelcomeViewAnimation() {
		UIView.animateWithDuration(Constants.BasicAnimationDuration, animations: {
			self.welcomeView.center.x -= self.view.bounds.width
			//self.navBar!.alpha = 1.0
		}) { finished in
			self.welcomeView.center.x += 2*self.view.bounds.width
			self.welcomeView.hidden = true
		}
	}

	private func showFinishedViewAnimation() {
		finishedView.hidden = false
		finishedView.center.x += self.view.bounds.width
		UIView.animateWithDuration(Constants.BasicAnimationDuration, animations: {
			self.finishedView.center.x -= self.view.bounds.width
			//self.navBar!.alpha = 0.0
			}) { finished in
				
		}
	}
	
	private func hideFinishedViewAnimation() {
		UIView.animateWithDuration(Constants.BasicAnimationDuration, animations: {
			self.finishedView.center.x -= self.view.bounds.width
			}) { finished in
				self.finishedView.center.x += 2*self.view.bounds.width
				self.finishedView.hidden = true
		}
	}
}
