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
	
	@IBOutlet var backView: UIView!
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var staffDrawingView: StaffDrawingView!
	@IBOutlet weak var notesDrawingView: StaffDrawingView!
	@IBOutlet weak var clefImageView: UIImageView!
	@IBOutlet weak var stemDrawingView: StemDrawingView!
	@IBOutlet weak var helpDrawingView: HelpDrawingView!
	
	@IBOutlet weak var exitButton: UIBarButtonItem!
	
	@IBOutlet weak var cNoteButton: UIButton!
	@IBOutlet weak var dNoteButton: UIButton!
	@IBOutlet weak var eNoteButton: UIButton!
	@IBOutlet weak var fNoteButton: UIButton!
	@IBOutlet weak var gNoteButton: UIButton!
	@IBOutlet weak var aNoteButton: UIButton!
	@IBOutlet weak var bNoteButton: UIButton!
	
	// MARK: Properties
	
	var avPlayer:AVAudioPlayer = AVAudioPlayer()
	
	var noteButtons = [UIButton]()
	var noteNameValueDict = [String:Int]()
	var noteNameDict = [Note:String]()
	
	var lesson:NoteLesson? {
		didSet {
			setupLesson()
		}
	}
	
	var clef: Clef? {
		didSet {
			if clef == .trebleClef {
				noteNameValueDict = trebleNotesNameValueDict
				noteNameDict = trebleNotesNameDict
			} else {
				noteNameValueDict = bassNotesNameValueDict
				noteNameDict = bassNotesNameDict
			}
		}
	}
	
	var noteRange = (0,0)
	
	var currentNote: Note?
	var previousNote: Note?
	
	var gaussianRand = false
	let randSource = GKRandomSource()
	
	var helpVisible = false
	
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

	}
	
	// MARK: ViewController

	override func viewDidLoad() {
		super.viewDidLoad()
		
		noteButtons = [cNoteButton, gNoteButton, dNoteButton, aNoteButton, eNoteButton, bNoteButton, fNoteButton]
		
		view.layoutIfNeeded()
		
		currentNote = randomNoteInRange(noteRange, gauss: gaussianRand)
		previousNote = currentNote
		
		animateViews()
		setupStaffView(clef!)
		
		helpDrawingView.drawHelp(clef!)
	}
	
	override func viewWillAppear(animated: Bool) {
		let nav = self.navigationController?.navigationBar
		nav?.barStyle = UIBarStyle.Black
		nav?.barTintColor = palette.light.base()
		nav?.tintColor = palette.dark.base()
		nav?.titleTextAttributes = [NSForegroundColorAttributeName: (lesson?.color.base())!]
		
		backView.backgroundColor = palette.light.base()
		
		for button in noteButtons {
			button.setTitleColor(palette.dark.base(), forState: .Normal)
		}
		
		clefImageView.image = clefImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
		clefImageView.tintColor = palette.dark.base()
		
		progressBar.progressTintColor = palette.green.light()
		progressBar.trackTintColor = palette.dark.trans()
		progressBar.progress = 0
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		staffDrawingView.drawStaff(withClef: nil, animated: false)
		drawNewNote(withDelay: 0, animated: false)
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	// MARK: Button/view touches
	
	@IBAction func exitButtonTap(sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .Alert)
		let exitAction = UIAlertAction(title: "Quit", style: .Default, handler: {
			(_)in
			self.performSegueWithIdentifier("backToLessons", sender: self)
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
		
		alert.addAction(exitAction)
		alert.addAction(cancelAction)
		
		let subview = alert.view.subviews.first! as UIView
		let alertContentView = subview.subviews.first! as UIView
		alertContentView.backgroundColor = palette.light.base()
		
		self.presentViewController(alert, animated: true, completion: nil)
		
		alert.view.tintColor = lesson?.color.base()
	}
	
	@IBAction func tapOnNoteView(sender: UITapGestureRecognizer) {
		if helpVisible {
			hideHelp()
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
			showHelp()
		} else if sender.direction == .Right {
			hideHelp()
		}
	}
	
	@IBAction func onHelpButton(sender: UIBarButtonItem) {
		if helpVisible {
			hideHelp()
		} else {
			showHelp()
		}
	}
	
	@IBAction func onNoteButton(sender: UIButton) {
		noteButtonsEnabled(false)
		
		if (currentNote!.rawValue % 7) == noteNameValueDict[sender.titleLabel!.text!] {
			
			staffDrawingView.drawGhostNote(currentNote!, progress: progressBar.progress)
			NSTimer.scheduledTimerWithTimeInterval(0.45, target: self, selector: #selector(BasicClefViewController.addProgress), userInfo: nil, repeats: false)
			
			previousNote = currentNote
			currentNote = randomNoteInRange(noteRange, gauss: gaussianRand)
			
			drawNewNote(withDelay: 0, animated: true)
		} else {
			wrongAnimation()
		}
		
		hideHelp()
	}
	
	// MARK: Audio player
	
	func loadFileIntoAVPlayer(note: String) {
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
	
	func startAVPlayer() {
		avPlayer.play()
	}
	
	func stopAVPLayer() {
		if avPlayer.playing {
			avPlayer.stop()
		}
	}
	
	func toggleAVPlayer() {
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
	
	// MARK: Drawing methods
	
	func drawNewNote(withDelay delay: NSTimeInterval, animated: Bool) {
		stemDrawingView.setupStem(currentNote!, animated: animated)
		notesDrawingView.drawNote(currentNote!)
		if animated {
			noteSlideAnimation(delay)
		}
	}
	
	// MARK: Setup methods
	
	func setupStaffView(clef: Clef) {
		clefImageView.image = UIImage(named: clef.rawValue)
		staffDrawingView.drawStaff(withClef: nil, animated: true)
	}
	
	func setupLesson() {
		clef = (lesson?.clef)!
		noteRange = (lesson?.noteRange)!
		gaussianRand = (lesson?.gauss)!
		navigationItem.title = lesson?.title
	}
	
	// MARK: Other methods
	
	func randomNoteInRange(range: (min: Int, max: Int), gauss: Bool) -> Note {
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
	
	func noteButtonsEnabled(state: Bool) {
		for button in noteButtons {
			button.enabled = state
		}
	}
	
	func addProgress() {
		progressBar.setProgress(progressBar.progress+0.05, animated: true)
		staffDrawingView.layer.sublayers?.popLast()
		
		noteButtonsEnabled(true)
		
		if progressBar.progress == 1.0 {
			lesson!.complete = true
			performSegueWithIdentifier("backToLessons", sender: self)
		}
	}
	
	// MARK: Layout animations
	
	func wrongAnimation() {
		self.notesDrawingView.center.x += Constants.WrongAnimationOffset
		self.stemDrawingView.center.x += Constants.WrongAnimationOffset
		self.staffDrawingView.center.x += Constants.WrongAnimationOffset
		self.clefImageView.center.x += Constants.WrongAnimationOffset
		
		noteButtonsEnabled(false)
		
		UIView.animateWithDuration(Constants.BasicAnimationDuration, delay: 0.0, usingSpringWithDamping: Constants.WrongAnimationDamping, initialSpringVelocity: Constants.WrongAnimationVelocity, options: [], animations: { () -> Void in
			self.notesDrawingView.center.x -= Constants.WrongAnimationOffset
			self.stemDrawingView.center.x -= Constants.WrongAnimationOffset
			self.staffDrawingView.center.x -= Constants.WrongAnimationOffset
			self.clefImageView.center.x -= Constants.WrongAnimationOffset
			}, completion: { finished in
				self.noteButtonsEnabled(true)
		})
	}
	
	func showHelp() {
		 if !helpVisible {
			UIView.animateWithDuration(Constants.BasicAnimationDuration, animations: {
				self.helpDrawingView.alpha = 1.0
				self.helpDrawingView.center.x -= self.helpDrawingView.frame.width
				self.helpVisible = true
			})
		}
	}
	
	func hideHelp() {
		if helpVisible {
			UIView.animateWithDuration(Constants.BasicAnimationDuration, animations: {
				self.helpDrawingView.alpha = 0.0
				self.helpDrawingView.center.x += self.helpDrawingView.frame.width
				self.helpVisible = false
			})
		}
	}
	
	func noteSlideAnimation(delay: NSTimeInterval) {
		notesDrawingView.center.x += self.view.bounds.width
		stemDrawingView.center.x += self.view.bounds.width
		UIView.animateWithDuration(Constants.BasicAnimationDuration/2, delay: delay, options: [.CurveEaseIn], animations: {
			self.notesDrawingView.center.x -= self.view.bounds.width
			self.stemDrawingView.center.x -= self.view.bounds.width
			}, completion: { finished in
				self.noteVibrateAnimation()
		})
	}
	
	func noteVibrateAnimation() {
		stemDrawingView.animateNoteStem()
		notesDrawingView.center.x += Constants.NoteVibrateAnimationOffset
		stemDrawingView.center.x += Constants.NoteVibrateAnimationOffset
		UIView.animateWithDuration(Constants.BasicAnimationDuration, delay: 0.0, usingSpringWithDamping: Constants.NoteVibrateAnimationDamping, initialSpringVelocity: Constants.NoteVibrateAnimationVelocity, options: [], animations: { () -> Void in
			self.notesDrawingView.center.x -= Constants.NoteVibrateAnimationOffset
			self.stemDrawingView.center.x -= Constants.NoteVibrateAnimationOffset
			}, completion: nil)
	}
	
	func animateViews() {
		var buttonAnimationDelay = 0.0
		var buttonAnimationDelayScale = 0.0
		for button in noteButtons {
			animate(button: button, withDuration: Constants.BasicAnimationDuration, andDelay: Constants.ButtonAnimationStartDelay+buttonAnimationDelay)
			buttonAnimationDelayScale += 0.5
			buttonAnimationDelay = Constants.ButtonAnimationDelay*buttonAnimationDelayScale
		}
		
		//Clef ImageView Animation
		clefImageView.center.x += self.view.bounds.width
		UIView.animateWithDuration(Constants.BasicAnimationDuration, delay: Constants.ButtonAnimationStartDelay+0.1, usingSpringWithDamping: Constants.ClefAnimationDamping, initialSpringVelocity: Constants.ButtonAnimationVelocity, options: [], animations: {
			self.clefImageView.center.x -= self.view.bounds.width
			}, completion: nil)
		
		//Note slide animation
		drawNewNote(withDelay: Constants.ButtonAnimationStartDelay+0.3, animated: true)
	}
	
	func animate(button button: UIButton, withDuration duration: Double, andDelay delay: Double) {
		button.center.y += self.view.bounds.height/2
		UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: Constants.ButtonAnimationDamping, initialSpringVelocity: Constants.ButtonAnimationVelocity, options: [], animations: {
			button.center.y -= self.view.bounds.height/2
			}, completion: nil)
	}
}
