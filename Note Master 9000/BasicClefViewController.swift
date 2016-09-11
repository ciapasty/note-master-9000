//
//  ViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 18/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit
import GameplayKit
import AVFoundation

class BasicClefViewController: UIViewController, AVAudioPlayerDelegate {
	
	// MARK: Outlets
	
	@IBOutlet weak var backView: UIView!
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var staffDrawingView: StaffDrawingView!
	@IBOutlet weak var notesDrawingView: StaffDrawingView!
	@IBOutlet weak var clefImageView: UIImageView!
	@IBOutlet weak var stemDrawingView: StemDrawingView!
	@IBOutlet weak var helpDrawingView: HelpDrawingView!
	
	@IBOutlet weak var welcomeView: UIView!
	@IBOutlet weak var lessonNumberLabel: UILabel!
	@IBOutlet weak var lessonTitleLabel: UILabel!
	@IBOutlet weak var lessonDescriptionLabel: UILabel!
	
	@IBOutlet weak var finishedView: UIView!
	@IBOutlet weak var finishedLabel: UILabel!
	@IBOutlet weak var nextLessonButton: UIButton!
	@IBOutlet weak var lessonPlanButton: UIButton!
	
	@IBOutlet weak var exitButton: UIBarButtonItem!
	
	@IBOutlet weak var cNoteButton: UIButton!
	@IBOutlet weak var dNoteButton: UIButton!
	@IBOutlet weak var eNoteButton: UIButton!
	@IBOutlet weak var fNoteButton: UIButton!
	@IBOutlet weak var gNoteButton: UIButton!
	@IBOutlet weak var aNoteButton: UIButton!
	@IBOutlet weak var bNoteButton: UIButton!
	
	var lesson: NoteLesson? {
		didSet {
			setupLesson()
		}
	}
	
	var goToNextLessonFlag: Bool = false // temporary solution
	
	private lazy var avPlayer:AVAudioPlayer = AVAudioPlayer()
	
	private var noteButtons = [UIButton]()
	private var noteNameValueDict = [String:Int]()
	private var noteNameDict = [Note:String]()
	
	var requiredCorrectNotes: Int = 10 // temporarily here
	private var currentProgress: Float = 0.0
	
	private var noteRange = (0,0)
	
	private var currentNote: Note?
	private var previousNote: Note?
	
	private var gaussianRand = false
	private let randSource = GKRandomSource()
	
	private var helpVisible = false
	
	// MARK: - Constants
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
		static let BackToLessonsViewSegueIdentifier = "backToLessons"
	}
	
	// MARK: - ViewController lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		
		noteButtons = [cNoteButton, gNoteButton, dNoteButton, aNoteButton, eNoteButton, bNoteButton, fNoteButton]
		
		currentNote = randomNoteInRange(noteRange, gauss: gaussianRand)
		previousNote = currentNote
		
		setupLesson()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		setupViews()
	}
	
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		staffDrawingView.drawStaff(withClef: nil, animated: false)
		drawNewNote(withDelay: 0, animated: false)
	}
	
	// MARK: - Button/view touches
	
	@IBAction func exitButtonTap(sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .Alert)
		let exitAction = UIAlertAction(title: "Quit", style: .Default, handler: {
			(_)in
			self.performSegueWithIdentifier(Constants.BackToLessonsViewSegueIdentifier, sender: self)
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
	
	@IBAction func hideWelcomeView(sender: UITapGestureRecognizer) {
		startLessonViewsAnimation()
		setupStaffView(lesson!.clef)
		helpDrawingView.drawHelp(lesson!.clef)
		hideWelcomeViewAnimation()
	}
	
	@IBAction func tapOnNoteView(sender: UITapGestureRecognizer) {
		if helpVisible {
			hideHelpAnimation()
		} else {
			loadFileIntoAVPlayer(noteNameDict[currentNote!]!)
			if avPlayer.playing {
				stopAVPLayer()
				loadFileIntoAVPlayer(noteNameDict[currentNote!]!)
				startAVPlayer()
			} else {
				startAVPlayer()
			}
			// Animation
			noteVibrateAnimation()
		}
	}
	
	@IBAction func swipeForHelp(sender: UISwipeGestureRecognizer) {
		if sender.direction == .Left {
			showHelpAnimation()
		} else if sender.direction == .Right {
			hideHelpAnimation()
		}
	}
	
	@IBAction func onHelpButton(sender: UIBarButtonItem) {
		if helpVisible {
			hideHelpAnimation()
		} else {
			showHelpAnimation()
		}
	}
	
	@IBAction func onNoteButton(sender: UIButton) {
		noteButtonsEnabled(false)
		
		if (currentNote!.rawValue % 7) == noteNameValueDict[sender.titleLabel!.text!] {
			
			staffDrawingView.drawGhostNote(currentNote!, progress: progressBar.progress)
			currentProgress += 1.0/Float(requiredCorrectNotes)
			NSTimer.scheduledTimerWithTimeInterval(0.45, target: self, selector: #selector(BasicClefViewController.addProgress), userInfo: nil, repeats: false)
			
			if currentProgress < 1.0 {
				previousNote = currentNote
				currentNote = randomNoteInRange(noteRange, gauss: gaussianRand)
				drawNewNote(withDelay: 0, animated: true)
			} else {
				finishedLesson()
			}
		} else {
			wrongAnimation()
		}
		
		hideHelpAnimation()
	}
	
	@IBAction func goToNextLesson() {
		goToNextLessonFlag = true
		performSegueWithIdentifier(Constants.BackToLessonsViewSegueIdentifier, sender: self)
	}
	
	
	// MARK: - Audio player
	
	private func loadFileIntoAVPlayer(note: String) {
		let fileURL:NSURL = NSBundle.mainBundle().URLForResource(note, withExtension: "wav", subdirectory: "Audio")!
		
		do {
			self.avPlayer = try AVAudioPlayer(contentsOfURL: fileURL)
		} catch {
			print("Could not create AVAudioPlayer")
		}
		
		//print("playing \(fileURL)")
		avPlayer.delegate = self
		avPlayer.prepareToPlay()
		avPlayer.volume = 1.0
	}
	
	private func startAVPlayer() {
		avPlayer.play()
	}
	
	private func stopAVPLayer() {
		if avPlayer.playing {
			avPlayer.stop()
		}
	}
	
	private func toggleAVPlayer() {
		if avPlayer.playing {
			avPlayer.pause()
		} else {
			avPlayer.play()
		}
	}
	
	// MARK: AVAudioPlayerDelegate
	
	func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
		//print("Finished playing \(flag)")
	}
	
	func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
		//print("\(error!.localizedDescription)")
	}
	
	// MARK: - Setup methods
	
	private func setupViews() {
		let nav = self.navigationController?.navigationBar
		
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
		
		for button in noteButtons {
			button.setTitleColor(ColorPalette.MidnightBlue, forState: .Normal)
		}
		
		progressBar.progressTintColor = ColorPalette.Nephritis
		progressBar.trackTintColor = UIColor.clearColor()
		progressBar.progress = 0
		
		welcomeView.backgroundColor = lesson!.color
		finishedView.backgroundColor = lesson!.color
		backView.backgroundColor = ColorPalette.Clouds
	}
	
	private func setupStaffView(clef: Clef) {
		clefImageView.image = UIImage(named: clef.rawValue)?.imageWithRenderingMode(.AlwaysTemplate)
		clefImageView.tintColor = ColorPalette.MidnightBlue
	}
	
	private func setupLesson() {
		if let ls = lesson {
			if ls.clef == .trebleClef {
				noteNameValueDict = trebleNotesNameValueDict
				noteNameDict = trebleNotesNameDict
			} else {
				noteNameValueDict = bassNotesNameValueDict
				noteNameDict = bassNotesNameDict
			}
			
			noteRange = ls.noteRange
			gaussianRand = ls.gauss
			navigationItem.title = ls.title
			lessonNumberLabel?.text = "Lesson \(ls.index)"
			lessonTitleLabel?.text = ls.title
			lessonDescriptionLabel?.text = ls.description
		}
	}
	
	// MARK: - Helper methods
	
	private func drawNewNote(withDelay delay: NSTimeInterval, animated: Bool) {
		stemDrawingView.setupStem(currentNote!, animated: animated)
		notesDrawingView.drawNote(currentNote!, withStem: false)
		if animated {
			noteSlideAnimation(delay)
		}
	}
	
	private func randomNoteInRange(range: (min: Int, max: Int), gauss: Bool) -> Note {
		var note: Note
		if gauss {
			let noteInRange = GKGaussianDistribution(randomSource: randSource, lowestValue: range.min, highestValue: range.max+1)
			note = Note(rawValue: noteInRange.nextInt())!
		} else {
			note = Note(rawValue: Int(arc4random_uniform(UInt32(range.max+1 - range.min))) + range.min)!
		}
	
		if note == previousNote {
			return randomNoteInRange(range, gauss: gauss)
		} else {
			return note
		}
	}
	
	private func noteButtonsEnabled(enabled: Bool) {
		for button in noteButtons {
			button.enabled = enabled
		}
	}
	
	func addProgress() { // can't be private if set as selector
		progressBar.setProgress(currentProgress, animated: true)
		staffDrawingView.layer.sublayers?.popLast()
		
		noteButtonsEnabled(true)
	}
	
	private func finishedLesson() {
		lesson!.complete = true
		
		noteButtonsEnabled(false)
		notesDrawingView.userInteractionEnabled = false
		notesDrawingView.layer.sublayers = nil
		stemDrawingView.layer.sublayers = nil
		
		finishedView.hidden	= false
		showFinishedViewAnimation()
	}
	
	// MARK: - Layout animations
	
	private func wrongAnimation() {
		self.notesDrawingView.center.x += Constants.WrongAnimationOffset
		self.stemDrawingView.center.x += Constants.WrongAnimationOffset
		self.staffDrawingView.center.x += Constants.WrongAnimationOffset
		self.clefImageView.center.x += Constants.WrongAnimationOffset
		
		noteButtonsEnabled(false)
		
		UIView.animateWithDuration(Constants.BasicAnimationDuration, delay: 0.0, usingSpringWithDamping: Constants.WrongAnimationDamping, initialSpringVelocity: Constants.WrongAnimationVelocity, options: [], animations: {
			self.notesDrawingView.center.x -= Constants.WrongAnimationOffset
			self.stemDrawingView.center.x -= Constants.WrongAnimationOffset
			self.staffDrawingView.center.x -= Constants.WrongAnimationOffset
			self.clefImageView.center.x -= Constants.WrongAnimationOffset
			}, completion: { finished in
				self.noteButtonsEnabled(true)
		})
	}
	
	private func showFinishedViewAnimation() {
		let nav = self.navigationController?.navigationBar
		//nav?.alpha = 1.0
		UIView.animateWithDuration(Constants.BasicAnimationDuration, delay: Constants.BasicAnimationDuration, options: [], animations: {
				self.finishedView.alpha = 1
			}, completion: { finished in
				nav?.alpha = 0.0
		})
	}
	
	private func showHelpAnimation() {
		 if !helpVisible {
			UIView.animateWithDuration(Constants.BasicAnimationDuration, animations: {
				self.helpDrawingView.alpha = 1.0
				self.helpDrawingView.center.x -= self.helpDrawingView.frame.width
				self.helpVisible = true
			})
		}
	}
	
	private func hideHelpAnimation() {
		if helpVisible {
			UIView.animateWithDuration(Constants.BasicAnimationDuration, animations: {
				self.helpDrawingView.alpha = 0.0
				self.helpDrawingView.center.x += self.helpDrawingView.frame.width
				self.helpVisible = false
			})
		}
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
	
	private func noteSlideAnimation(delay: NSTimeInterval) {
		notesDrawingView.center.x += self.view.bounds.width
		stemDrawingView.center.x += self.view.bounds.width
		UIView.animateWithDuration(Constants.BasicAnimationDuration/2, delay: delay, options: [.CurveEaseIn], animations: {
			self.notesDrawingView.center.x -= self.view.bounds.width
			self.stemDrawingView.center.x -= self.view.bounds.width
			}, completion: { finished in
				self.noteVibrateAnimation()
		})
	}
	
	private func noteVibrateAnimation() {
		stemDrawingView.animateNoteStem()
		notesDrawingView.center.x += Constants.NoteVibrateAnimationOffset
		stemDrawingView.center.x += Constants.NoteVibrateAnimationOffset
		UIView.animateWithDuration(Constants.BasicAnimationDuration, delay: 0.0, usingSpringWithDamping: Constants.NoteVibrateAnimationDamping, initialSpringVelocity: Constants.NoteVibrateAnimationVelocity, options: [], animations: { () -> Void in
			self.notesDrawingView.center.x -= Constants.NoteVibrateAnimationOffset
			self.stemDrawingView.center.x -= Constants.NoteVibrateAnimationOffset
			}, completion: nil)
	}
	
	private func startLessonViewsAnimation() {
		var buttonAnimationDelay = 0.0
		var buttonAnimationDelayScale = 0.0
		for button in noteButtons {
			animateButton(button, withDuration: Constants.BasicAnimationDuration, andDelay: Constants.ButtonAnimationStartDelay+buttonAnimationDelay)
			buttonAnimationDelayScale += 0.5
			buttonAnimationDelay = Constants.ButtonAnimationDelay*buttonAnimationDelayScale
		}
		
		//Clef ImageView Animation
		staffDrawingView.drawStaff(withClef: nil, animated: true)
		clefImageView.center.x += self.view.bounds.width
		UIView.animateWithDuration(Constants.BasicAnimationDuration, delay: Constants.ButtonAnimationStartDelay+0.1, usingSpringWithDamping: Constants.ClefAnimationDamping, initialSpringVelocity: Constants.ButtonAnimationVelocity, options: [], animations: {
			self.clefImageView.center.x -= self.view.bounds.width
			}, completion: nil)
		
		//Note slide animation
		drawNewNote(withDelay: Constants.ButtonAnimationStartDelay+0.3, animated: true)
	}
	
	private func animateButton(button: UIButton, withDuration duration: Double, andDelay delay: Double) {
		button.center.y += self.view.bounds.height/2
		UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: Constants.ButtonAnimationDamping, initialSpringVelocity: Constants.ButtonAnimationVelocity, options: [], animations: {
			button.center.y -= self.view.bounds.height/2
			}, completion: nil)
	}
}
