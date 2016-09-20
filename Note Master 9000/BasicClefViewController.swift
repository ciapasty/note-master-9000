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
	
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var staffDrawingView: StaffDrawingView!
	@IBOutlet weak var notesDrawingView: StaffDrawingView!
	@IBOutlet weak var clefImageView: UIImageView!
	@IBOutlet weak var stemDrawingView: StemDrawingView!
	@IBOutlet weak var helpDrawingView: HelpDrawingView!
	
	@IBOutlet weak var cNoteButton: UIButton!
	@IBOutlet weak var dNoteButton: UIButton!
	@IBOutlet weak var eNoteButton: UIButton!
	@IBOutlet weak var fNoteButton: UIButton!
	@IBOutlet weak var gNoteButton: UIButton!
	@IBOutlet weak var aNoteButton: UIButton!
	@IBOutlet weak var bNoteButton: UIButton!
	
	var lesson: NoteLesson? {
		didSet {
			if lesson != nil {
				setupLesson()
			}
		}
	}
	
	var goToNextLessonFlag: Bool = false // temporary solution
	
	private lazy var avPlayer:AVAudioPlayer = AVAudioPlayer()
	
	private var noteButtons = [UIButton]()
	private var noteNameValueDict = [String:Int]()
	private var noteNameDict = [Note:String]()
	
	var requiredCorrectNotes: Int = 10 // temporarily here
	private var currentProgress: Float = 0.0
	private var currentNote: Note?
	private var previousNote: Note?
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
	}
	
	// MARK: - ViewController lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		
		noteButtons = [cNoteButton, gNoteButton, dNoteButton, aNoteButton, eNoteButton, bNoteButton, fNoteButton]
		setupViews()
	}
	
	override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
		staffDrawingView.drawStaff(withClef: nil, animated: false)
		drawNewNote(withDelay: 0, animated: false)
	}
	
	// MARK: - Button/view touches
	
	@IBAction func tapOnNoteView(_ sender: UITapGestureRecognizer) {
		if helpVisible {
			hideHelpAnimation()
		} else {
			loadFileIntoAVPlayer(noteNameDict[currentNote!]!)
			if avPlayer.isPlaying {
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
	
	@IBAction func swipeForHelp(_ sender: UISwipeGestureRecognizer) {
		if sender.direction == .left {
			if !helpVisible {
				showHelpAnimation()
			}
		} else if sender.direction == .right {
			if helpVisible {
				hideHelpAnimation()
			}
		}
	}
	
	@IBAction func onNoteButton(_ sender: UIButton) {
		noteButtonsEnabled(false)
		
		if (currentNote!.rawValue % 7) == noteNameValueDict[sender.titleLabel!.text!] {
			
			staffDrawingView.drawGhostNote(currentNote!, progress: progressBar.progress)
			currentProgress += 1.0/Float(requiredCorrectNotes)
			Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(BasicClefViewController.addProgress), userInfo: nil, repeats: false)
			
			if currentProgress < 1.0 {
				previousNote = currentNote
				currentNote = randomNoteInRange(lesson!.noteRange, gauss: lesson!.gauss)
				drawNewNote(withDelay: 0, animated: true)
			} else {
				finishedLesson()
			}
		} else {
			wrongAnimation()
		}
		
		hideHelpAnimation()
	}
	
	// MARK: - Audio player
	
	private func loadFileIntoAVPlayer(_ note: String) {
		let fileURL:URL = Bundle.main.url(forResource: note, withExtension: "wav", subdirectory: "Audio")!
		
		do {
			self.avPlayer = try AVAudioPlayer(contentsOf: fileURL)
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
		if avPlayer.isPlaying {
			avPlayer.stop()
		}
	}
	
	private func toggleAVPlayer() {
		if avPlayer.isPlaying {
			avPlayer.pause()
		} else {
			avPlayer.play()
		}
	}
	
	// MARK: AVAudioPlayerDelegate
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		//print("Finished playing \(flag)")
	}
	
	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
		//print("\(error!.localizedDescription)")
	}
	
	// MARK: - Setup methods
	
	private func setupViews() {
		for button in noteButtons {
			button.setTitleColor(ColorPalette.MidnightBlue, for: UIControlState())
		}
		
		progressBar.progressTintColor = ColorPalette.Nephritis
		progressBar.trackTintColor = UIColor.clear
		progressBar.progress = 0
		
		view.backgroundColor = ColorPalette.Clouds
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
			
			currentNote = randomNoteInRange(lesson!.noteRange, gauss: lesson!.gauss)
			previousNote = currentNote
			
			startLessonViewsAnimation()
			setupStaffView(lesson!.clef)
			helpDrawingView.drawHelp(lesson!.clef)
			
			drawNewNote(withDelay: Constants.BasicAnimationDuration, animated: true)
		}
	}
	
	private func setupStaffView(_ clef: Clef) {
		clefImageView.image = UIImage(named: clef.rawValue)?.withRenderingMode(.alwaysTemplate)
		clefImageView.tintColor = ColorPalette.MidnightBlue
	}
	
	// MARK: - Helper methods
	
	private func drawNewNote(withDelay delay: TimeInterval, animated: Bool) {
		stemDrawingView.setupStem(currentNote!, animated: animated)
		notesDrawingView.drawNote(currentNote!, withStem: false)
		if animated {
			noteSlideAnimation(delay)
		}
	}
	
	private func randomNoteInRange(_ range: (min: Int, max: Int), gauss: Bool) -> Note {
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
	
	private func noteButtonsEnabled(_ enabled: Bool) {
		for button in noteButtons {
			button.isEnabled = enabled
		}
	}
	
	func addProgress() { // can't be private if set as selector
		progressBar.setProgress(currentProgress, animated: true)
		let _ = staffDrawingView.layer.sublayers?.popLast()
		
		noteButtonsEnabled(true)
	}
	
	private func finishedLesson() {
		lesson!.complete = true
		
		noteButtonsEnabled(false)
		notesDrawingView.isUserInteractionEnabled = false
		notesDrawingView.layer.sublayers = nil
		stemDrawingView.layer.sublayers = nil
		
		// TODO: signal LessonViewController
	}
	
	// MARK: - Layout animations
	
	private func wrongAnimation() {
		self.notesDrawingView.center.x += Constants.WrongAnimationOffset
		self.stemDrawingView.center.x += Constants.WrongAnimationOffset
		self.staffDrawingView.center.x += Constants.WrongAnimationOffset
		self.clefImageView.center.x += Constants.WrongAnimationOffset
		
		noteButtonsEnabled(false)
		
		UIView.animate(withDuration: Constants.BasicAnimationDuration, delay: 0.0, usingSpringWithDamping: Constants.WrongAnimationDamping, initialSpringVelocity: Constants.WrongAnimationVelocity, options: [], animations: {
			self.notesDrawingView.center.x -= Constants.WrongAnimationOffset
			self.stemDrawingView.center.x -= Constants.WrongAnimationOffset
			self.staffDrawingView.center.x -= Constants.WrongAnimationOffset
			self.clefImageView.center.x -= Constants.WrongAnimationOffset
			}, completion: { finished in
				self.noteButtonsEnabled(true)
		})
	}
	
	private func showHelpAnimation() {
		 if !helpVisible {
			UIView.animate(withDuration: Constants.BasicAnimationDuration, animations: {
				self.helpDrawingView.alpha = 1.0
				self.helpDrawingView.center.x -= self.helpDrawingView.frame.width
				self.helpVisible = true
			})
		}
	}
	
	private func hideHelpAnimation() {
		if helpVisible {
			UIView.animate(withDuration: Constants.BasicAnimationDuration, animations: {
				self.helpDrawingView.alpha = 0.0
				self.helpDrawingView.center.x += self.helpDrawingView.frame.width
				self.helpVisible = false
			})
		}
	}
	
	private func noteSlideAnimation(_ delay: TimeInterval) {
		notesDrawingView.center.x += self.view.bounds.width
		stemDrawingView.center.x += self.view.bounds.width
		UIView.animate(withDuration: Constants.BasicAnimationDuration/2, delay: delay, options: [.curveEaseIn], animations: {
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
		UIView.animate(withDuration: Constants.BasicAnimationDuration, delay: 0.0, usingSpringWithDamping: Constants.NoteVibrateAnimationDamping, initialSpringVelocity: Constants.NoteVibrateAnimationVelocity, options: [], animations: { () -> Void in
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
		UIView.animate(withDuration: Constants.BasicAnimationDuration, delay: Constants.ButtonAnimationStartDelay+0.1, usingSpringWithDamping: Constants.ClefAnimationDamping, initialSpringVelocity: Constants.ButtonAnimationVelocity, options: [], animations: {
			self.clefImageView.center.x -= self.view.bounds.width
			}, completion: nil)
		
		//Note slide animation
		drawNewNote(withDelay: Constants.ButtonAnimationStartDelay+0.3, animated: true)
	}
	
	private func animateButton(_ button: UIButton, withDuration duration: Double, andDelay delay: Double) {
		button.center.y += self.view.bounds.height/2
		UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: Constants.ButtonAnimationDamping, initialSpringVelocity: Constants.ButtonAnimationVelocity, options: [], animations: {
			button.center.y -= self.view.bounds.height/2
			}, completion: nil)
	}
}
