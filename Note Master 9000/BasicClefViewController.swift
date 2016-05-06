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
		
		currentNote = randomNoteInRange(noteRange, gauss: gaussianRand)
		previousNote = currentNote
		
		animateViews()
		setupStaffView(clef!)
		
		helpDrawingView.drawHelp(clef!)
	}
	
	override func viewWillAppear(animated: Bool) {
		let nav = self.navigationController?.navigationBar
		nav?.barStyle = UIBarStyle.Black
		nav?.barTintColor = palette.light
		nav?.tintColor = palette.dark
		nav?.titleTextAttributes = [NSForegroundColorAttributeName: palette.dark]
		
		backView.backgroundColor = palette.light
		
		for button in noteButtons {
			button.setTitleColor(palette.dark, forState: .Normal)
		}
		
		clefImageView.image = clefImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
		clefImageView.tintColor = palette.dark
		
		progressBar.progressTintColor = palette.green
		progressBar.trackTintColor = palette.darkTrans
		progressBar.progress = 0
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
		
		let subview = alert.view.subviews.first! as UIView
		let alertContentView = subview.subviews.first! as UIView
		alertContentView.backgroundColor = palette.light
		
		self.presentViewController(alert, animated: true, completion: nil)
		
		alert.view.tintColor = palette.darkBlue
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
			
			drawGhostNote()
			NSTimer.scheduledTimerWithTimeInterval(0.45, target: self, selector: #selector(BasicClefViewController.addProgress), userInfo: nil, repeats: false)
			
			previousNote = currentNote
			currentNote = randomNoteInRange(noteRange, gauss: gaussianRand)
			
			drawNewNote(0)
		} else {
			wrongAnimation()
		}
		
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
		//print("\(error!.localizedDescription)")
	}
	
	// MARK: Setup methods
	
	func drawNewNote(delay: NSTimeInterval) {
		stemDrawingView.setupStem(currentNote!, animated: true)
		notesDrawingView.drawNote(currentNote!, color: palette.dark, animated: true)
		noteSlideAnimation(delay)
	}
	
	func drawGhostNote() {// -> UIBezierPath {
		let layer = CALayer()
		
		let noteHeight = staffDrawingView.frame.height/12
		let noteWidth = noteHeight*1.5
		let noteRect = CGRect(
			x: (staffDrawingView.frame.width*3/5)-(noteWidth/2),
			y: (staffDrawingView.frame.height*CGFloat(Double(currentNote!.rawValue)/20.0))-(noteHeight/2),
			width: noteWidth, height: noteHeight)
		
		layer.frame = staffDrawingView.frame
		
		layer.addSublayer(staffDrawingView.drawNoteLayer(currentNote!, noteRect: noteRect, color: palette.greenTrans))
		layer.addSublayer(staffDrawingView.drawNoteStem(currentNote!, noteRect: noteRect, color: palette.greenTrans))
		
		staffDrawingView.layer.addSublayer(layer)
		
		let anim = CAKeyframeAnimation(keyPath: "position")
		anim.path = drawGhostPath().CGPath
		anim.duration = 0.5
		
		var scaling:CATransform3D = layer.transform
		scaling = CATransform3DScale(scaling, 0.01, 0.01, 1.0)
		let scale = CABasicAnimation(keyPath: "transform")
		scale.duration = 0.5
		scale.toValue = NSValue.init(CATransform3D: scaling)
		
		layer.addAnimation(scale, forKey: "transformAnimation")
		layer.addAnimation(anim, forKey: "animate position along path")
		
	}
	
	func drawGhostPath() -> UIBezierPath {
		//let layer = CAShapeLayer()
		let bezierStart = CGPoint(x: staffDrawingView.frame.width/2,
		                          y: staffDrawingView.frame.height/2)
		let bezierEnd = CGPoint(x: staffDrawingView.frame.width*CGFloat(progressBar.progress),
		                        y: 0)
		let control = CGPoint(x: staffDrawingView.frame.width/2, y: 0)
		let path = UIBezierPath()
		
		path.moveToPoint(bezierStart)
		path.addQuadCurveToPoint(bezierEnd, controlPoint: control)
		
		return path
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
	
	func wrongAnimation() {
		
		let shake:CGFloat = 12
		
		self.notesDrawingView.center.x += shake
		self.stemDrawingView.center.x += shake
		self.staffDrawingView.center.x += shake
		self.clefImageView.center.x += shake
		
		noteButtonsEnabled(false)
		
		UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 8.0, options: [], animations: { () -> Void in
			self.notesDrawingView.center.x -= shake
			self.stemDrawingView.center.x -= shake
			self.staffDrawingView.center.x -= shake
			self.clefImageView.center.x -= shake
			}, completion: { finished in
				self.noteButtonsEnabled(true)
		})
	}
	
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
	
	func noteSlideAnimation(delay: NSTimeInterval) {
		notesDrawingView.center.x += self.view.bounds.width
		stemDrawingView.center.x += self.view.bounds.width
		UIView.animateWithDuration(0.2, delay: delay, options: [.CurveEaseIn], animations: {
			self.notesDrawingView.center.x -= self.view.bounds.width
			self.stemDrawingView.center.x -= self.view.bounds.width
			}, completion: { finished in
				self.noteVibrateAnimation()
		})
	}
	
	func noteVibrateAnimation() {
		stemDrawingView.animateNoteStem()
		notesDrawingView.center.x += 7
		stemDrawingView.center.x += 7
		UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.05, initialSpringVelocity: 8.0, options: [], animations: { () -> Void in
			self.notesDrawingView.center.x -= 7
			self.stemDrawingView.center.x -= 7
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
			}, completion: nil)
		
		//Note slide animation
		drawNewNote(0.8)
	}
	
	// MARK: Other methods
	
	func noteButtonsEnabled(state: Bool) {
		for button in noteButtons {
			button.enabled = state
		}
	}
	
	func addProgress() {
		progressBar.setProgress(progressBar.progress+0.05, animated: true)
		staffDrawingView.layer.sublayers?.popLast()
	}
}
