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
	var tutorialLesson: TutorialLesson?
	var noteLesson: NoteLesson?
	
	private var noteLessonVC: BasicClefViewController?
	private var tutorialLessonVC: TutorialViewController?
	
	private struct Constants {
		static let BasicAnimationDuration: Double = 0.4
		static let EmbedTutorialLessonSegue = "embedTutorialLesson"
		static let EmbedNoteLessonSegue = "embedNoteLesson"
		static let BackToLessonsCollectionSegue = "backToLessonPlan"
	}
	
	// MARK: - ViewController lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()

        tutorialLessonContainer.hidden = true
		noteLessonContainer.hidden = true
    }
	
	@IBAction func hideWelcomeView(sender: UITapGestureRecognizer) {
		// TODO: Prepare views in containers
		hideWelcomeViewAnimation()
	}
	
	private func setupViews() {
		let nav = self.navigationController?.navigationBar
		
		if let 
		
		if lesson?.color == ColorPalette.Orange { //|| lesson?.color == ColorPalette.GreenSee {
			let textColor = ColorPalette.WetAsphalt
			nav?.barStyle = .Default
			lessonNumberLabel.textColor = textColor
			lessonTitleLabel.textColor = textColor
			lessonDescriptionLabel.textColor = textColor
			finishedLabel.textColor = textColor
			lessonPlanButton.setTitleColor(textColor, forState: .Normal)
			nextLessonButton.setTitleColor(textColor, forState: .Normal)
			nav?.tintColor = textColor
			nav?.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
		} else {
			let textColor = ColorPalette.Clouds
			nav?.barStyle = .Black
			lessonNumberLabel.textColor = textColor
			lessonTitleLabel.textColor = textColor
			lessonDescriptionLabel.textColor = textColor
			finishedLabel.textColor = textColor
			lessonPlanButton.setTitleColor(textColor, forState: .Normal)
			nextLessonButton.setTitleColor(textColor, forState: .Normal)
			nav?.tintColor = textColor
			nav?.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
		}
		
		nav?.barTintColor = lesson!.color //ColorPalette.MidnightBlue
		nav?.alpha = 0.0
		
		welcomeView.backgroundColor = lesson!.color
		finishedView.backgroundColor = lesson!.color
		view.backgroundColor = ColorPalette.Clouds
	}

    // MARK: - Navigation
	
	@IBAction func goToNextLesson() {
		// TODO: Show welcomeView for next lesson
		// TODO: Switch visible containerView in background
		// TODO: Configure visible view in background
	}
	
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
		
		alert.view.tintColor = lesson?.color
	}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == Constants.EmbedTutorialLessonSegue {
			tutorialLessonVC = segue.destinationViewController as? TutorialViewController
		}
		if segue.identifier == Constants.EmbedNoteLessonSegue {
			noteLessonVC = segue.destinationViewController as? BasicClefViewController
		}
    }
	
	// MARK: - Animations
	
	private func showFinishedViewAnimation() {
		let nav = self.navigationController?.navigationBar
		//nav?.alpha = 1.0
		UIView.animateWithDuration(Constants.BasicAnimationDuration, delay: Constants.BasicAnimationDuration, options: [], animations: {
			self.finishedView.alpha = 1
			}, completion: { finished in
				nav?.alpha = 0.0
		})
	}
	
	private func hideWelcomeViewAnimation() {
		let nav = self.navigationController?.navigationBar
		nav?.alpha = 1.0
		
		UIView.animateWithDuration(1.0, animations: {
			self.welcomeView.alpha = 0.0
		}) { finished in
			self.welcomeView.removeFromSuperview()
		}
	}

}
