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
	
	var avPlayer:AVAudioPlayer = AVAudioPlayer()
	
	var noteButtons: [UIButton] = []
	var noteNameValueDict: [String:Int] = [:]
	var noteNameDict: [Note:String] = [:]
	
	var lesson:noteLesson? {
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

	override func viewDidLoad() {
		super.viewDidLoad()
		
		noteButtons = [cNoteButton, dNoteButton, eNoteButton, fNoteButton, gNoteButton, aNoteButton, bNoteButton]
		
		view.layoutIfNeeded()
		
		animateViews()
		setupStaffView(clef!)

		currentNote = randomNoteInRange(noteRange, gauss: gaussianRand)
		previousNote = currentNote
		
		helpDrawingView.drawHelp(clef!)
	}
	
	override func viewWillAppear(animated: Bool) {
		let nav = self.navigationController?.navigationBar
		nav?.barStyle = UIBarStyle.Black
		//nav?.barTintColor = UIColor.whiteColor()
		//nav?.tintColor = UIColor.blackColor()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
		
		self.presentViewController(alert, animated: true, completion: nil)
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
		
		// TODO: remove color flash
		if (currentNote!.rawValue % 7) == noteNameValueDict[sender.titleLabel!.text!] {
			self.staffDrawingView.backgroundColor = UIColor(red: 0.5, green: 1, blue: 0.5, alpha: 1)
		} else {
			self.staffDrawingView.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
		}
		// ====
		
		previousNote = currentNote
		currentNote = randomNoteInRange(noteRange, gauss: gaussianRand)
		
		drawNewNote()
		
		hideHelp()
		
		// TODO: remove color flash
		UIView.animateWithDuration(0.5, animations: {
			self.staffDrawingView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
			}, completion: { finished in
				self.noteButtonsEnabled(true)
		})
	}
	
	// MARK: Audio player methods
	
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
		print("\(error!.localizedDescription)")
	}
	
	// MARK: Setup methods
	
	func drawNewNote() {
		stemDrawingView.setupStem(currentNote!, animated: true)
		notesDrawingView.drawNote(currentNote!, animated: true)
	}
	
	func setupStaffView(clef: Clef) {
		clefImageView.image = UIImage(named: clef.rawValue)
		staffDrawingView.drawStaff(animated: true)
	}
	
	func setupLesson() {
		clef = (lesson?.clef)!
		noteRange = (lesson?.noteRange)!
		gaussianRand = (lesson?.gauss)!
		navigationItem.title = lesson?.title
	}
	
	// MARK: Random note seleciton method
	
	func randomNoteInRange(range: (Int, Int), gauss: Bool) -> Note {
		var note: Note
		if gauss {
			let noteInRange = GKGaussianDistribution(randomSource: randSource, lowestValue: range.0, highestValue: range.1+1)
			note = Note(rawValue: noteInRange.nextInt())!
		} else {
			note = Note(rawValue: Int(arc4random_uniform(UInt32(range.1+1 - range.0))) + range.0)!
		}
		
		if note == previousNote {
			return randomNoteInRange(range, gauss: gauss)
		} else {
			return note
		}
	}
	
	// MARK: Layout animation method
	
	func showHelp() {
		 if !helpVisible {
			UIView.animateWithDuration(0.4, animations: {
				self.helpDrawingView.alpha = 1.0
				self.helpDrawingView.center.x -= self.helpDrawingView.frame.width
				self.helpVisible = true
			})
		}
	}
	
	func hideHelp() {
		if helpVisible {
			UIView.animateWithDuration(0.4, animations: {
				self.helpDrawingView.alpha = 0.0
				self.helpDrawingView.center.x += self.helpDrawingView.frame.width
				self.helpVisible = false
			})
		}
	}
	
	func noteVibrateAnimation() {
		stemDrawingView.animateNoteStem()
		notesDrawingView.center.x += 10
		stemDrawingView.center.x += 10
		UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.05, initialSpringVelocity: 8.0, options: [], animations: { () -> Void in
			self.notesDrawingView.center.x -= 10
			self.stemDrawingView.center.x -= 10
			}, completion: nil)
	}
	
	func animateViews() {
		cNoteButton.center.y += self.view.bounds.height/2
		dNoteButton.center.y += self.view.bounds.height/2
		eNoteButton.center.y += self.view.bounds.height/2
		fNoteButton.center.y += self.view.bounds.height/2
		gNoteButton.center.y += self.view.bounds.height/2
		aNoteButton.center.y += self.view.bounds.height/2
		bNoteButton.center.y += self.view.bounds.height/2
		clefImageView.center.x += self.view.bounds.width
		
		let duration = 0.4
		let startDelay = 0.5
		let delay = 0.1
		let damping:CGFloat = 0.6
		let velocity:CGFloat = 1.0
		let options:UIViewAnimationOptions = []
		
		UIView.animateWithDuration(duration, delay: startDelay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
			self.cNoteButton.center.y -= self.view.bounds.height/2
			}, completion: nil)
		UIView.animateWithDuration(duration, delay: startDelay+delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
			self.dNoteButton.center.y -= self.view.bounds.height/2
			}, completion: nil)
		UIView.animateWithDuration(duration, delay: startDelay+delay*2, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
			self.eNoteButton.center.y -= self.view.bounds.height/2
			}, completion: nil)
		UIView.animateWithDuration(duration, delay: startDelay+delay*3, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
			self.fNoteButton.center.y -= self.view.bounds.height/2
			}, completion: nil)
		UIView.animateWithDuration(duration, delay: startDelay+delay*1.5, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
			self.gNoteButton.center.y -= self.view.bounds.height/2
			}, completion: nil)
		UIView.animateWithDuration(duration, delay: startDelay+delay*2.5, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
			self.aNoteButton.center.y -= self.view.bounds.height/2
			}, completion: nil)
		UIView.animateWithDuration(duration, delay: startDelay+delay*3.5, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
			self.bNoteButton.center.y -= self.view.bounds.height/2
			}, completion: nil)
		// Clef ImageView Animation
		UIView.animateWithDuration(duration, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: velocity, options: options, animations: {
			self.clefImageView.center.x -= self.view.bounds.width
			}, completion: { finished in
				self.drawNewNote()
				self.noteVibrateAnimation()
		})
	}
	
	// MARK: Other methods
	
	func noteButtonsEnabled(state: Bool){
		for button in noteButtons {
			button.enabled = state
		}
	}
}