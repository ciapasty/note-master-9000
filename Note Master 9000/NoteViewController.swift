//
//  ViewController.swift
//  Note Master 9000
//
//  Created by Maciej Eichler on 18/03/16.
//  Copyright © 2016 Mattijah. All rights reserved.
//

import UIKit
import CoreData
import GameplayKit
import AVFoundation

class NoteViewController: UIViewController {
	
	// MARK: Outlets
	
	@IBOutlet weak var progressBar: UIProgressView!
	@IBOutlet weak var staffDrawingView: StaffDrawingView!
	@IBOutlet weak var notesDrawingView: StaffDrawingView!
	@IBOutlet weak var clefImageView: UIImageView!
	@IBOutlet weak var helpDrawingView: HelpDrawingView!
	
	@IBOutlet weak var cNoteButton: UIButton!
	@IBOutlet weak var dNoteButton: UIButton!
	@IBOutlet weak var eNoteButton: UIButton!
	@IBOutlet weak var fNoteButton: UIButton!
	@IBOutlet weak var gNoteButton: UIButton!
	@IBOutlet weak var aNoteButton: UIButton!
	@IBOutlet weak var bNoteButton: UIButton!
	
	// MARK: - Model
	var lesson: NoteLesson? {
		didSet {
			if lesson != nil {
				setupLesson()
			} else {
				resetLesson()
			}
		}
	}

    // MARK: -
    var parentVC: LessonsViewController?
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var avPlayer: AVAudioPlayer = AVAudioPlayer()
    
	private var noteButtons = [UIButton]()
	private var noteNameValueDict = [String:Int]()
	private var noteNameDict = [Note:String]()
	
	private var currentProgress: Float = 0.0
    private var noteSet: [Note]?
	private var currentNote: Note?
	private var previousNote: Note?
	private let randSource = GKRandomSource()
	private var helpVisible = false
	
	// MARK: -
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
		
		static let RequiredCorrectNotes = 20
	}
	
	// MARK: - ViewController lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		
		noteButtons = [cNoteButton, gNoteButton, dNoteButton, aNoteButton, eNoteButton, bNoteButton, fNoteButton]
		setupViews()
	}
	
//	override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
//		staffDrawingView.drawStaff(withClef: nil, animated: false)
//		drawNewNote(withDelay: 0, animated: false)
//	}
	
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
			// Correct anwser
            managedObjectContext?.performAndWait {
                NoteCorrectness.add(correctAnswer: true, forNote: self.currentNote!, inClef: self.lesson!.clef!, in: self.managedObjectContext!)
            }
            
			staffDrawingView.drawGhostNote(currentNote!, progress: currentProgress)
			currentProgress += 1.0/Float(Constants.RequiredCorrectNotes)
			Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(self.addProgress), userInfo: nil, repeats: false)
			
			if currentProgress < 1.0 {
				previousNote = currentNote
				currentNote = randomNoteFromSet(noteSet!, gauss: lesson!.gauss)
				drawNewNote(withDelay: 0, animated: true)
			} else {
				finishedLesson()
			}
		} else {
            // Wrong anwser
            managedObjectContext?.performAndWait {
                NoteCorrectness.add(correctAnswer: false, forNote: self.currentNote!, inClef: self.lesson!.clef!, in: self.managedObjectContext!)
            }
            
			wrongAnimation()
		}
		
        do {
            try managedObjectContext?.save()
        } catch let error {
            print("BasicClefViewController::onNoteButton::managedObjectContext?.save() -- ", error.localizedDescription)
        }
        
		hideHelpAnimation()
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
			
            if ls.noteSet == nil {
                var set = [Note]()
                managedObjectContext?.performAndWait {
                    set = NoteCorrectness.fetchWorstNotes(inClef: ls.clef!, recordsCount: 10, in: self.managedObjectContext!)!
                }
                noteSet = set
            } else {
                noteSet = ls.noteSet
            }
            
			currentNote = randomNoteFromSet(noteSet!, gauss: lesson!.gauss)
			previousNote = currentNote
			
			startLessonViewsAnimation()
			setupStaffView(lesson!.clef!)
			helpDrawingView.drawHelp(lesson!.clef!)
			
			drawNewNote(withDelay: Constants.BasicAnimationDuration, animated: true)
		}
	}
	
	private func setupStaffView(_ clef: Clef) {
		clefImageView.image = UIImage(named: clef.rawValue)?.withRenderingMode(.alwaysTemplate)
		clefImageView.tintColor = ColorPalette.MidnightBlue
	}
	
	private func resetLesson() {
		clefImageView.layer.sublayers = nil
		notesDrawingView.layer.sublayers = nil
		currentProgress = 0.0
		progressBar.setProgress(currentProgress, animated: false)
		currentNote = nil
		previousNote = nil
		hideHelpAnimation()
	}
    
    // MARK: - Audio Player
    
    private func loadFileIntoAVPlayer(_ note: String) {
        let fileURL:URL = Bundle.main.url(forResource: note, withExtension: "wav", subdirectory: "Audio")!
        
        do {
            self.avPlayer = try AVAudioPlayer(contentsOf: fileURL)
        } catch {
            print("Could not create AVAudioPlayer")
        }
        
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
	
	// MARK: - Helper methods
	
	private func drawNewNote(withDelay delay: TimeInterval, animated: Bool) {
		notesDrawingView.drawNotes([currentNote!])
		if animated {
			noteSlideAnimation(delay)
		}
	}
	
	private func randomNoteFromSet(_ set: [Note], gauss: Bool) -> Note {
		var note: Note
		
		if gauss {
			let noteInRange = GKGaussianDistribution(randomSource: randSource, lowestValue: 0, highestValue: set.count)
			note = set[noteInRange.nextInt()]
		} else {
			note = set[Int(arc4random_uniform(UInt32(set.count)))]
		}
	
		if note == previousNote {
			return randomNoteFromSet(set, gauss: gauss)
		} else {
			return note
		}
	}
	
	private func noteButtonsEnabled(_ enabled: Bool) {
		for button in noteButtons {
			button.isEnabled = enabled
		}
	}
	
	private func finishedLesson() {
		noteButtonsEnabled(false)
		notesDrawingView.isUserInteractionEnabled = false
		notesDrawingView.layer.sublayers = nil
		
		Timer.scheduledTimer(timeInterval: Constants.BasicAnimationDuration, target: self, selector: #selector(self.showFinishedView), userInfo: nil, repeats: false)
	}
	
	// Can't be private if set as selector
	func addProgress() {
		progressBar.setProgress(currentProgress, animated: true)
		let _ = staffDrawingView.layer.sublayers?.popLast()
		
		noteButtonsEnabled(true)
	}
	
	func showFinishedView() {
		resetLesson()
		parentVC!.lessonFinished()
	}
	
	// MARK: - Layout animations
	
	private func wrongAnimation() {
		self.notesDrawingView.center.x += Constants.WrongAnimationOffset
		self.staffDrawingView.center.x += Constants.WrongAnimationOffset
		self.clefImageView.center.x += Constants.WrongAnimationOffset
		
		noteButtonsEnabled(false)
		
		UIView.animate(withDuration: Constants.BasicAnimationDuration, delay: 0.0, usingSpringWithDamping: Constants.WrongAnimationDamping, initialSpringVelocity: Constants.WrongAnimationVelocity, options: [], animations: {
			self.notesDrawingView.center.x -= Constants.WrongAnimationOffset
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
		UIView.animate(withDuration: Constants.BasicAnimationDuration/2, delay: delay, options: [.curveEaseIn], animations: {
			self.notesDrawingView.center.x -= self.view.bounds.width
			}, completion: { finished in
				self.noteVibrateAnimation()
		})
	}
	
	private func noteVibrateAnimation() {
		notesDrawingView.center.x += Constants.NoteVibrateAnimationOffset
		UIView.animate(withDuration: Constants.BasicAnimationDuration, delay: 0.0, usingSpringWithDamping: Constants.NoteVibrateAnimationDamping, initialSpringVelocity: Constants.NoteVibrateAnimationVelocity, options: [], animations: { () -> Void in
			self.notesDrawingView.center.x -= Constants.NoteVibrateAnimationOffset
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
