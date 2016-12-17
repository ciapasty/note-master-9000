//
//  LessonViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 11/09/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit
import CoreData

class LessonsViewController: UIViewController {
	
    @IBOutlet weak var lessonContainerView: UIView! {
        didSet {
            if let _ = lesson as? NoteLesson {
                setupContaierView(withViewControllerWithID: Constants.NoteLessonControllerStoryboardID)
            } else if let _ = lesson as? TutorialLesson {
                setupContaierView(withViewControllerWithID: Constants.TutorialLessonControllerStoryboardID)
            } else if let _ = lesson as? IntervalLesson {
                setupContaierView(withViewControllerWithID: Constants.IntervalLessonControllerStoryboardID)
            }
        }
    }
    
	@IBOutlet weak var welcomeView: UIView!
	@IBOutlet weak var lessonNumberLabel: UILabel!
	@IBOutlet weak var lessonTitleLabel: UILabel!
	@IBOutlet weak var lessonDescriptionLabel: UILabel!
	
	@IBOutlet weak var finishedView: UIView!
	@IBOutlet weak var finishedLabel: UILabel!
	@IBOutlet weak var nextLessonButton: UIButton!
	@IBOutlet weak var lessonPlanButton: UIButton!

    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
	// MARK: Model
	var lessonIndexPath: IndexPath? {
		didSet {
			if let indexPath = lessonIndexPath {
                lesson = lessons[indexPath.section][indexPath.row] as Lesson
			}
		}
	}
	
    // MARK: -
	private var lesson: Lesson? {
		didSet {
			if lesson!.state == .new {
				lesson!.state = .opened
                saveLessonState()
			}
		}
	}
	
    private var currentChildVC: UIViewController?
	private var navBar: UINavigationBar?
	
	private struct Constants {
		static let BasicAnimationDuration: Double = 0.4
		static let EmbedTutorialLessonSegue = "embedTutorialLesson"
		static let EmbedNoteLessonSegue = "embedNoteLesson"
		static let BackToLessonsCollectionSegue = "backToLessonPlan"
        static let TutorialLessonControllerStoryboardID = "TutorialLessonController"
        static let NoteLessonControllerStoryboardID = "NoteLessonController"
        static let IntervalLessonControllerStoryboardID = "IntervalLessonController"
	}
	
	// MARK: - ViewController
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navBar = navigationController?.navigationBar
		
		view.backgroundColor = ColorPalette.Clouds
		setupNavBar()
		navBar!.alpha = 0.01
		
		setupWelcomeView(withLesson: lesson!)
    }
    
    // MARK: - Actions
	
	@IBAction func hideWelcomeView(_ sender: AnyObject?) {
        if let cvc = currentChildVC as? NoteLessonController {
            cvc.parentVC = self
            cvc.lesson = lesson as? NoteLesson
        } else if let cvc = currentChildVC as? TutorialLessonController {
            cvc.parentVC = self
            cvc.lesson = lesson as? TutorialLesson
        } else if let cvc = currentChildVC as? IntervalLessonController {
            cvc.parentVC = self
            cvc.lesson = lesson as? IntervalLesson
        }
        hideWelcomeViewAnimation()
	}
	
	@IBAction func goToNextLesson() {
		if let nextLessonIndex = nextLessonIndexPath(lessonIndexPath!) {
			lessonIndexPath = nextLessonIndex
            
			setupNavBar()
			hideFinishedViewAnimation()
		}
	}

	// MARK: - Setup methods
    
    private func setupContaierView(withViewControllerWithID id: String) {
        if lesson != nil {
            if let vc = storyboard?.instantiateViewController(withIdentifier: id) {
                addChildViewController(vc)
                vc.view.frame = CGRect(x: 0, y: 0, width: lessonContainerView.frame.size.width, height: lessonContainerView.frame.size.height)
                lessonContainerView.addSubview(vc.view)
                vc.didMove(toParentViewController: self)
                
                currentChildVC = vc
            }
        }
    }
	
	private func setupNavBar() {
		if lesson!.color == ColorPalette.Orange {
			let textColor = ColorPalette.WetAsphalt
			navBar!.barStyle = .default
			navBar!.tintColor = textColor
			navBar!.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
		} else {
			let textColor = ColorPalette.Clouds
			navBar!.barStyle = .black
			navBar!.tintColor = textColor
			navBar!.titleTextAttributes = [NSForegroundColorAttributeName: textColor]
		}
		
		navBar!.barTintColor = lesson!.color //ColorPalette.MidnightBlue
		navigationItem.title = lesson!.title
	}
	
	private func setupWelcomeView(withLesson lesson: Lesson) {
		if lesson.color == ColorPalette.Orange {
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
		welcomeView?.backgroundColor = lesson.color
		
		lessonNumberLabel?.text = "Lesson \(lesson.index)"
		lessonTitleLabel?.text = lesson.title
		lessonDescriptionLabel?.text = lesson.description
	}
	
	private func setupFinishedView() {
		if lesson!.color == ColorPalette.Orange {
			let textColor = ColorPalette.WetAsphalt
			finishedLabel?.textColor = textColor
			lessonPlanButton?.setTitleColor(textColor, for: UIControlState())
			nextLessonButton?.setTitleColor(textColor, for: UIControlState())
		} else {
			let textColor = ColorPalette.Clouds
			finishedLabel?.textColor = textColor
			lessonPlanButton?.setTitleColor(textColor, for: UIControlState())
			nextLessonButton?.setTitleColor(textColor, for: UIControlState())
		}
		finishedView?.backgroundColor = lesson!.color
	}
    
    private func clearContainerView() {
        currentChildVC?.willMove(toParentViewController: nil)
        currentChildVC?.view.removeFromSuperview()
        currentChildVC?.removeFromParentViewController()
        
        if let tlvc = currentChildVC as? TutorialLessonController {
            tlvc.parentVC = nil
            tlvc.lesson = nil
        } else if let bcvc = currentChildVC as? NoteLessonController {
            bcvc.parentVC = nil
            bcvc.lesson = nil
        }
    }
	
    // MARK: - Navigation
	
	@IBAction func exitButtonTap(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
		let exitAction = UIAlertAction(title: "Quit", style: .default, handler: {
			(_)in
			self.performSegue(withIdentifier: Constants.BackToLessonsCollectionSegue, sender: self)
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		alert.addAction(exitAction)
		alert.addAction(cancelAction)
		
		let subview = alert.view.subviews.first! as UIView
		let alertContentView = subview.subviews.first! as UIView
		alertContentView.backgroundColor = ColorPalette.Clouds
		
		self.present(alert, animated: true, completion: nil)
		
		alert.view.tintColor = (lessons[lessonIndexPath!.section][lessonIndexPath!.row] as Lesson).color
	}
	
	// MARK: - Helper methods
    
    func lessonFinished() {
        if lesson?.state != .infinite {
            lesson?.state = .finished
            saveLessonState()
        }
        
        setupFinishedView()
        if nextLessonIndexPath(lessonIndexPath!) == nil {
            nextLessonButton.isHidden = true
        }
        showFinishedViewAnimation()
    }
	
    private func saveLessonState() {
        managedObjectContext?.performAndWait {
            _ = LessonsTracking.setStateFor(self.lesson!, in: self.managedObjectContext!)
        }
        do {
            try managedObjectContext?.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
	private func nextLessonIndexPath(_ indexPath: IndexPath) -> IndexPath? {
		if lessons[indexPath.section].endIndex > indexPath.row+1 {
			return IndexPath(row: indexPath.row+1, section: indexPath.section)
		} else if lessons.endIndex > indexPath.section+1 {
			return IndexPath(row: 0, section: indexPath.section+1)
		} else {
			return nil
		}
	}
	
	// MARK: - Animations
	
	private func hideWelcomeViewAnimation() {
		UIView.animate(withDuration: Constants.BasicAnimationDuration, animations: {
			self.welcomeView.center.x -= self.view.bounds.width
			self.navBar!.alpha = 1.0
		}, completion: { finished in
			self.welcomeView.center.x += self.view.bounds.width
			self.welcomeView.isHidden = true
			if let nextLessonIndex = self.nextLessonIndexPath(self.lessonIndexPath!) {
				self.setupWelcomeView(withLesson: lessons[nextLessonIndex.section][nextLessonIndex.row])
			}
		}) 
	}

	private func showFinishedViewAnimation() {
		finishedView.isHidden = false
		finishedView.center.x += self.view.bounds.width
		UIView.animate(withDuration: Constants.BasicAnimationDuration, animations: {
			self.finishedView.center.x -= self.view.bounds.width
			self.navBar!.alpha = 0.01
			}, completion: { finished in
				self.clearContainerView()
		}) 
	}
	
	private func hideFinishedViewAnimation() {
		welcomeView.center.x += self.view.bounds.width
		welcomeView.isHidden = false
		UIView.animate(withDuration: Constants.BasicAnimationDuration, animations: {
			self.welcomeView.center.x -= self.view.bounds.width
			self.finishedView.center.x -= self.view.bounds.width
			}, completion: { finished in
				self.finishedView.center.x += self.view.bounds.width
				self.finishedView.isHidden = true
                
                // TODO: Should this be in animation code??
                if let _ = self.lesson as? NoteLesson {
                    self.setupContaierView(withViewControllerWithID: Constants.NoteLessonControllerStoryboardID)
                } else if let _ = self.lesson as? TutorialLesson {
                    self.setupContaierView(withViewControllerWithID: Constants.TutorialLessonControllerStoryboardID)
                } else if let _ = self.lesson as? IntervalLesson {
                    self.setupContaierView(withViewControllerWithID: Constants.IntervalLessonControllerStoryboardID)
                }
		}) 
	}
}
